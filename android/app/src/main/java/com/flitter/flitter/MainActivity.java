package com.flitter.flitter;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.PluginRegistry;

public class MainActivity extends FlutterActivity {
    private PluginRegistry pluginRegistry;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        pluginRegistry = new PluginRegistry();
        pluginRegistry.registerAll(this);
    }
}

