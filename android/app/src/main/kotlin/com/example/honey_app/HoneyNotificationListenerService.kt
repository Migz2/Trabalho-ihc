package com.example.honey_app

import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log

private const val PREFS_NAME = "honey_block_prefs"
private const val KEY_ACTIVE = "blocking_active"
private const val KEY_PACKAGES = "blocked_packages"
private const val TAG = "HoneyNotifListener"

class HoneyNotificationListenerService : NotificationListenerService() {
    override fun onListenerConnected() {
        super.onListenerConnected()
        Log.d(TAG, "onListenerConnected")
    }

    override fun onNotificationPosted(sbn: StatusBarNotification) {
        val prefs = applicationContext.getSharedPreferences(PREFS_NAME, MODE_PRIVATE)
        val active = prefs.getBoolean(KEY_ACTIVE, false)
        val blocked = prefs.getStringSet(KEY_PACKAGES, emptySet()) ?: emptySet()
        Log.d(TAG, "posted pkg=${sbn.packageName} active=$active blocked=$blocked")
        if (!active) return
        if (sbn.packageName in blocked) {
            Log.d(TAG, "cancelling notification from ${sbn.packageName}")
            cancelNotification(sbn.key)
        }
    }
}
