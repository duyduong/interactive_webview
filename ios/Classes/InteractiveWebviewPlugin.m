#import "InteractiveWebviewPlugin.h"
#import <interactive_webview/interactive_webview-Swift.h>

@implementation InteractiveWebviewPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftInteractiveWebviewPlugin registerWithRegistrar:registrar];
}
@end
