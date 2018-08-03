//
//  UKNetworkManager.h
//  UKNetworkManager
//
//  Created by UdayEega on 14/10/17.
//  Copyright © 2017 UdayEega. All rights reserved.
//


#import <SystemConfiguration/SystemConfiguration.h>
#import <CoreFoundation/CoreFoundation.h>
#import <time.h>
#import <CoreLocation/CoreLocation.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <objc/runtime.h>
#import <Foundation/Foundation.h>

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define SYSTEM_VERSION_LESS_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)



extern NSString *const USER_DETAILS;
extern NSString *const TOKEN;
extern NSString *const USER_ID;
extern NSString *const SUCCESS;

@interface UKReachability : NSObject



typedef enum : NSInteger {
    NotReachable = 0,
    ReachableViaWiFi,
    ReachableViaWWAN
} NetworkStatus;

extern NSString *kReachabilityChangedNotification;

#pragma mark Reachability Methods

+ (instancetype)reachabilityWithHostName:(NSString *)hostName;
+ (instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress;
+ (instancetype)reachabilityForInternetConnection;


#pragma mark reachabilityForLocalWiFi

- (BOOL)startNotifier;
- (void)stopNotifier;
- (NetworkStatus)currentReachabilityStatus;
- (BOOL)connectionRequired;


@end



#pragma mark For NetworkManager


@interface UKNetworkManager : NSObject<UIAlertViewDelegate>
//{
//    NSMutableDictionary *animalSelectionDict;
//}

#define API_URL @"http://livestoc.com/webservices/"

typedef enum {
    GET,
    POST,
    DOWNLOAD,
    UPLOAD,
    OTHER
}RequestType;




typedef void (^SuccessBlock)(id result);
typedef void (^FailureBlock)(NSError * error,NSString *errorMessage);

#pragma mark NetworkManager Methods

+ (void)operationType:(RequestType)method fromPath: (NSString *) path withParameters:(NSMutableDictionary *)paramDict withUploadData:(NSMutableDictionary *)imagesDataDict : (SuccessBlock) successBlock :(FailureBlock) failureBlock;


#pragma mark CLLocationManager






#pragma mark Global Classs Variables




+(UKNetworkManager*)UKInstance;
+(void)showAlertWithTitle:(NSString *)title messageTitle:(NSString *)msg okTitle:(NSString *)ok cancelTitle:(NSString *)cancel otherTitles:(NSString *)other;
+(void)saveToDefaults:(id)all withKeyString:(NSString *)keyString;
+(id)getFromDefaultsWithKeyString:(NSString *)string;
+(void)removeFromDefaultsWithKeyStr:(NSString *)key;
//+(void)enableLocation:(CLLocationManager *)location;


+(void)showAlertWithTitle:(NSString *)title messageTitle:(NSString *)msg okTitle:(NSString *)ok cancelTitle:(NSString *)cancel otherTitles:(NSString *)other withTag:(NSInteger)tag;

@end

