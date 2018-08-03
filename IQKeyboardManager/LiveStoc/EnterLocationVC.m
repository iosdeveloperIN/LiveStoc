//
//  EnterLocationVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 12/9/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import "EnterLocationVC.h"
#import "AlmostDoneVC.h"
@interface EnterLocationVC ()<UITableViewDelegate,UITableViewDataSource,LocationDelegate,UITextFieldDelegate>
{
    NSMutableArray *placeHolderArr;
    UKLocationManager *location;
    NSString *symbolCurr;
}
@end

@implementation EnterLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    location=[[UKLocationManager alloc] init];
    location.delegate=self;
    [location startLocationTracking];
    placeHolderArr=[[NSMutableArray alloc] init];
    self.navigationItem.title=AMLocalizedString(@"enter_loc", @"enter_loc");
    _animalLocatedLabel.text=AMLocalizedString(@"where_animal_loc", @"where_animal_loc");
    placeHolderArr=@[AMLocalizedString(@"street", @"street"),AMLocalizedString(@"village", @"village"),AMLocalizedString(@"post_office", @"post_office"),AMLocalizedString(@"tehsil", @"tehsil"),AMLocalizedString(@"district", @"district"),AMLocalizedString(@"state", @"state"),AMLocalizedString(@"pincode", @"pincode"),AMLocalizedString(@"next", @"next")].mutableCopy;
    _locTblVw.delegate=self;
    _locTblVw.dataSource=self;
    
    [[[UKModel model] sellAnimalDetails] setValue:@"" forKey:@"latitude"];
    [[[UKModel model] sellAnimalDetails] setValue:@"" forKey:@"longitude"];
    
    [[[UKModel model] sellAnimalDetails] setValue:@"" forKey:@"user_street"];
    [[[UKModel model] sellAnimalDetails] setValue:@"" forKey:@"user_village"];
    [[[UKModel model] sellAnimalDetails] setValue:@"" forKey:@"user_post_office"];
    [[[UKModel model] sellAnimalDetails] setValue:@"" forKey:@"user_tehsil"];
    [[[UKModel model] sellAnimalDetails] setValue:@"" forKey:@"user_district"];
    [[[UKModel model] sellAnimalDetails] setValue:@"" forKey:@"user_state"];
    [[[UKModel model] sellAnimalDetails] setValue:@"" forKey:@"user_pin_no"];
}

-(void)accurateFinalLocation:(CLLocationCoordinate2D)finalLocation
{
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc] init];
    [paramDict setValue:Google_API_Key forKey:@"key"];
    [paramDict setValue:[NSString stringWithFormat:@"%f,%f",finalLocation.latitude,finalLocation.longitude] forKey:@"latlng"];
    
    [[[UKModel model] sellAnimalDetails] setValue:[NSString stringWithFormat:@"%f",finalLocation.latitude] forKey:@"latitude"];
    [[[UKModel model] sellAnimalDetails] setValue:[NSString stringWithFormat:@"%f",finalLocation.longitude] forKey:@"longitude"];
        
    [UKNetworkManager operationType:OTHER fromPath:@"https://maps.googleapis.com/maps/api/geocode/json" withParameters:paramDict withUploadData:nil :^(id result) {
        
        if ([[result valueForKey:@"status"] isEqualToString:@"OK"]) {
            
            [self.locationBtn setTitle:[[[result valueForKey:@"results"] objectAtIndex:0]valueForKey:@"formatted_address"] forState:UIControlStateNormal];
            
            NSArray *countries=[UKNetworkManager getFromDefaultsWithKeyString:@"COUNTRIES"];
            bool foundCode=NO;
            for (NSDictionary *dict in [[[result valueForKey:@"results"] objectAtIndex:0]valueForKey:@"address_components"]) {
                
                for (NSString *str in [dict valueForKey:@"types"]) {
                    
                    if ([str isEqualToString:@"country"]) {
                        
                        for (NSDictionary *countryDict in countries) {
                            
                            if ([[countryDict valueForKey:@"mobile_code"] isEqualToString:[dict valueForKey:@"short_name"]]) {
                                
                                [[[UKModel model] sellAnimalDetails] setValue:[countryDict valueForKey:@"currencie_id"] forKey:@"currencie_id"];
                                symbolCurr=[countryDict valueForKey:@"symbol"];
                                foundCode=YES;
                                location.delegate=nil;
                                [location stopLocation];
                                break;
                            }
                        }
                    }
                    if (foundCode) {
                        break;
                    }
                }
                if (foundCode) {
                    break;
                }
            }
            
        } 
        
    } :^(NSError *error, NSString *errorMessage) {
        
        
    }];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return placeHolderArr.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *ident=@"locationTblVw";
    
    UKTableCell *cell=[self.locTblVw dequeueReusableCellWithIdentifier:ident];
    
    if (cell==nil) {
        cell=[[UKTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
     if (indexPath.row==placeHolderArr.count-1) {
         
        cell.nextBtn.hidden=NO;
        [cell.nextBtn setTitle:placeHolderArr[indexPath.row] forState:UIControlStateNormal];
        cell.locationTF.hidden=YES;

    } else {

        cell.nextBtn.hidden=YES;
        cell.locationTF.hidden=NO;
        [cell.locationTF setPlaceholder:placeHolderArr[indexPath.row]];
        cell.locationTF.tag=indexPath.row+13;
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.backView.frame.size.height*0.085;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==placeHolderArr.count-1) {
        
    if ([[[[UKModel model] sellAnimalDetails] valueForKey:@"latitude"] length]>0 && [[[[UKModel model] sellAnimalDetails] valueForKey:@"longitude"] length]>0) {
        [self performSegueWithIdentifier:@"toAlmostDone" sender:symbolCurr];
        
    } else {
        [UKNetworkManager showAlertWithTitle:AMLocalizedString(@"location_empty", @"location_empty") messageTitle:nil okTitle:nil cancelTitle:AMLocalizedString(@"ok", @"ok") otherTitles:nil];
    }
}
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toAlmostDone"]) {
        
        AlmostDoneVC *done=segue.destinationViewController;
        done.currencySymb=sender;
        
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==13)
    {
        [[[UKModel model] sellAnimalDetails] setValue:textField.text forKey:@"user_street"];
    }
    else if (textField.tag==14)
    {
        [[[UKModel model] sellAnimalDetails] setValue:textField.text forKey:@"user_village"];
    }
    else if (textField.tag==15)
    {
        [[[UKModel model] sellAnimalDetails] setValue:textField.text forKey:@"user_post_office"];
    }
    else if (textField.tag==16)
    {
        [[[UKModel model] sellAnimalDetails] setValue:textField.text forKey:@"user_tehsil"];
    }
    else if (textField.tag==17)
    {
        [[[UKModel model] sellAnimalDetails] setValue:textField.text forKey:@"user_district"];
    }
    else if (textField.tag==18)
    {
        [[[UKModel model] sellAnimalDetails] setValue:textField.text forKey:@"user_state"];
    } else {
        [[[UKModel model] sellAnimalDetails] setValue:textField.text forKey:@"user_pin_no"];
    }
}

- (IBAction)onTapBackButton:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onTapLocationBtn:(UKButton *)sender {
    location.delegate=self;
    [location startLocationTracking];
}
@end
