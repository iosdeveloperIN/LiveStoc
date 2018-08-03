//
//  AddressVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 1/22/18.
//  Copyright © 2018 Harjit Singh. All rights reserved.
//

#import "AddressVC.h"

@interface AddressVC ()
{
    BOOL isAddressSame;
    NSMutableDictionary *userDetails;
}
@end

@implementation AddressVC
@synthesize detailsDict;
- (void)viewDidLoad {
    [super viewDidLoad];
    isAddressSame=NO;
    
    self.navigationItem.title=AMLocalizedString(@"checkout", @"checkout");
    
    [_deliverBtn setTitle:AMLocalizedString(@"deliver_to_address", @"deliver_to_address") forState:UIControlStateNormal];
    _shippingAddressLbl.text=AMLocalizedString(@"shipping_address", @"shipping_address");
    _bllingAddrssLbl.text=AMLocalizedString(@"billing_address", @"billing_address");
    _billingSameLbl.text=AMLocalizedString(@"is_billing_address_same", @"is_billing_address_same");
    
    _fullNameShippingTF.placeholder=AMLocalizedString(@"full_name", @"full_name");
    _mobileNumShippingTF.placeholder=AMLocalizedString(@"mobile_no", @"mobile_no");
    _pinCodeShippingTF.placeholder=AMLocalizedString(@"pincode", @"pincode");
    _houseNumShippingTF.placeholder=AMLocalizedString(@"house_no", @"house_no");
    _streetShippingTF.placeholder=AMLocalizedString(@"street", @"street");
    _landMarkShippingTF.placeholder=AMLocalizedString(@"landmark", @"landmark");
    _cityShippingTF.placeholder=AMLocalizedString(@"city", @"city");
    _stateShippingTF.placeholder=AMLocalizedString(@"state", @"state");
    
    _fullNameBillingTF.placeholder=AMLocalizedString(@"full_name", @"full_name");
    _mobileNumBillingTF.placeholder=AMLocalizedString(@"mobile_no", @"mobile_no");
    _pinCodeBillingTF.placeholder=AMLocalizedString(@"pincode", @"pincode");
    _houseNumBillingTF.placeholder=AMLocalizedString(@"house_no", @"house_no");
    _streetBillingTF.placeholder=AMLocalizedString(@"street", @"street");
    _landMarkBillingTF.placeholder=AMLocalizedString(@"landmark", @"landmark");
    _cityBillingTF.placeholder=AMLocalizedString(@"city", @"city");
    _stateBillingTF.placeholder=AMLocalizedString(@"state", @"state");

    [self getUserProfile];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTapCheckbox:(UIButton *)sender {
    
    if (!isAddressSame) {
       //
        isAddressSame=YES;
        _billingView.hidden=isAddressSame;
        _topSpaceWhenNoBilling.constant=-_billingView.frame.size.height;
        
        [_checkBoxBtn setBackgroundImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
        
    } else {
        isAddressSame=NO;
        _billingView.hidden=isAddressSame;
        _topSpaceWhenNoBilling.constant=10;
        
        [_checkBoxBtn setBackgroundImage:[UIImage imageNamed:@"box"] forState:UIControlStateNormal];

    }
    
    [self.view layoutIfNeeded];
    
}

-(void)getUserProfile
{
    [DejalBezelActivityView activityViewForView:[[[UIApplication sharedApplication] delegate] window]];
    
    [UKNetworkManager operationType:POST fromPath:@"user/index" withParameters:@{@"users_id":[UKNetworkManager getFromDefaultsWithKeyString:USER_ID]}.mutableCopy withUploadData:nil :^(id result) {
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            userDetails=[[NSMutableDictionary alloc] init];
            userDetails=result[@"data"][@"data"][0];
            
            _fullNameShippingTF.text=[NSString stringWithFormat:@"%@",userDetails[@"shipping_fullname"]];
            _mobileNumShippingTF.text=[NSString stringWithFormat:@"%@",userDetails[@"shipping_mobile"]];
            _pinCodeShippingTF.text=[NSString stringWithFormat:@"%@",userDetails[@"shipping_pin_code"]];
            _houseNumShippingTF.text=[NSString stringWithFormat:@"%@",userDetails[@"shipping_house_no"]];
            _streetShippingTF.text=[NSString stringWithFormat:@"%@",userDetails[@"shipping_street"]];
            _landMarkShippingTF.text=[NSString stringWithFormat:@"%@",userDetails[@"shipping_landmark"]];
            _cityShippingTF.text=[NSString stringWithFormat:@"%@",userDetails[@"shipping_city"]];
            _stateShippingTF.text=[NSString stringWithFormat:@"%@",userDetails[@"shipping_state"]];
            
            
        } else {
            [UKNetworkManager showAlertWithTitle:AMLocalizedString(@"error", nil) messageTitle:AMLocalizedString(@"try_again", nil) okTitle:nil cancelTitle:AMLocalizedString(@"ok", nil) otherTitles:nil];

        }
        [DejalBezelActivityView removeViewAnimated:YES];

    } :^(NSError *error, NSString *errorMessage) {
        [DejalBezelActivityView removeViewAnimated:YES];
        [UKNetworkManager showAlertWithTitle:AMLocalizedString(@"error", nil) messageTitle:AMLocalizedString(@"try_again", nil) okTitle:nil cancelTitle:AMLocalizedString(@"ok", nil) otherTitles:nil];
    }];
}

- (IBAction)onTapDeliverBtn:(UIButton *)sender {
    NSMutableDictionary *addressDict=[[NSMutableDictionary alloc] init];
    NSMutableArray *jsonArr=[[NSMutableArray alloc] init];
    
    if (isAddressSame) {
 addressDict=@{@"shipping_fullname":self.fullNameShippingTF.text,@"shipping_mobile":self.mobileNumShippingTF.text,@"shipping_pin_code":self.pinCodeShippingTF.text,@"shipping_house_no":self.houseNumShippingTF.text,@"shipping_street":self.streetShippingTF.text,@"shipping_landmark":self.landMarkShippingTF.text,@"shipping_city":self.cityShippingTF.text,@"shipping_state":self.stateShippingTF.text,@"shipping_delivery_preferences":[NSString stringWithFormat:@"%@",userDetails[@"shipping_delivery_preferences"]],@"billing_fullname":self.fullNameShippingTF.text,@"billing_mobile":self.mobileNumShippingTF.text,@"billing_pin_code":self.pinCodeShippingTF.text,@"billing_house_no":self.houseNumShippingTF.text,@"billing_street":self.streetShippingTF.text,@"billing_landmark":self.landMarkShippingTF.text,@"billing_city":self.cityShippingTF.text,@"billing_state":self.stateShippingTF.text}.mutableCopy;
        
        
    } else {
        addressDict=@{@"shipping_fullname":self.fullNameShippingTF.text,@"shipping_mobile":self.mobileNumShippingTF.text,@"shipping_pin_code":self.pinCodeShippingTF.text,@"shipping_house_no":self.houseNumShippingTF.text,@"shipping_street":self.streetShippingTF.text,@"shipping_landmark":self.landMarkShippingTF.text,@"shipping_city":self.cityShippingTF.text,@"shipping_state":self.stateShippingTF.text,@"shipping_delivery_preferences":[NSString stringWithFormat:@"%@",userDetails[@"shipping_delivery_preferences"]],@"billing_fullname":self.fullNameBillingTF.text,@"billing_mobile":self.mobileNumBillingTF.text,@"billing_pin_code":self.pinCodeBillingTF.text,@"billing_house_no":self.houseNumBillingTF.text,@"billing_street":self.streetBillingTF.text,@"billing_landmark":self.landMarkBillingTF.text,@"billing_city":self.cityBillingTF.text,@"billing_state":self.stateBillingTF.text}.mutableCopy;
    }
    
    BOOL checked=YES;
    
    for (NSString *value in [addressDict allValues]) {
        
        if ([value isEqualToString:@""]) {
            
            checked=NO;
            break;
            
        }
        
    }
    
    if (checked) {
        
        [jsonArr addObject:addressDict];
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArr options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        [self submitCheckoutWithAddress:jsonString];
        
    } else {
        [self.view makeToast:AMLocalizedString(@"COMPLETE_ALL_FIELDS", nil) duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-80)]];
    }
}


