//
//  AppDelegate.m
//  UniLoginDemo
//
//  Created by 乔春晓 on 2021/2/17.
//

#import "AppDelegate.h"
#import "WXLoginManager.h"
#import "WXApi.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // wxe7e0f1aba86cb4ce https://www.emay.cn/article957.html
    [WXApi registerApp:@"wxe7e0f1aba86cb4ce" universalLink:@"https://www.emay.cn/"];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXLoginManager shareManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:[WXLoginManager shareManager]];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler {
    return [WXApi handleOpenUniversalLink:userActivity delegate:[WXLoginManager shareManager]];
}


- (BOOL)application:(UIApplication*)app openURL:(NSURL*)url options: (NSDictionary<NSString*, id>*)options {
    return [WXApi handleOpenURL:url delegate:[WXLoginManager shareManager]];
}


@end
