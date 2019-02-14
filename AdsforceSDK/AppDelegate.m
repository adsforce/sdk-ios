//
//  AppDelegate.m
//  XhanceSDK
//
//  Created by steve on 2018/4/12.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "AdsforceSDK.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 测试，正式环境
    NSString *devKey = @"o2104e0adf8334e2a9be6cd317ee97b4a";
    NSString *publicKey = @"MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBANojS8hhQjex7TPS4MQjQEoyzvshnErI+orLdDI0PXGpEE8j3syLZ4q6yNLyRDQnaUEHItfZyGa4VxWF21qoeC8CAwEAAQ==";
    NSString *trackUrl = @"https://track-jx.upltv.com";
    NSString *channelId = @"32400";
    NSString *appid = @"id1111111111";
    [AdsforceSDK initWithDevKey:devKey publicKey:publicKey trackUrl:trackUrl channelId:channelId appId:appid];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    ViewController *vc = [[ViewController alloc] init];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
