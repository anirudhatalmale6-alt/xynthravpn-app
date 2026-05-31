package com.xynthravpn

import android.app.Activity
import android.content.Intent
import android.net.VpnService
import android.os.Bundle
import android.util.Log
import com.wireguard.android.backend.GoBackend
import com.wireguard.android.backend.Tunnel
import com.wireguard.config.Config
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.BufferedReader
import java.io.StringReader

class MainActivity : FlutterActivity() {

    companion object {
        const val CHANNEL = "com.xynthravpn/vpn"
        const val TAG = "XynthraVPN"
        const val VPN_PREPARE_REQUEST = 10001
    }

    private lateinit var channel: MethodChannel
    private var backend: GoBackend? = null
    private var currentTunnel: XynthraTunnel? = null
    private var pendingConfig: String? = null
    private var pendingResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        backend = GoBackend(applicationContext)

        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "connect" -> {
                    val configStr = call.argument<String>("config")
                    if (configStr == null) {
                        result.error("NO_CONFIG", "Config is required", null)
                        return@setMethodCallHandler
                    }
                    startVpn(configStr, result)
                }
                "disconnect" -> {
                    stopVpn(result)
                }
                "getStatus" -> {
                    result.success(getStatus())
                }
                "getStats" -> {
                    result.success(getStats())
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun startVpn(configStr: String, result: MethodChannel.Result) {
        try {
            val prepareIntent = GoBackend.VpnService.prepare(this)
            if (prepareIntent != null) {
                pendingConfig = configStr
                pendingResult = result
                startActivityForResult(prepareIntent, VPN_PREPARE_REQUEST)
                return
            }
            doConnect(configStr, result)
        } catch (e: Exception) {
            Log.e(TAG, "startVpn error: ${e.message}", e)
            result.error("VPN_ERROR", e.message, null)
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == VPN_PREPARE_REQUEST) {
            val config = pendingConfig
            val result = pendingResult
            pendingConfig = null
            pendingResult = null

            if (resultCode == Activity.RESULT_OK && config != null && result != null) {
                doConnect(config, result)
            } else {
                result?.error("VPN_DENIED", "User denied VPN permission", null)
            }
        }
    }

    private fun doConnect(configStr: String, result: MethodChannel.Result) {
        Thread {
            try {
                if (currentTunnel != null) {
                    try {
                        backend?.setState(currentTunnel!!, Tunnel.State.DOWN, null)
                    } catch (e: Exception) {
                        Log.w(TAG, "Error tearing down existing tunnel: ${e.message}")
                    }
                }

                val config = Config.parse(BufferedReader(StringReader(configStr)))
                val tunnel = XynthraTunnel("xynthra")
                currentTunnel = tunnel

                val state = backend?.setState(tunnel, Tunnel.State.UP, config)
                Log.i(TAG, "Tunnel state: $state")

                runOnUiThread {
                    result.success(mapOf("status" to "connected"))
                }
            } catch (e: Exception) {
                Log.e(TAG, "doConnect error: ${e.message}", e)
                currentTunnel = null
                runOnUiThread {
                    result.error("CONNECT_ERROR", e.message, null)
                }
            }
        }.start()
    }

    private fun stopVpn(result: MethodChannel.Result) {
        Thread {
            try {
                val tunnel = currentTunnel
                if (tunnel != null) {
                    backend?.setState(tunnel, Tunnel.State.DOWN, null)
                    currentTunnel = null
                }
                runOnUiThread {
                    result.success(mapOf("status" to "disconnected"))
                }
            } catch (e: Exception) {
                Log.e(TAG, "stopVpn error: ${e.message}", e)
                runOnUiThread {
                    result.error("DISCONNECT_ERROR", e.message, null)
                }
            }
        }.start()
    }

    private fun getStatus(): Map<String, Any> {
        val tunnel = currentTunnel
        val state = if (tunnel != null) {
            try {
                backend?.getState(tunnel)?.name?.lowercase() ?: "unknown"
            } catch (e: Exception) {
                "unknown"
            }
        } else {
            "down"
        }
        return mapOf("state" to state)
    }

    private fun getStats(): Map<String, Any> {
        val tunnel = currentTunnel
        if (tunnel == null) return emptyMap()
        return try {
            val stats = backend?.getStatistics(tunnel)
            if (stats != null) {
                val peers = stats.peers()
                if (peers.isNotEmpty()) {
                    val peer = peers.first()
                    val peerStats = stats.peer(peer)
                    if (peerStats != null) {
                        mapOf(
                            "rx" to peerStats.rxBytes,
                            "tx" to peerStats.txBytes
                        )
                    } else emptyMap()
                } else emptyMap()
            } else emptyMap()
        } catch (e: Exception) {
            Log.e(TAG, "getStats error: ${e.message}")
            emptyMap()
        }
    }

    class XynthraTunnel(private val tunnelName: String) : Tunnel {
        override fun getName(): String = tunnelName
        override fun onStateChange(newState: Tunnel.State) {
            Log.i(TAG, "Tunnel $tunnelName state changed to $newState")
        }
    }
}
