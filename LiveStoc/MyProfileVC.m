//
//  MyProfileVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 12/22/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import "MyProfileVC.h"
#import <CoreText/CoreText.h>
#import "MemberShipVC.h"

@interface MyProfileVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableDictionary *userDetails;
    NSMutableAttributedString *attString;
    NSString *country;
}
@end

@implementation MyProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    userDetails=[[NSMutableDictionary alloc] init];
    self.navigationItem.title=AMLocalizedString(@"profile", @"profile");
    [_memberShipBtn setTitle:AMLocalizedString(@"buyer", @"buyer") forState:UIControlStateNormal];
    
    userDetails=[UKNetworkManager getFromDefaultsWithKeyString:USER_DETAILS];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUserProfile];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident=@"profileCell";
    UKTableCell *cell=[_detailsTblVw dequeueReusableCellWithIdentifier:ident];
    UKTableCell *fbCell=[_detailsTblVw dequeueReusableCellWithIdentifier:@"profileFbCell"];

    switch (indexPath.row) {
        case 0:
        {
            if (!cell)
            {
                cell=[[UKTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.attribLabelOfMyProfileVC.text=AMLocalizedString(@"email", @"email");
            cell.nameLabelOfMyProfileVC.text=[NSString stringWithFormat:@"%@",[userDetails valueForKey:@"email"] ];
            return cell;
            
            break;
        }
        case 1:
        {
            if (!cell)
            {
                cell=[[UKTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.attribLabelOfMyProfileVC.text=AMLocalizedString(@"mobile_no", @"mobile_no");
            cell.nameLabelOfMyProfileVC.text=[NSString stringWithFormat:@"%@",[userDetails valueForKey:@"mobile"] ];
            return cell;

            break;
        }
        case 2:
        {
            if (!fbCell)
            {
                fbCell=[[UKTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
            }
            
            fbCell.selectionStyle=UITableViewCellSelectionStyleNone;
            fbCell.attribLabelOfMyProfileVC.text=AMLocalizedString(@"facebook", @"facebook");

            if ([[userDetails valueForKey:@"facebook"] isEqualToString:@""]) {
                
                fbCell.nameFbLabelOfMyProfileVC.text=@"";
                
            }  else {
                
                attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"www.facebook.com/%@",[userDetails valueForKey:@"facebook"] ]];
                [attString addAttribute:(NSString*)kCTUnderlineStyleAttributeName
                                  value:[NSNumber numberWithInt:kCTUnderlineStyleSingle]
                                  range:(NSRange){0,[attString length]}];
                fbCell.nameFbLabelOfMyProfileVC.attributedText=attString;
                fbCell.nameFbLabelOfMyProfileVC.textColor=[UIColor blueColor];
            }
            

            return fbCell;
            break;
        }
        case 3:
        {
            if (!cell)
            {
                cell=[[UKTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
            }
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.attribLabelOfMyProfileVC.text=AMLocalizedString(@"country", @"country");
            cell.nameLabelOfMyProfileVC.text=[NSString stringWithFormat:@"%@",country];
            return cell;

            break;
        }
        case 4:
        {
            
            if (!cell)
            {
                cell=[[UKTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
            }
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.attribLabelOfMyProfileVC.text=AMLocalizedString(@"gender", @"gender");
            cell.nameLabelOfMyProfileVC.text=[NSString stringWithFormat:@"%@",[userDetails valueForKey:@"gender"] ];
            return cell;
            break;
        }
        default:
        {
            if (!cell)
            {
                cell=[[UKTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
            }
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.attribLabelOfMyProfileVC.text=AMLocalizedString(@"address", @"address");
            cell.nameLabelOfMyProfileVC.text=[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",[userDetails valueForKey:@"shipping_house_no"],[userDetails valueForKey:@"shipping_landmark"],[userDetails valueForKey:@"shipping_street"],[userDetails valueForKey:@"shipping_city"],[userDetails valueForKey:@"shipping_state"],[userDetails valueForKey:@"shipping_pin_code"]];
            return cell;
            
            break;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==2) {
        
        if (attString.string.length>0) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",attString.string]];
        
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                    NSLog(@"Completed Succesfully");
                }];
            }else{
                // Fallback on earlier versions
                [[UIApplication sharedApplication] openURL:url];
            }
        }
        
    }
}


-(void)getUserProfile
{
    [DejalBezelActivityView activityViewForView:[[[UIApplication sharedApplication] delegate] window]];
    
    [UKNetworkManager operationType:POST fromPath:@"user/index" withParameters:@{@"users_id":[UKNetworkManager getFromDefaultsWithKeyString:USER_ID]}.mutableCopy withUploadData:nil :^(id result) {
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            userDetails=[[NSMutableDictionary alloc] init];
            userDetails=result[@"data"][@"data"][0];
            
            [_profileImgVw sd_setImageWithURL:[NSURL URLWithString:[userDetails valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"profile_stub"] options:SDWebImageHighPriority];
            NSArray *countries=[UKNetworkManager getFromDefaultsWithKeyString:@"COUNTRIES"];
            
            for (NSDictionary *dict in countries) {
                if ([[dict valueForKey:@"currencie_id"] isEqualToString:userDetails[@"currencie_id"]]) {
                    country=[dict valueForKey:@"country"];
                }
            }
            
            _detailsTblVw.delegate=self;
            _detailsTblVw.dataSource=self;
            _nameLabel.text=[userDetails valueForKey:@"fullname"];
            
            
        } else {
            [UKNetworkManager showAlertWithTitle:AMLocalizedString(@"error", nil) messageTitle:AMLocalizedString(@"try_again", nil) okTitle:nil cancelTitle:AMLocalizedString(@"ok", nil) otherTitles:nil];
            
        }
        [DejalBezelActivityView removeViewAnimated:YES];
        
    } :^(NSError *error, NSString *errorMessage) {
        [DejalBezelActivityView removeViewAnimated:YES];
        [UKNetworkManager showAlertWithTitle:AMLocalizedString(@"error", nil) messageTitle:AMLocalizedString(@"try_again", nil) okTitle:nil cancelTitle:AMLocalizedString(@"ok", nil) otherTitles:nil];
    }];
}

- (IBAction)onTapMemberShipBtn:(UIButton *)sender {

        UIAlertController * alert=[UIAlertController alertControllerWithTitle:AMLocalizedString(@"member_alert", nil) message:AMLocalizedString(@"current_membership", nil) preferredStyle:UIAlertControllerStyleAlert];
    
        
        UIAlertAction *logoutAction=[UIAlertAction actionWithTitle:AMLocalizedString(@"conti_nue", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            MemberShipVC *member=[self.storyboard instantiateViewControllerWithIdentifier:@"MemberShipVC"];
            
            [self.navigationController pushViewController:member animated:YES];
            
            
        }];
        
        [alert addAction:logoutAction];
        [self presentViewController:alert animated:YES completion:nil];
  
}
- (IBAction)onTapEditBtn:(UIButton *)sender {
    
    EditProfileVC *edit=[self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileVC"];
    edit.details=userDetails;
    [self.navigationController presentViewController:edit animated:YES completion:nil];
    
}
@end
















@interface EditProfileVC ()<KPDropMenuDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableDictionary *genderCountry,*params;
    NSMutableArray *countries;
    UIImagePickerController *picker;
    UIImage *image;
    NSData *imageData;
}
@end

@implementation EditProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    picker=[[UIImagePickerController alloc]init];
    picker.delegate=self;
    picker.allowsEditing=YES;
    
    self.navItem.title=AMLocalizedString(@"edit_profile", @"edit_profile");
    
    [_submitBtn setTitle:AMLocalizedString(@"submit", @"submit") forState:UIControlStateNormal];
    
    genderCountry=[[NSMutableDictionary alloc] init];
    params=[[NSMutableDictionary alloc] init];
    countries=[[NSMutableArray alloc] init];
    genderCountry=@{@"gender":@[@"male",@"female"],@"country":[UKNetworkManager getFromDefaultsWithKeyString:@"COUNTRIES"],@"address":@[AMLocalizedString(@"home_address", @"home_address"),AMLocalizedString(@"office_address", @"office_address")]}.mutableCopy;
    NSString *countryCode=[UKNetworkManager getFromDefaultsWithKeyString:@"COUNTRY_CODE"];
    _countryDropDown.title=AMLocalizedString(@"search_country", @"search_country");

    for (NSDictionary *dict in [genderCountry valueForKey:@"country"]) {
        [countries addObject:[NSString stringWithFormat:@"%@-%@",[dict valueForKey:@"country"],[dict valueForKey:@"code"]]];
        if ([[dict valueForKey:@"mobile_code"] isEqualToString:countryCode]) {
            _countryDropDown.title=[NSString stringWithFormat:@"%@-%@",[dict valueForKey:@"country"],[dict valueForKey:@"code"]];
            [params setValue:[NSString stringWithFormat:@"%@",[dict valueForKey:@"currencie_id"]] forKey:@"currencie_id"];

        }
    }
    
    NSLog(@"%@",[UKNetworkManager getFromDefaultsWithKeyString:@"COUNTRIES"]);
    _fullNameTF.text=[_details valueForKey:@"fullname"];
//    _nameAttribute.text=AMLocalizedString(@"FULL_NAME", @"FULL_NAME");
//    _genderAttribute.text=AMLocalizedString(@"gender", @"gender");
//    _countryAttribute.text=AMLocalizedString(@"country", @"country");
    
    
    _houseNumTF.text=_details[@"shipping_house_no"];
    _streetTF.text=_details[@"shipping_street"];
    _landMarkTF.text=_details[@"shipping_landmark"];
    _cityTF.text=_details[@"shipping_city"];
    _stateTF.text=_details[@"shipping_state"];
    _pinCodeTF.text=_details[@"shipping_pin_code"];
    
    _houseNumTF.placeholder=AMLocalizedString(@"house_no", @"house_no");
    _streetTF.placeholder=AMLocalizedString(@"street", @"street");
    _landMarkTF.placeholder=AMLocalizedString(@"landmark", @"landmark");
    _cityTF.placeholder=AMLocalizedString(@"city", @"city");
    _stateTF.placeholder=AMLocalizedString(@"state", @"state");
    _pinCodeTF.placeholder=AMLocalizedString(@"pincode", @"pincode");
    
//    [params setValue:_details[@"shipping_house_no"] forKey:@""];
//    [params setValue:_details[@"shipping_house_no"] forKey:@""];
//    [params setValue:_details[@"shipping_house_no"] forKey:@""];
//    [params setValue:_details[@"shipping_house_no"] forKey:@""];
//    [params setValue:_details[@"shipping_house_no"] forKey:@""];
//    [params setValue:_details[@"shipping_house_no"] forKey:@""];

    [params setValue:[[_details valueForKey:@"shipping_delivery_preferences"] isEqualToString:@"Home"] ? @"Home":@"Office" forKey:@"shipping_delivery_preferences"];
    [params setValue:[[_details valueForKey:@"gender"] isEqualToString:@"male"] ? @"Male":@"Female" forKey:@"gender"];

    
    _genderDropDown.title=[[_details valueForKey:@"gender"] isEqualToString:@"male"] ? @"Male":@"Female";
    _genderDropDown.items=[genderCountry valueForKey:@"gender"];
    _genderDropDown.delegate=self;
    _addressTypeDropDown.title=[[_details valueForKey:@"shipping_delivery_preferences"] isEqualToString:@"Home"] ? AMLocalizedString(@"office_address", @"office_address"):AMLocalizedString(@"office_address", @"office_address");
    _addressTypeDropDown.items=[genderCountry valueForKey:@"address"];
    _addressTypeDropDown.delegate=self;
    _countryDropDown.items=countries;
    _countryDropDown.DirectionDown=NO;
    _countryDropDown.delegate=self;
    [_myProfileImgVw sd_setImageWithURL:[NSURL URLWithString:[_details valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"profile_stub"] options:SDWebImageHighPriority];
    _myProfileImgVw.layer.cornerRadius=_myProfileImgVw.frame.size.width/2;
    _myProfileImgVw.clipsToBounds=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)didSelectItem : (KPDropMenu *) dropMenu atIndex : (int) atIndex
{
    if (dropMenu==_countryDropDown) {
        
        _countryDropDown.title=[countries objectAtIndex:atIndex];
        [params setValue:[[[genderCountry valueForKey:@"country"] objectAtIndex:atIndex] valueForKey:@"currencie_id"] forKey:@"currencie_id"];
        [UKNetworkManager saveToDefaults:[[[genderCountry valueForKey:@"country"] objectAtIndex:atIndex] valueForKey:@"currencie_id"] withKeyString:@"COUNTRY_CODE"];
        
    } else if (dropMenu==_addressTypeDropDown)
    {
        [params setValue:atIndex==0 ? @"Home":@"Office" forKey:@"shipping_delivery_preferences"];
    }
    else {
        _genderDropDown.title=[[genderCountry valueForKey:@"gender"] objectAtIndex:atIndex];
        [params setValue:[[genderCountry valueForKey:@"gender"] objectAtIndex:atIndex] forKey:@"gender"];

    }
}
- (IBAction)onTapSubmitBtn:(UIButton *)sender {
    
    if ([_fullNameTF hasText]) {
        
        [params setValue:_fullNameTF.text forKey:@"fullname"];
        [params setValue:[UKNetworkManager getFromDefaultsWithKeyString:USER_ID] forKey:@"users_id"];
        [params setValue:_houseNumTF.text forKey:@"shipping_house_no"];
        [params setValue:_streetTF.text forKey:@"shipping_street"];
        [params setValue:_landMarkTF.text forKey:@"shipping_landmark"];
        [params setValue:_cityTF.text forKey:@"shipping_city"];
        [params setValue:_stateTF.text forKey:@"shipping_state"];
        [params setValue:_pinCodeTF.text forKey:@"shipping_pin_code"];
        [params setValue:@"Go" forKey:@"submit"];
        
        [DejalBezelActivityView activityViewForView:[[[UIApplication sharedApplication] delegate] window]];
        
        [UKNetworkManager operationType:UPLOAD fromPath:@"user/edit" withParameters:params withUploadData:imageData ? @{@"file":imageData}.mutableCopy:nil :^(id result) {
            
            if ([[result valueForKey:SUCCESS] integerValue]==1) {
                
                [[[[UIApplication sharedApplication] delegate] window] makeToast:[result valueForKey:@"message"] duration:3.0 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-80)]];
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
            } else {
                
                [UKNetworkManager showAlertWithTitle:[result valueForKey:@"data"][0] messageTitle:nil okTitle:nil cancelTitle:AMLocalizedString(@"ok", @"ok") otherTitles:nil];

            }
            [DejalBezelActivityView removeViewAnimated:YES];
            
        } :^(NSError *error, NSString *errorMessage) {
            
            [UKNetworkManager showAlertWithTitle:errorMessage messageTitle:nil okTitle:nil cancelTitle:AMLocalizedString(@"ok", @"ok") otherTitles:nil];

            [DejalBezelActivityView removeViewAnimated:YES];
            
        }];
    }
}

- (IBAction)onTapImageVw:(UITapGestureRecognizer *)sender {
    
    UIAlertController *popForPicker=[UIAlertController alertControllerWithTitle:AMLocalizedString(@"select_picture", @"select_picture") message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *gallery=[UIAlertAction actionWithTitle:AMLocalizedString(@"gallery", @"gallery") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
        

        
    }];
    
    UIAlertAction *camera=[UIAlertAction actionWithTitle:AMLocalizedString(@"camera", @"camera") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
        
        
    }];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:AMLocalizedString(@"CANCEL", @"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [popForPicker addAction:camera];
    [popForPicker addAction:gallery];
    [popForPicker addAction:cancel];
    
    [self presentViewController:popForPicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    image                   = [info objectForKey:UIImagePickerControllerOriginalImage];
    image                   = [info valueForKey:UIImagePickerControllerEditedImage];
    imageData     = UIImageJPEGRepresentation(image, 0.5);
    self.myProfileImgVw.image=image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)ontapDismissBarBtn:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end

