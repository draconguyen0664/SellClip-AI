package com.example.sellclip_ai_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterActivityLaunchConfigs.BackgroundMode

class MainActivity : FlutterActivity() {
    override fun getBackgroundMode(): BackgroundMode {
        return BackgroundMode.opaque
    }
}
