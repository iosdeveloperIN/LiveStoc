//
//  UKLocationManager.h
//  LiveStoc
//
//  Created by Harjit Singh on 12/18/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LocationDelegate <NSObject>
@required
-(void)accurateFinalLocation:(CLLocationCoordinate2D)finalLocation;
@end
@interface UKLocationManager : NSObject<CLLocationManagerDelegate>
@property (nonatomic) CLLocationCoordinate2D myLastLocation;
@property (nonatomic) CLLocationAccuracy myLastLocationAccuracy;
@property (nonatomic) CLLocationCoordinate2D myLocation;
@property (nonatomic) CLLocationAccuracy myLocationAccuracy;
@property(strong,nonatomic) NSMutableArray *myLocationArray;
@property(nonatomic) BOOL isFirstTime;
@property(strong,nonatomic) id<LocationDelegate>delegate;
+ (CLLocationManager *)sharedLocationManager;

- (void)startLocationTracking;
-(void)stopLocation;
- (void)updateLocationToServer;
@end
