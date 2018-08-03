//
//  UKLocationManager.m
//  LiveStoc
//
//  Created by Harjit Singh on 12/18/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import "UKLocationManager.h"
#define LATITUDE @"latitude"
#define LONGITUDE @"longitude"
#define ACCURACY @"theAccuracy"
UIAlertView *alertView;

@implementation UKLocationManager
@synthesize isFirstTime;


+(void)showAlertWithTitle:(NSString *)title messageTitle:(NSString *)msg okTitle:(NSString *)ok cancelTitle:(NSString *)cancel otherTitles:(NSString *)other withTag:(NSInteger)tag
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:msg delegate:[UKNetworkManager UKInstance] cancelButtonTitle:cancel otherButtonTitles:ok,other, nil];
    alert.tag=tag;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    if (_delegate) {
    //
    //        if ([_delegate respondsToSelector:@selector(UKAlertView:clickedButtonIndex:)]) {
    //
    //            [_delegate UKAlertView:alertView clickedButtonIndex:buttonIndex];
    //
    //        }
    //    }
    
    
    if(buttonIndex!=[alertView cancelButtonIndex])//Settings button pressed
    {
        if (alertView.tag == 100)
        {
            //This will open ios devices location settings
            NSString *url=SYSTEM_VERSION_LESS_THAN(@"10.0") ? @"prefs:root=LOCATION_SERVICES" : @"App-Prefs:root=Privacy&path=LOCATION";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
        }
        else if (alertView.tag == 200)
        {
            //This will opne particular app location settings
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

+ (CLLocationManager *)sharedLocationManager {
    static CLLocationManager *_locationManager;
    
    @synchronized(self) {
        if (_locationManager == nil) {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
//          _locationManager.allowsBackgroundLocationUpdates = YES;
            _locationManager.pausesLocationUpdatesAutomatically = NO;
        }
    }
    return _locationManager;
}
//instance.myLocationArray=[NSMutableArray array];

-(void)startLocationTracking
{
    CLLocationManager *locationManager = [UKLocationManager sharedLocationManager];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    isFirstTime=YES;
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [locationManager requestWhenInUseAuthorization];
    }
//    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
//        [locationManager requestAlwaysAuthorization];
//    }
    
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        [self showAlertForLocationAuthorization];
//        isFirstTime=NO;

        return;
    }
    else
    {
        [locationManager startUpdatingLocation];
    }
    
    //    if ([CLLocationManager headingAvailable])
    //    {
    //
    //        [locationManager startUpdatingHeading];
    //    }
    
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    CLLocationManager *locationManager = [UKLocationManager sharedLocationManager];
    if (status==0 ||status==1 ||status==2) {
        [locationManager stopUpdatingLocation];
        if (isFirstTime)
        {
            isFirstTime=NO;
        }
        else
        {
            [self showAlertForLocationAuthorization];
        }
    } else{
        [locationManager startUpdatingLocation];
    }
}
-(void)stopLocation
{
    CLLocationManager *locationManager = [UKLocationManager sharedLocationManager];
    [locationManager stopUpdatingLocation];
}
-(void)showAlertForLocationAuthorization
{
    alertView=[[UIAlertView alloc] initWithTitle:![CLLocationManager locationServicesEnabled] ?  @"Location Services Disabled!" : @"Allow LiveStoc to Access Location!"  message:![CLLocationManager locationServicesEnabled] ?  @"Please enable Location Based Services for better results! We promise to keep your location private": @"Please Allow LiveStoc to Access Location Based Services for better results! We promise to keep your location private" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Settings", nil];
    
    if (![CLLocationManager locationServicesEnabled])
    {
        alertView.tag = 100;
    }
    else
    {
        alertView.tag = 200;
    }
    
    [alertView show];
}

#pragma mark - CLLocationManagerDelegate Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    NSLog(@"locationManager didUpdateLocations");
    
//    for(int i=0;i<locations.count;i++){
        CLLocation * newLocation = [locations lastObject];
        CLLocationCoordinate2D theLocation = newLocation.coordinate;
//        CLLocationAccuracy theAccuracy = newLocation.horizontalAccuracy;
//        
//        NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
        
//        if (locationAge < 30.0)
//        {
//            return;
//        }
//
//        //Select only valid location and also location with good accuracy
//        if(newLocation!=nil&&theAccuracy>0
//           &&theAccuracy<100
//           &&(!(theLocation.latitude==0.0&&theLocation.longitude==0.0))){
//
//            self.myLastLocation = theLocation;
//            self.myLastLocationAccuracy= theAccuracy;
//
//            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
//            [dict setObject:[NSNumber numberWithFloat:theLocation.latitude] forKey:@"latitude"];
//            [dict setObject:[NSNumber numberWithFloat:theLocation.longitude] forKey:@"longitude"];
//            [dict setObject:[NSNumber numberWithFloat:theAccuracy] forKey:@"theAccuracy"];
    
            if (_delegate) {
                if ([_delegate respondsToSelector:@selector(accurateFinalLocation:)]) {
                    [_delegate accurateFinalLocation:theLocation];
                }
//                _delegate=nil;
            }
            //Add the vallid location with good accuracy into an array
            //Every 1 minute, I will select the best location based on accuracy and send to server
//            [self.myLocationArray addObject:dict];
//        }
//    }
}
//    //If the timer still valid, return it (Will not run the code below)
//    if (self.shareModel.timer) {
//        return;
//    }
//
//    self.shareModel.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
//    [self.shareModel.bgTask beginNewBackgroundTask];
//
//    //Restart the locationMaanger after 1 minute
//    self.shareModel.timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self
//                                                           selector:@selector(restartLocationUpdates)
//                                                           userInfo:nil
//                                                            repeats:NO];
//
//    //Will only stop the locationManager after 10 seconds, so that we can get some accurate locations
//    //The location manager will only operate for 10 seconds to save battery
//    if (self.shareModel.delay10Seconds) {
//        [self.shareModel.delay10Seconds invalidate];
//        self.shareModel.delay10Seconds = nil;
//    }
//
//    self.shareModel.delay10Seconds = [NSTimer scheduledTimerWithTimeInterval:10 target:self
//                                                                    selector:@selector(stopLocationDelayBy10Seconds)
//                                                                    userInfo:nil
//                                                                     repeats:NO];

//}

- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error
{
    // NSLog(@"locationManager error:%@",error);
    
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please check your network connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
        }
            break;
        case kCLErrorDenied:
        {
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enable Location Service" message:@"You have to enable the Location Service to use this App. To enable, please go to Settings->Privacy->Location Services" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            //            [alert show];
            //            [self showAlertForLocationAuthorization];
        }
            break;
        default:
        {
            
        }
            break;
    }
}


