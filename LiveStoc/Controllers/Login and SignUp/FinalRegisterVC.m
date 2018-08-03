//
//  FinalRegisterVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 11/23/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import "FinalRegisterVC.h"
#import "LoginVC.h"
@interface FinalRegisterVC ()<KPDropMenuDelegate>
{
    NSMutableArray *countryDropArr;
    NSMutableArray *countryNames;
    NSString *countryID;
}
@end

@implementation FinalRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    countryID=@"";
    [_backToLogin setTitle:AMLocalizedString(@"back_to_login", nil) forState:UIControlStateNormal];
    _fullNameTF.placeholder=AMLocalizedString(@"full_name", nil);
    _mailTF.placeholder=AMLocalizedString(@"email", nil);
    _mobileTF.placeholder=AMLocalizedString(@"mobile_no", nil);
    _passwordTF.placeholder=AMLocalizedString(@"password", nil);
    [_submitBtn setTitle:AMLocalizedString(@"submit", nil) forState:UIControlStateNormal];
    
    _details=[UKNetworkManager getFromDefaultsWithKeyString:@"REGISTER_DETAILS"];
    
    _mobileTF.text=[_details valueForKey:@"mobile"];
    _mailTF.text=[_details valueForKey:@"email"];
    _mobileTF.userInteractionEnabled=NO;
    _mailTF.userInteractionEnabled=NO;
    
    
    [self getCurencies];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=YES;
}
-(void)getCurencies
{
    [DejalBezelActivityView activityViewForView:[[[UIApplication sharedApplication] delegate] window]];

    [UKNetworkManager operationType:POST fromPath:@"selling/currencies" withParameters:nil withUploadData:nil :^(id result) {
        
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            
            countryDropArr=[[NSMutableArray alloc] init];
            
            countryDropArr=[[result valueForKey:@"data"] valueForKey:@"country"];
            countryNames=[[NSMutableArray alloc] init];
            for (NSDictionary *dict in countryDropArr) {
                
                [countryNames addObject:[NSString stringWithFormat:@"%@ - %@",[dict valueForKey:@"country"],[dict valueForKey:@"code"]]];
                
            }
            _countryDropDown.title=AMLocalizedString(@"search_country", @"search_country");
            _countryDropDown.items=countryNames;
            _countryDropDown.DirectionDown=NO;
            _countryDropDown.titleTextAlignment = NSTextAlignmentCenter;
            _countryDropDown.itemsFont = [UIFont fontWithName:@"Helvetica-Regular" size:12.0];
            _countryDropDown.delegate=self;
            
        } else {

            UIAlertController *alert=[UIAlertController alertControllerWithTitle:AMLocalizedString(@"error", nil) message:AMLocalizedString(@"try_again", nil) preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok=[UIAlertAction actionWithTitle:AMLocalizedString(@"ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self getCurencies];
                
            }];
            
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
        [DejalBezelActivityView removeViewAnimated:YES];

    } :^(NSError *error, NSString *errorMessage) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:AMLocalizedString(@"error", nil) message:AMLocalizedString(@"try_again", nil) preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok=[UIAlertAction actionWithTitle:AMLocalizedString(@"ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self getCurencies];
            
        }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        [DejalBezelActivityView removeViewAnimated:YES];

    }];
}

-(void)didSelectItem : (KPDropMenu *) dropMenu atIndex : (int) atIndex
{
    NSLog(@"%@",[[countryDropArr objectAtIndex:atIndex] valueForKey:@"country"]);
    
    countryID=[[countryDropArr objectAtIndex:atIndex] valueForKey:@"currencie_id"];
    
}


-(void)finalRegister
{
    [DejalBezelActivityView activityViewForView:[[[UIApplication sharedApplication] delegate] window]];

    [UKNetworkManager operationType:POST fromPath:@"user/add" withParameters:@{@"fullname":_fullNameTF.text,@"email":_mailTF.text,@"password":_passwordTF.text,@"mobile":_mobileTF.text,@"submit":@"Go",@"currencie_id":countryID}.mutableCopy withUploadData:nil :^(id result) {
        
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            
            UIAlertController * alert=[UIAlertController
                                       
                                       alertControllerWithTitle:AMLocalizedString(@"success", nil) message:AMLocalizedString(@"register_success", nil) preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:AMLocalizedString(@"conti_nue", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"REGISTER_DETAILS"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FIRST_STEP"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0 ] animated:YES];
                
                
            }];
            
            
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            
        } else {
            
            [self.view makeToast:[NSString stringWithFormat:@"%@\n %@",AMLocalizedString(@"error", nil),AMLocalizedString(@"try_again", nil)] duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];

            
        }
        
        [DejalBezelActivityView removeViewAnimated:YES];

        
    } :^(NSError *error, NSString *errorMessage) {
        
        [self.view makeToast:[NSString stringWithFormat:@"%@\n %@",AMLocalizedString(@"error", nil),AMLocalizedString(@"try_again", nil)] duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];
        [DejalBezelActivityView removeViewAnimated:YES];

        
    }];
}
- (IBAction)onTapSubmitBtn:(UIButton *)sender {
    
    if ([_fullNameTF hasText]) {
        if ([_mailTF hasText]) {
            if ([_mobileTF hasText]) {
                if ([_passwordTF hasText]) {
                    if (countryID.length>0) {
                        
                        [self finalRegister];
                        
                    } else {
                        [self.view makeToast:AMLocalizedString(@"complete_fields", nil) duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-80)]];

                    }
                } else {
                    [self.view makeToast:AMLocalizedString(@"complete_fields", nil) duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-80)]];

                }
            } else {
                [self.view makeToast:AMLocalizedString(@"complete_fields", nil) duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-80)]];

            }
        } else {
            [self.view makeToast:AMLocalizedString(@"complete_fields", nil) duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-80)]];

        }
    } else {
        [self.view makeToast:AMLocalizedString(@"complete_fields", nil) duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-80)]];

    }
    

    
}

- (IBAction)onTapBackToLogin:(UIButton *)sender {
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}
@end
