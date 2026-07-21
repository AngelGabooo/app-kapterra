package com.kaabterra.mobile

import io.flutter.embedding.android.FlutterFragmentActivity  // ✅ CAMBIAR
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterFragmentActivity() {  // ✅ CAMBIAR
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }
}