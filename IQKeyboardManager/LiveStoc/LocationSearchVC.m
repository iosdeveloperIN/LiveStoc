//
//  LocationSearchVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 12/19/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import "LocationSearchVC.h"

@interface LocationSearchVC ()<LocationDelegate,GMSMapViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UKLocationManager *location;
    GMSPlacesClient *placesClient;
    NSMutableArray *autoResultsArr;
    BOOL isFromSearching,gotCamera;
    CLLocationCoordinate2D finalCoordinate,currentLocation;
}
@end

@implementation LocationSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    placesClient=[[GMSPlacesClient alloc] init];
    location=[[UKLocationManager alloc] init];
    location.delegate=self;
    [location startLocationTracking];
    _searchTF.placeholder=AMLocalizedString(@"text_where_pickup_address", @"Search Locations..");
    [_selectlocationBtn setTitle:AMLocalizedString(@"text_select", @"Select") forState:UIControlStateNormal];
    _locationAttribLbl.text=AMLocalizedString(@"text_location", @"Location");

    _searchTblVw.delegate=self;
    _searchTblVw.dataSource=self;
    isFromSearching=NO;
    gotCamera=NO;
    _searchTblVw.hidden=YES;
    _backGroundBtn.hidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [location stopLocation];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return autoResultsArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UKTableCell *cell=[_searchTblVw dequeueReusableCellWithIdentifier:@"searchCell"];
    if (!cell) {
        cell=[[UKTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchCell"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.nameLabelOfSearchVC.text=[NSString stringWithFormat:@"%@",[[autoResultsArr objectAtIndex:indexPath.row] valueForKey:@"name"]];
    return cell;
}
-(void)accurateFinalLocation:(CLLocationCoordinate2D)finalLocation
{
    currentLocation=finalLocation;
    if (!gotCamera) {
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:finalLocation.latitude
                                                                longitude:finalLocation.longitude
                                                                     zoom:15];
        [self.searchMap setCamera:camera];
        self.searchMap.delegate=self;
        gotCamera=YES;
    }
}
- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{
    if (isFromSearching)
    {
        isFromSearching=NO;
    }
    else
    {
        [self placeDetails:position.target with:@""];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    isFromSearching=YES;
    [self placeDetails:kCLLocationCoordinate2DInvalid with:[[autoResultsArr objectAtIndex:indexPath.row] valueForKey:@"placeID"]];
}
-(void)placeDetails:(CLLocationCoordinate2D)coordinate with:(NSString *)placeID
{
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc] init];
    [paramDict setValue:Google_API_Key forKey:@"key"];
    
    if (isFromSearching) {
        [paramDict setValue:placeID forKey:@"place_id"];

    } else {
        [paramDict setValue:[NSString stringWithFormat:@"%f,%f",coordinate.latitude,coordinate.longitude] forKey:@"latlng"];
    }
    [UKNetworkManager operationType:OTHER fromPath:@"https://maps.googleapis.com/maps/api/geocode/json" withParameters:paramDict withUploadData:nil :^(id result) {
        
        if ([[result valueForKey:@"status"] isEqualToString:@"OK"]) {
            if (isFromSearching)
            {
                finalCoordinate.latitude=[[[[[[result valueForKey:@"results"] objectAtIndex:0]valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lat"] doubleValue];
                finalCoordinate.longitude=[[[[[[result valueForKey:@"results"] objectAtIndex:0]valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lng"] doubleValue];
                
                GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:finalCoordinate zoom:15];
                [self.searchMap setCamera:camera];
                
                self.addressLabel.text=[[[result valueForKey:@"results"] objectAtIndex:0]valueForKey:@"formatted_address"];
                [_searchTF resignFirstResponder];
                [_searchTF setText:@""];
                _searchTblVw.hidden=YES;
                _backGroundBtn.hidden=YES;
            }
            else
            {
                self.addressLabel.text=[[[result valueForKey:@"results"] objectAtIndex:0]valueForKey:@"formatted_address"];
                finalCoordinate=coordinate;
//                GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:finalCoordinate zoom:15];
//                [self.searchMap setCamera:camera];
            }
        } else {
            
        }
        
    } :^(NSError *error, NSString *errorMessage) {
        
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _backGroundBtn.hidden=NO;
}

- (IBAction)onTapBackBarBtn:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onTapMyLocationBtn:(UIButton *)sender {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLocation.latitude
                                                            longitude:currentLocation.longitude
                                                                 zoom:15];
    [_searchMap animateToCameraPosition:camera];
}
- (IBAction)onTapSelectLocation:(UIButton *)sender {
    
    if (currentLocation.latitude>0 && currentLocation.longitude>0) {
        
        NSNumber *lat = [NSNumber numberWithDouble:finalCoordinate.latitude];
        NSNumber *lon = [NSNumber numberWithDouble:finalCoordinate.longitude];
        NSDictionary *userLocation=@{@"lat":lat,@"long":lon};
        
        [[NSUserDefaults standardUserDefaults] setObject:userLocation forKey:@"userLocation"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LocationSelected"];
        [[NSUserDefaults standardUserDefaults] setObject:_addressLabel.text forKey:@"ADDRESS"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [UKModel model].pagination=No;
        [UKModel model].pageCount=1;
        [[UKModel model] getPosts];
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        [location startLocationTracking];
    }
}
- (IBAction)onTapBackGroundBtn:(UIButton *)sender {
    [_searchTF resignFirstResponder];
    [_searchTF setText:@""];
    _searchTblVw.hidden=YES;
    _backGroundBtn.hidden=YES;
}
- (IBAction)editingChanged:(UKTextField *)sender {

    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterNoFilter;
    NSString *str=[NSString stringWithFormat:@"%@",sender.text];
    [NSObject cancelPreviousPerformRequestsWithTarget:placesClient selector:@selector(autocompleteQuery:bounds:filter:callback:) object:self];
    
    [placesClient autocompleteQuery:str
                             bounds:nil
                             filter:filter
                           callback:^(NSArray *results, NSError *error) {
                               if (error != nil) {
                                   NSLog(@"Autocomplete error %@ copde %@", [error localizedDescription],error.localizedFailureReason);
                                   return;
                               }
                               autoResultsArr=[[NSMutableArray alloc] init];
                               for (GMSAutocompletePrediction* result in results) {
                                   NSLog(@"Result '%@'", result.attributedFullText.string);
                                   [autoResultsArr addObject:@{@"name":result.attributedFullText.string,@"placeID":result.placeID}.mutableCopy];
                               }
                               if (autoResultsArr.count>0) {
                                   _searchTblVw.hidden=NO;
                               } else {
                                   _searchTblVw.hidden=YES;
                               }
                               [self.searchTblVw reloadData];
                               _heightOfSearchTblVw.constant=autoResultsArr.count*50;
                           }];
}
@end