//Send the location to Server
- (void)updateLocationToServer {
    
    NSLog(@"updateLocationToServer");
    
    // Find the best location from the array based on accuracy
    NSMutableDictionary * myBestLocation = [[NSMutableDictionary alloc]init];
    
    for(int i=0;i<self.myLocationArray.count;i++){
        NSMutableDictionary * currentLocation = [self.myLocationArray objectAtIndex:i];
        
        if(i==0)
            myBestLocation = currentLocation;
        else{
            if([[currentLocation objectForKey:ACCURACY]floatValue]<=[[myBestLocation objectForKey:ACCURACY]floatValue]){
                myBestLocation = currentLocation;
            }
        }
    }
    NSLog(@"My Best location:%@",myBestLocation);
    
    //If the array is 0, get the last location
    //Sometimes due to network issue or unknown reason, you could not get the location during that  period, the best you can do is sending the last known location to the server
    if(self.myLocationArray.count==0)
    {
        NSLog(@"Unable to get location, use the last known location");
        
        self.myLocation=self.myLastLocation;
        self.myLocationAccuracy=self.myLastLocationAccuracy;
        
    }else {
        CLLocationCoordinate2D theBestLocation;
        theBestLocation.latitude =[[myBestLocation objectForKey:LATITUDE]floatValue];
        theBestLocation.longitude =[[myBestLocation objectForKey:LONGITUDE]floatValue];
        self.myLocation=theBestLocation;
        self.myLocationAccuracy =[[myBestLocation objectForKey:ACCURACY]floatValue];
    }
    
    
    NSLog(@"Send to Server: Latitude(%f) Longitude(%f) Accuracy(%f)",self.myLocation.latitude, self.myLocation.longitude,self.myLocationAccuracy);
//    if (_delegate) {
//        if ([_delegate respondsToSelector:@selector(accurateFinalLocation:)]) {
//            [_delegate accurateFinalLocation:_myLocation];
//        }
//    }
    
    
    //TODO: Your code to send the self.myLocation and self.myLocationAccuracy to your server
    
    //After sending the location to the server successful, remember to clear the current array with the following code. It is to make sure that you clear up old location in the array and add the new locations from locationManager
    
    [self.myLocationArray removeAllObjects];
    self.myLocationArray = nil;
    self.myLocationArray = [[NSMutableArray alloc]init];
    
}

@end
