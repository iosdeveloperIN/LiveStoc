//
//  UKNetworkManager.m
//  UKNetworkManager
//
//  Created by UdayEega on 14/10/17.
//  Copyright © 2017 UdayEega. All rights reserved.
//

#import "UKNetworkManager.h"




NSString *kReachabilityChangedNotification = @"kNetworkReachabilityChangedNotification";
NSString *const FILE_REGISTER=@"provider/register";//register

#pragma mark For Reachability
#define kShouldPrintReachabilityFlags 1

NSString *const USER_DETAILS=@"user_detail";
NSString *const TOKEN=@"token_key";
NSString *const USER_ID=@"user_id";
NSString *const SUCCESS=@"success";

static void PrintReachabilityFlags(SCNetworkReachabilityFlags flags, const char* comment)
{
#if kShouldPrintReachabilityFlags
    
    NSLog(@"Reachability Flag Status: %c%c %c%c%c%c%c%c%c %s\n",
          (flags & kSCNetworkReachabilityFlagsIsWWAN)				? 'W' : '-',
          (flags & kSCNetworkReachabilityFlagsReachable)            ? 'R' : '-',
          
          (flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 't' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'c' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)  ? 'C' : '-',
          (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'D' : '-',
          (flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'l' : '-',
          (flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'd' : '-',
          comment
          );
#endif
}


static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info)
{
#pragma unused (target, flags)
    NSCAssert(info != NULL, @"info was NULL in ReachabilityCallback");
    NSCAssert([(__bridge NSObject*) info isKindOfClass: [UKNetworkManager class]], @"info was wrong class in ReachabilityCallback");
    
    UKNetworkManager* noteObject = (__bridge UKNetworkManager *)info;
    // Post a notification to notify the client that the network reachability changed.
    [[NSNotificationCenter defaultCenter] postNotificationName: kReachabilityChangedNotification object: noteObject];
}
#pragma mark For NetworkManager


static NSOperationQueue * _connectionQueue = nil;
static NSURLSession * _session = nil;


@implementation UKReachability
{
    SCNetworkReachabilityRef _reachabilityRef;

}

#pragma mark Reachability Methods

+ (instancetype)reachabilityWithHostName:(NSString *)hostName
{
    UKReachability* returnValue = NULL;
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, [hostName UTF8String]);
    if (reachability != NULL)
    {
        returnValue= [[self alloc] init];
        if (returnValue != NULL)
        {
            returnValue->_reachabilityRef = reachability;
        }
        else {
            CFRelease(reachability);
        }
    }
    return returnValue;
}


+ (instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress
{
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, hostAddress);
    
    UKReachability* returnValue = NULL;
    
    if (reachability != NULL)
    {
        returnValue = [[self alloc] init];
        if (returnValue != NULL)
        {
            returnValue->_reachabilityRef = reachability;
        }
        else {
            CFRelease(reachability);
        }
    }
    return returnValue;
}


+ (instancetype)reachabilityForInternetConnection
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    return [self reachabilityWithAddress: (const struct sockaddr *) &zeroAddress];
}

- (BOOL)startNotifier
{
    BOOL returnValue = NO;
    SCNetworkReachabilityContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    
    if (SCNetworkReachabilitySetCallback(_reachabilityRef, ReachabilityCallback, &context))
    {
        if (SCNetworkReachabilityScheduleWithRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode))
        {
            returnValue = YES;
        }
    }
    
    return returnValue;
}


- (void)stopNotifier
{
    if (_reachabilityRef != NULL)
    {
        SCNetworkReachabilityUnscheduleFromRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    }
}


- (void)dealloc
{
    [self stopNotifier];
    if (_reachabilityRef != NULL)
    {
        CFRelease(_reachabilityRef);
    }
}

