//
//  Generated file. Do not edit.
//

#import "PluginRegistry.h"

@implementation PluginRegistry

- (instancetype)initWithController:(FlutterViewController *)controller {
  if (self = [super init]) {
    _flutter_webview_plugin = [[FlutterWebviewPlugin alloc] initWithController:controller];
    _shared_preferences = [[SharedPreferencesPlugin alloc] initWithController:controller];
  }
  return self;
}

@end
