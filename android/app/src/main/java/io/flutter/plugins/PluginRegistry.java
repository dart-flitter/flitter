package io.flutter.plugins;

import io.flutter.app.FlutterActivity;

import com.flutter_webview_plugin.FlutterWebviewPlugin;
import io.flutter.plugins.shared_preferences.SharedPreferencesPlugin;

/**
 * Generated file. Do not edit.
 */

public class PluginRegistry {
    public FlutterWebviewPlugin flutter_webview_plugin;
    public SharedPreferencesPlugin shared_preferences;

    public void registerAll(FlutterActivity activity) {
        flutter_webview_plugin = FlutterWebviewPlugin.register(activity);
        shared_preferences = SharedPreferencesPlugin.register(activity);
    }
}
