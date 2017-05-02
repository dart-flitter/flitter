package io.flutter.plugins;

import io.flutter.app.FlutterActivity;

import com.flutter_webview_plugin.FlutterWebviewPlugin;

/**
 * Generated file. Do not edit.
 */

public class PluginRegistry {
    public FlutterWebviewPlugin flutter_webview_plugin;

    public void registerAll(FlutterActivity activity) {
        flutter_webview_plugin = FlutterWebviewPlugin.register(activity);
    }
}
