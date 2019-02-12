//
//  AvidlyReachability.h
//  AvidlyAdsSDK
//
//  Created by samliu on 2017/4/19.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

typedef enum : NSInteger {
    XhanceNetNotReachable = 0,
    XhanceNetReachableViaWiFi,
    XhanceNetReachableViaWWAN
} XhanceNetWorkStatus;

#pragma mark - IPv6 Support

extern NSString *kXhanceNetReachabilityChangedNotification;

@interface XhanceNetReachability : NSObject
/*!
 * Use to check the reachability of a given host name.
 */
+ (instancetype)reachabilityWithHostName:(NSString *)hostName;

/*!
 * Use to check the reachability of a given IP address.
 */
+ (instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress;

/*!
 * Checks whether the default route is available. Should be used by applications that do not connect to a particular host.
 */
+ (instancetype)reachabilityForInternetConnection;


#pragma mark - reachabilityForLocalWiFi
//reachabilityForLocalWiFi has been removed from the sample.  See ReadMe.md for more information.
//+ (instancetype)reachabilityForLocalWiFi;

/*!
 * Start listening for reachability notifications on the current run loop.
 */
- (BOOL)startNotifier;

- (void)stopNotifier;

- (XhanceNetWorkStatus)currentReachabilityStatus;

/*!
 * WWAN may be available, but not active until a connection has been established. WiFi may require a connection for VPN on Demand.
 */
- (BOOL)connectionRequired;

@end
