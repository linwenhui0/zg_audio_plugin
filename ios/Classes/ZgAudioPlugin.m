#import "ZgAudioPlugin.h"

@implementation ZgAudioPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"zg_audio_plugin"
            binaryMessenger:[registrar messenger]];
  ZgAudioPlugin* instance = [[ZgAudioPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"initSDK" isEqualToString:call.method]) {
    result([[NSNumber alloc] initWithBool:true]);
  } else if([@"login" isEqualToString:call.method]) {
    result([[NSNumber alloc] initWithBool:true]);
  } else if([@"logout" isEqualToString:call.method]) {
    result([[NSNumber alloc] initWithBool:true]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
