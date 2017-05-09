//
//  Generated file. Do not edit.
//

#ifndef PluginRegistry_h
#define PluginRegistry_h

#import <Flutter/Flutter.h>

#import "FlutterWebviewPlugin.h"
#import "SharedPreferencesPlugin.h"

@interface PluginRegistry : NSObject

@property (readonly, nonatomic) FlutterWebviewPlugin *flutter_webview_plugin;
@property (readonly, nonatomic) SharedPreferencesPlugin *shared_preferences;

- (instancetype)initWithController:(FlutterViewController *)controller;

@end

#endif /* PluginRegistry_h */
