package io.flutter.flutter_webview_plugin;

import io.flutter.plugin.common.FlutterMethodChannel;
import io.flutter.plugin.common.MethodCall;

/**
 * Created by lejard_h on 16/04/2017.
 */

public class FlutterWebviewPlugin implements FlutterMethodChannel.MethodCallHandler {

    private FlutterView flutterView;

    public static FlutterWebviewPlugin register(FlutterActivity activity) {
        return new FlutterWebviewPlugin(activity);
    }

    private FlutterWebviewPlugin(FlutterActivity activity) {
        flutterView = activity.getFlutterView();
        new FlutterMethodChannel(flutterView, "flutter_webview_plugin").setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(MethodCall methodCall, FlutterMethodChannel.Response response) {
        response.notImplemented();
    }
}
