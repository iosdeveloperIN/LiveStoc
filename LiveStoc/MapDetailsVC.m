//
//  MapDetailsVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 2/1/18.
//  Copyright © 2018 Harjit Singh. All rights reserved.
//

#import "MapDetailsVC.h"

@interface MapDetailsVC ()<LocationDelegate,GMSMapViewDelegate>
{
    UKLocationManager *location;
    CLLocationCoordinate2D currLoc;
}
@end

@implementation MapDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=AMLocalizedString(@"address", @"address");
    location=[[UKLocationManager alloc] init];
    location.delegate=self;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[_latDict[@"lat"] doubleValue]
                                                            longitude:[_latDict[@"long"] doubleValue]
                                                                 zoom:15];
    [self.locationMapView setCamera:camera];
    self.locationMapView.delegate=self;
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = camera.target;
    marker.snippet = _latDict[@"address"];
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = _locationMapView;
    
    GMSMarker *userMarker = [[GMSMarker alloc] init];
    userMarker.position = [[[UKLocationManager sharedLocationManager] location] coordinate];
    userMarker.snippet = AMLocalizedString(@"my_loc", @"my_loc");
    userMarker.appearAnimation = kGMSMarkerAnimationPop;
    userMarker.map = _locationMapView;
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [location startLocationTracking];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [location stopLocation];
}
-(void)accurateFinalLocation:(CLLocationCoordinate2D)finalLocation
{
    currLoc=finalLocation;
   
}

- (IBAction)onTapCurrentLocationBtn:(UIButton *)sender {
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currLoc.latitude
                                                            longitude:currLoc.longitude
                                                                 zoom:15];
    [self.locationMapView animateToCameraPosition:camera];
}

@end