- (NetworkStatus)networkStatusForFlags:(SCNetworkReachabilityFlags)flags
{
    PrintReachabilityFlags(flags, "networkStatusForFlags");
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
    {
        // The target host is not reachable.
        return NotReachable;
    }
    
    NetworkStatus returnValue = NotReachable;
    
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
    {
        /*
         If the target host is reachable and no connection is required then we'll assume (for now) that you're on Wi-Fi...
         */
        returnValue = ReachableViaWiFi;
    }
    
    if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
         (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
    {
        /*
         ... and the connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs...
         */
        
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
        {
            /*
             ... and no [user] intervention is needed...
             */
            returnValue = ReachableViaWiFi;
        }
    }
    
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
    {
        /*
         ... but WWAN connections are OK if the calling application is using the CFNetwork APIs.
         */
        returnValue = ReachableViaWWAN;
    }
    
    return returnValue;
}


- (BOOL)connectionRequired
{
    NSAssert(_reachabilityRef != NULL, @"connectionRequired called with NULL reachabilityRef");
    SCNetworkReachabilityFlags flags;
    
    if (SCNetworkReachabilityGetFlags(_reachabilityRef, &flags))
    {
        return (flags & kSCNetworkReachabilityFlagsConnectionRequired);
    }
    
    return NO;
}


- (NetworkStatus)currentReachabilityStatus
{
    NSAssert(_reachabilityRef != NULL, @"currentNetworkStatus called with NULL SCNetworkReachabilityRef");
    NetworkStatus returnValue = NotReachable;
    SCNetworkReachabilityFlags flags;
    
    if (SCNetworkReachabilityGetFlags(_reachabilityRef, &flags))
    {
        returnValue = [self networkStatusForFlags:flags];
    }
    
    return returnValue;
}

+ (BOOL)isDataSourceAvailable
{
    BOOL isDataSourceAvailable=NO;
//    static BOOL checkNetwork = YES;
//    if (checkNetwork) { // Since checking the reachability of a host can be expensive, cache the result and perform the reachability check once.
//        checkNetwork = NO;
    
        Boolean success;
        const char *host_name = "www.google.com"; // your data source host name
        
        SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host_name);
        SCNetworkReachabilityFlags flags;
        success = SCNetworkReachabilityGetFlags(reachability, &flags);
        isDataSourceAvailable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
        CFRelease(reachability);
//    }
    return isDataSourceAvailable;
}


@end

#pragma mark NetworkManager Methods

@implementation UKNetworkManager

+ (NSOperationQueue *) connectionQueue
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_connectionQueue)
        {
            _connectionQueue = [[NSOperationQueue alloc] init];
            
        }
    });
    return _connectionQueue;
}


static UKNetworkManager *instance = nil;

+(UKNetworkManager*)UKInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [UKNetworkManager new];
        }
    }
    return instance;
}



