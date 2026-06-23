package com.example.honey_app

import android.app.AppOpsManager
import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.Drawable
import android.net.Uri
import android.os.Build
import android.os.Process
import android.provider.Settings
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

private const val PREFS_NAME = "honey_block_prefs"
private const val KEY_ACTIVE = "blocking_active"
private const val KEY_PACKAGES = "blocked_packages"
private const val ICON_SIZE_PX = 96

class MainActivity : FlutterActivity() {
    private val channelName = "com.honey.app/app_blocking"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "hasUsageStatsPermission" -> result.success(hasUsageStatsPermission())
                    "getInstalledApps" -> result.success(getInstalledApps())
                    "getForegroundApp" -> result.success(getForegroundApp())
                    "bringToForeground" -> {
                        bringToForeground()
                        result.success(null)
                    }
                    "hasNotificationListenerPermission" ->
                        result.success(hasNotificationListenerPermission())
                    "requestNotificationListenerPermission" -> {
                        startActivity(
                            Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS)
                                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        )
                        result.success(null)
                    }
                    "hasOverlayPermission" -> result.success(Settings.canDrawOverlays(this))
                    "requestOverlayPermission" -> {
                        startActivity(
                            Intent(
                                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                                Uri.parse("package:$packageName")
                            ).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        )
                        result.success(null)
                    }
                    "setBlockingState" -> {
                        val active = call.argument<Boolean>("active") ?: false
                        @Suppress("UNCHECKED_CAST")
                        val packages = (call.argument<List<String>>("blockedPackages") ?: emptyList())
                        setBlockingState(active, packages)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun hasUsageStatsPermission(): Boolean {
        val appOps = getSystemService(APP_OPS_SERVICE) as AppOpsManager
        val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            appOps.unsafeCheckOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS, Process.myUid(), packageName
            )
        } else {
            @Suppress("DEPRECATION")
            appOps.checkOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS, Process.myUid(), packageName
            )
        }
        return mode == AppOpsManager.MODE_ALLOWED
    }

    private fun drawableToPngBytes(drawable: Drawable): ByteArray {
        val bitmap = Bitmap.createBitmap(ICON_SIZE_PX, ICON_SIZE_PX, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        drawable.setBounds(0, 0, ICON_SIZE_PX, ICON_SIZE_PX)
        drawable.draw(canvas)
        val stream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
        return stream.toByteArray()
    }

    private fun getInstalledApps(): List<Map<String, Any>> {
        val pm = packageManager
        val launcherIntent = Intent(Intent.ACTION_MAIN)
        launcherIntent.addCategory(Intent.CATEGORY_LAUNCHER)
        val resolved = pm.queryIntentActivities(launcherIntent, PackageManager.MATCH_ALL)

        val seen = HashSet<String>()
        val apps = mutableListOf<Map<String, Any>>()
        for (info in resolved) {
            val pkg = info.activityInfo.packageName
            if (pkg == packageName || !seen.add(pkg)) continue
            val label = info.loadLabel(pm).toString()
            val icon = try {
                drawableToPngBytes(info.loadIcon(pm))
            } catch (e: Exception) {
                null
            }
            val app = mutableMapOf<String, Any>("appName" to label, "packageName" to pkg)
            if (icon != null) app["icon"] = icon
            apps.add(app)
        }
        return apps.sortedBy { (it["appName"] as String).lowercase() }
    }

    private fun getForegroundApp(): String? {
        val usm = getSystemService(USAGE_STATS_SERVICE) as UsageStatsManager
        val end = System.currentTimeMillis()
        val begin = end - 10_000
        val events = usm.queryEvents(begin, end)
        var lastPkg: String? = null
        val event = UsageEvents.Event()
        while (events.hasNextEvent()) {
            events.getNextEvent(event)
            @Suppress("DEPRECATION")
            if (event.eventType == UsageEvents.Event.MOVE_TO_FOREGROUND) {
                lastPkg = event.packageName
            }
        }
        return lastPkg
    }

    private fun bringToForeground() {
        val launchIntent = packageManager.getLaunchIntentForPackage(packageName) ?: return
        launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_REORDER_TO_FRONT)
        startActivity(launchIntent)
    }

    private fun hasNotificationListenerPermission(): Boolean {
        return NotificationManagerCompat.getEnabledListenerPackages(this).contains(packageName)
    }

    private fun setBlockingState(active: Boolean, packages: List<String>) {
        getSharedPreferences(PREFS_NAME, MODE_PRIVATE).edit()
            .putBoolean(KEY_ACTIVE, active)
            .putStringSet(KEY_PACKAGES, packages.toSet())
            .apply()
    }
}