-(void)submitCheckoutWithAddress:(NSString *)address
{
    [DejalBezelActivityView activityViewForView:[[[UIApplication sharedApplication] delegate] window]];
    
    [UKNetworkManager operationType:POST fromPath:@"cart/orders" withParameters:@{@"users_id":[UKNetworkManager getFromDefaultsWithKeyString:USER_ID],@"products_id":detailsDict[@"products_id"],@"qty":detailsDict[@"qty"],@"submit":@"Go",@"address":address}.mutableCopy withUploadData:nil :^(id result) {
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            
            [[[[UIApplication sharedApplication] delegate] window] makeToast:[result valueForKey:@"data"] duration:3.0 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-80)]];

            [[UKModel model] setCartCount:0];
            
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
            
        } else {
            [UKNetworkManager showAlertWithTitle:AMLocalizedString(@"error", nil) messageTitle:AMLocalizedString(@"try_again", nil) okTitle:nil cancelTitle:AMLocalizedString(@"ok", nil) otherTitles:nil];
            
        }
        [DejalBezelActivityView removeViewAnimated:YES];
        
    } :^(NSError *error, NSString *errorMessage) {
        [DejalBezelActivityView removeViewAnimated:YES];
        [UKNetworkManager showAlertWithTitle:AMLocalizedString(@"error", nil) messageTitle:AMLocalizedString(@"try_again", nil) okTitle:nil cancelTitle:AMLocalizedString(@"ok", nil) otherTitles:nil];
    }];
}

@end