+ (void) createURLSession
{
    static dispatch_once_t onceToken;
    
    if (!_session)
    {
        dispatch_once(&onceToken, ^{
            _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        });
    }
}



    
+(void)operationType:(RequestType)method fromPath:(NSString *)path withParameters:(NSMutableDictionary *)paramDict withUploadData:(NSMutableDictionary *)imagesDataDict :(SuccessBlock)successBlock :(FailureBlock)failureBlock
{
    if ([UKReachability isDataSourceAvailable]) {
        
        switch (method) {
            case GET:
            {
                [self createURLSession];
                
                NSMutableString *urlString=[[NSMutableString alloc] init];
                
                for (NSString *key in [paramDict allKeys]) {
                
                    [urlString appendString:[NSString stringWithFormat:@"%@=%@&",key,[paramDict valueForKey:key]]];
                
                }
                if (urlString.length>0) {
                    urlString=[urlString substringToIndex:urlString.length-1].mutableCopy;
                }
                
                NSURL *url=[NSURL URLWithString:[[NSString stringWithFormat:@"%@%@%@",API_URL,path,urlString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
                
                NSURLSessionDataTask *dataTask=[_session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    
                    
                    if (response != nil)
                    {
                        if ([[self acceptableStatusCodes] containsIndex:[(NSHTTPURLResponse *)response statusCode]])
                        {
                            if ([data length] > 0)
                            {
                                NSError * jsonError  = nil;
                                id jsonObject  = nil;
                                
                                jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                                
                                // If Response is Not JSON implement this LATER*****
                                
                                
//                                if (jsonObject != nil)
//                                {
//                                    [self presentData:jsonObject :successBlock];
//                                }
//                                else
//                                {
//                                    
//                                    [self presentError:jsonError message:@"" :failureBlock];
//
//                                }
                                
                                [self presentData:jsonObject :successBlock];

                                
                            }
                            else
                            {
                                [self presentError:error message:@"Unable to connect, Please try later." :failureBlock];
                            }
                        }
                        else
                        {
                            
                            if ([(NSHTTPURLResponse *)response statusCode] == 0) {
                                
                                [self presentError:error message:@"It appears you are not connected to the Internet" :failureBlock];
                                
                            }
                            else if ([(NSHTTPURLResponse *)response statusCode] == 404 || [(NSHTTPURLResponse *)response statusCode] >= 500)
                            {
                                
                                [self presentError:error message:@"The server is currently Unavailable." :failureBlock];

                            }
                            else
                            {
                                [self presentError:error message:@"Unable to connect, Please try later." :failureBlock];

                            }
                            
                        }
                    }
                    else
                    {
                        
                        // If repsonse is nil *********
                        
                        [self presentError:error message:@"Unable to connect, Please try later." :failureBlock];
                    }
                }];
                
                [dataTask resume];
                
                
                break;
            }
            case POST:
            {

                NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_URL,path]];
                
                NSString *boundary = [self generateBoundaryString];
                
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
                [request setHTTPMethod:@"POST"];
                
                NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
                [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
                
                NSMutableData *httpBody=[NSMutableData data];
                
                
                for (NSString *key in [paramDict allKeys]) {
                    
                    
                    [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";",key] dataUsingEncoding:NSUTF8StringEncoding]];
                    [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: text/plain\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                    [httpBody appendData:[[paramDict valueForKey:key] dataUsingEncoding:NSUTF8StringEncoding]];
                    [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                    
                }
                
                [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                
                
                [request setHTTPBody:httpBody];
                
                [self createURLSession];

                
                
                NSURLSessionDataTask *dataTask=[_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)  {
                    
                   
                    if (response != nil)
                    {
                        if ([[self acceptableStatusCodes] containsIndex:[(NSHTTPURLResponse *)response statusCode]])
                        {
                            if ([data length] > 0)
                            {
                                NSError * jsonError  = nil;
                                id jsonObject  = nil;
                                
                                jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                                
                                // If Response is Not JSON implement this LATER*****
                                
                                
                                //                                if (jsonObject != nil)
                                //                                {
                                //                                    [self presentData:jsonObject :successBlock];
                                //                                }
                                //                                else
                                //                                {
                                //
                                //                                    [self presentError:jsonError message:@"" :failureBlock];
                                //
                                //                                }
                                
                                [self presentData:jsonObject :successBlock];
                                
                                
                            }
                            else
                            {
                                [self presentError:error message:@"Unable to connect, Please try later." :failureBlock];
                            }
                        }
                        else
                        {
                            
                            if ([(NSHTTPURLResponse *)response statusCode] == 0) {
                                
                                [self presentError:error message:@"It appears you are not connected to the Internet" :failureBlock];
                                
                            }
                            else if ([(NSHTTPURLResponse *)response statusCode] == 404 || [(NSHTTPURLResponse *)response statusCode] >= 500)
                            {
                                
                                [self presentError:error message:@"The server is currently Unavailable." :failureBlock];
                                
                            }
                            else
                            {
                                [self presentError:error message:@"Unable to connect, Please try later." :failureBlock];
                                
                            }
                            
                        }
                    }
                    else
                    {
                        
                        // If repsonse is nil *********
                        
                        [self presentError:error message:@"Unable to connect, Please try later." :failureBlock];
                    }
                }];
                
                
                [dataTask resume];

                break;
            }
            case UPLOAD:
            {
                
                NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_URL,path]];
                
                NSString *boundary = [self generateBoundaryString];
                
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
                [request setHTTPMethod:@"POST"];
                
                NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
                [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
                
                NSMutableData *httpBody=[NSMutableData data];
                
                
                for (NSString *key in [paramDict allKeys]) {
                    
                    
                    [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";",key] dataUsingEncoding:NSUTF8StringEncoding]];
                    [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: text/plain\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                    [httpBody appendData:[[paramDict valueForKey:key] dataUsingEncoding:NSUTF8StringEncoding]];
                    [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                    
                }
                
                
                
                for (NSString *key in [imagesDataDict allKeys]) {
                    
                    [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n",key,key] dataUsingEncoding:NSUTF8StringEncoding]];
                    [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n",[self mimeTypeForData:[imagesDataDict valueForKey:key]]] dataUsingEncoding:NSUTF8StringEncoding]];
                    [httpBody appendData:[imagesDataDict valueForKey:key]];
                    [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                    
                }
                
                
                [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                
                [self createURLSession];
                
                
                
                NSURLSessionDataTask *uploadTask=[_session uploadTaskWithRequest:request fromData:httpBody completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    
                    
                    if (response != nil)
                    {
                        if ([[self acceptableStatusCodes] containsIndex:[(NSHTTPURLResponse *)response statusCode]])
                        {
                            if ([data length] > 0)
                            {
                                NSError * jsonError  = nil;
                                id jsonObject  = nil;
                                
                                jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                                
                                // If Response is Not JSON implement this LATER*****
                                
                                
                                //                                if (jsonObject != nil)
                                //                                {
                                //                                    [self presentData:jsonObject :successBlock];
                                //                                }
                                //                                else
                                //                                {
                                //
                                //                                    [self presentError:jsonError message:@"" :failureBlock];
                                //
                                //                                }
                                
                                [self presentData:jsonObject :successBlock];
                                
                                
                            }
                            else
                            {
                                [self presentError:error message:@"Unable to connect, Please try later." :failureBlock];
                            }
                        }
                        else
                        {
                            
                            if ([(NSHTTPURLResponse *)response statusCode] == 0) {
                                
                                [self presentError:error message:@"It appears you are not connected to the Internet" :failureBlock];
                                
                            }
                            else if ([(NSHTTPURLResponse *)response statusCode] == 404 || [(NSHTTPURLResponse *)response statusCode] >= 500)
                            {
                                
                                [self presentError:error message:@"The server is currently Unavailable." :failureBlock];
                                
                            }
                            else
                            {
                                [self presentError:error message:@"Unable to connect, Please try later." :failureBlock];
                                
                            }
                            
                        }
                    }
                    else
                    {
                        
                        // If repsonse is nil *********
                        
                        [self presentError:error message:@"Unable to connect, Please try later." :failureBlock];
                    }
                }];
                
                
                [uploadTask resume];
                break;
            }
            case OTHER:
            {
                [self createURLSession];
                
                NSMutableString *urlString=[[NSMutableString alloc] init];
                
                for (NSString *key in [paramDict allKeys]) {
                    
                    [urlString appendString:[NSString stringWithFormat:@"%@=%@&",key,[paramDict valueForKey:key]]];
                    
                }
                if (urlString.length>0) {
                    urlString=[urlString substringToIndex:urlString.length-1].mutableCopy;
                }
                
                NSURL *url=[NSURL URLWithString:[[NSString stringWithFormat:@"%@?%@",path,urlString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
                
                NSURLSessionDataTask *dataTask=[_session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    
                    
                    if (response != nil)
                    {
                        if ([[self acceptableStatusCodes] containsIndex:[(NSHTTPURLResponse *)response statusCode]])
                        {
                            if ([data length] > 0)
                            {
                                NSError * jsonError  = nil;
                                id jsonObject  = nil;
                                
                                jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                                
                                // If Response is Not JSON implement this LATER*****
                                
                                
                                //                                if (jsonObject != nil)
                                //                                {
                                //                                    [self presentData:jsonObject :successBlock];
                                //                                }
                                //                                else
                                //                                {
                                //
                                //                                    [self presentError:jsonError message:@"" :failureBlock];
                                //
                                //                                }
                                
                                [self presentData:jsonObject :successBlock];
                                
                                
                            }
                            else
                            {
                                [self presentError:error message:@"Unable to connect, Please try later." :failureBlock];
                            }
                        }
                        else
                        {
                            
                            if ([(NSHTTPURLResponse *)response statusCode] == 0) {
                                
                                [self presentError:error message:@"It appears you are not connected to the Internet" :failureBlock];
                                
                            }
                            else if ([(NSHTTPURLResponse *)response statusCode] == 404 || [(NSHTTPURLResponse *)response statusCode] >= 500)
                            {
                                
                                [self presentError:error message:@"The server is currently Unavailable." :failureBlock];
                                
                            }
                            else
                            {
                                [self presentError:error message:@"Unable to connect, Please try later." :failureBlock];
                                
                            }
                            
                        }
                    }
                    else
                    {
                        
                        // If repsonse is nil *********
                        
                        [self presentError:error message:@"Unable to connect, Please try later." :failureBlock];
                    }
                }];
                
                [dataTask resume];
                
                
                break;
            }
                
            default:
            {
                [self createURLSession];

        
                
                break;
            }
        }
        
    } else {
        
        [self presentError:nil message:@"No Internet Access" :failureBlock];
    }
}
+ (NSString *)generateBoundaryString
{
    return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
}
+(NSString *)mimeTypeForData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
            break;
        case 0x89:
            return @"image/png";
            break;
        case 0x47:
            return @"image/gif";
            break;
        case 0x49:
        case 0x4D:
            return @"image/tiff";
            break;
        case 0x25:
            return @"application/pdf";
            break;
        case 0xD0:
            return @"application/vnd";
            break;
        case 0x46:
            return @"text/plain";
            break;
        default:
            return @"application/octet-stream";
    }
    return nil;
}

-(void)getRequest:(NSMutableURLRequest *)request
{
    
}

+ (NSIndexSet *) acceptableStatusCodes
{
    return [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 99)];
}

+ (void) presentData:(id)jsonObject :(SuccessBlock) block
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:
     ^{
         block(jsonObject);
     }];
}

+ (void) presentError:(NSError *)error message:(NSString *)errorMessage :(FailureBlock) block
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:
     ^{
         block(error,errorMessage);
     }];
}
+(void)saveToDefaults:(id)all withKeyString:(NSString *)keyString
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setValue:all forKey:keyString];
    
    [defaults synchronize];
}

+(id)getFromDefaultsWithKeyString:(NSString *)string
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:string];
}

+(void)removeFromDefaultsWithKeyStr:(NSString *)key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}
+(void)showAlertWithTitle:(NSString *)title messageTitle:(NSString *)msg okTitle:(NSString *)ok cancelTitle:(NSString *)cancel otherTitles:(NSString *)other
{
    [[[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancel otherButtonTitles:other, nil] show];
}

@end






