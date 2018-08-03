//
//  RegisterVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 11/22/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import "RegisterVC.h"
#import "FinalRegisterVC.h"
@interface RegisterVC ()
{
    NSMutableDictionary *submitNamesDict;
    NSMutableDictionary *detailsFinalDict,*mobileVerifDict;
    NSInteger index;
    NSURL *url;
}
@end

@implementation RegisterVC



- (void)viewDidLoad {
    [super viewDidLoad];
    index=0;

    submitNamesDict=[[NSMutableDictionary alloc] init];
    submitNamesDict=
  @{
    @"forLabel":@[
        [NSString stringWithFormat:@"%@",AMLocalizedString(@"enter_email_msg",nil)],
        [NSString stringWithFormat:@"%@",AMLocalizedString(@"verify_email_msg",nil)],
        [NSString stringWithFormat:@"%@",AMLocalizedString(@"enter_mobile_msg",nil)],
        [NSString stringWithFormat:@"%@",AMLocalizedString(@"verify_code_msg",nil)]
        ].mutableCopy,
    @"forTF":@[
        AMLocalizedString(@"enter_email", nil),
        AMLocalizedString(@"email_code", nil),
        AMLocalizedString(@"mobile_no", nil),
        AMLocalizedString(@"otp_enter", nil)
            ].mutableCopy,
    @"path":@[@"user/emailcodesent",@"",@"user/mobilecodesent",@""].mutableCopy,
    @"param":@[@"email",@"",@"mobile",@""].mutableCopy
    }.mutableCopy;
    
    
//    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    _infoLabl.text=AMLocalizedString(@"new_register", nil);
    _emailTF.placeholder=AMLocalizedString(@"email", nil);
    _emailLabel.text=AMLocalizedString(@"enter_email_msg", nil);
    [_nextBtn setTitle:AMLocalizedString(@"next", nil) forState:UIControlStateNormal];

    
    
}

- (IBAction)onTapNextBtn:(UIButton *)sender {
    

        switch (index) {
            case 0:
                
                detailsFinalDict=[[NSMutableDictionary alloc] init];
                
                [self sendCodeToMail:AMLocalizedString(@"enter_email_msg", nil)];
                
                break;
                
            case 1:
                if ([_emailTF.text isEqualToString:[UKNetworkManager getFromDefaultsWithKeyString:@"EMAIL_CODE"]]) {
                    
                    [self.view makeToast:AMLocalizedString(@"code_match", nil) duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];

                    [self nextStep];
                    
                } else {
                    
                    [UKNetworkManager showAlertWithTitle:AMLocalizedString(@"code_not_match", nil) messageTitle:nil okTitle:nil cancelTitle:AMLocalizedString(@"ok", nil) otherTitles:nil];
                }
                break;
            case 2:
                [self sendCodeToMail:[NSString stringWithFormat:@"%@",AMLocalizedString(@"enter_mobile_msg", nil)]];
                break;
            case 3:
                if ([_emailTF hasText]) {
                    
                    [self verifyMobile];
                    
                } else {
                    
                    [UKNetworkManager showAlertWithTitle:[NSString stringWithFormat:@"%@",AMLocalizedString(@"enter_mobile_msg", nil)] messageTitle:nil okTitle:nil cancelTitle:AMLocalizedString(@"ok", nil) otherTitles:nil];
                    
                }
                break;
                
        }
    
}
-(void)sendCodeToMail:(NSString *)errorTitle
{
    if ([_emailTF hasText]) {
        [DejalBezelActivityView activityViewForView:[[[UIApplication sharedApplication] delegate] window]];

        [UKNetworkManager operationType:POST fromPath:[[submitNamesDict valueForKey:@"path"] objectAtIndex:index] withParameters:@{[[submitNamesDict valueForKey:@"param"] objectAtIndex:index]:_emailTF.text}.mutableCopy withUploadData:nil :^(id result) {
            
            
            if ([index == 0 ? [result valueForKey:@"success"] : [result valueForKey:@"Status"] isEqualToString:index == 0 ? @"1" : @"Success"])
            {
                
                index == 0 ? [UKNetworkManager saveToDefaults:[result valueForKey:@"data"] withKeyString:@"EMAIL_CODE"] : [UKNetworkManager saveToDefaults:[result valueForKey:@"Details"] withKeyString:@"MOBILE_KEY"];
                
                
                [detailsFinalDict setValue:_emailTF.text forKey:[[submitNamesDict valueForKey:@"param"] objectAtIndex:index]];
                
                [self.view makeToast:[NSString stringWithFormat:@"%@ %@",AMLocalizedString(@"activation_code_sent", @"activation_code_sent"),[[submitNamesDict valueForKey:@"param"] objectAtIndex:index]] duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];

                [self nextStep];
                
            } else {
                [UKNetworkManager showAlertWithTitle:index==0 ?[[result valueForKey:@"data"] objectAtIndex:0] :[result valueForKey:@"Details"] messageTitle:nil okTitle:nil cancelTitle:AMLocalizedString(@"ok", nil) otherTitles:nil];

            }
            [DejalBezelActivityView removeViewAnimated:YES];

        } :^(NSError *error, NSString *errorMessage) {
            [DejalBezelActivityView removeViewAnimated:YES];

            [UKNetworkManager showAlertWithTitle:errorMessage messageTitle:nil okTitle:nil cancelTitle:AMLocalizedString(@"ok", nil) otherTitles:nil];
        }];
    
    } else {
        
        [UKNetworkManager showAlertWithTitle:errorTitle messageTitle:nil okTitle:nil cancelTitle:AMLocalizedString(@"ok", nil) otherTitles:nil];
    }
}
-(void)nextStep
{
    index=index+1;
    _emailTF.text=nil;

    __block  CGRect basketTopFrame = _emailLabel.frame;
    basketTopFrame.origin.x = -500;
    
    [UIView animateWithDuration:0.3 animations:^{
        _emailLabel.frame = basketTopFrame;
        
    } completion:^(BOOL finished) {
        basketTopFrame.origin.x = 500;
        _emailLabel.frame = basketTopFrame;
        [UIView animateWithDuration:0.3 animations:^{
            
            basketTopFrame.origin.x = 10;
            _emailLabel.frame = basketTopFrame;
            
            _emailLabel.text=[[submitNamesDict valueForKey:@"forLabel"] objectAtIndex:index];
            _emailTF.placeholder=[[submitNamesDict valueForKey:@"forTF"] objectAtIndex:index];
            
        } completion:^(BOOL finished) {
            
        }];
    }];
}

-(void)verifyMobile
{
    NSString * post=[NSString stringWithFormat:@""];
    url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://2factor.in/API/V1/85aab6cd-b267-11e7-94da-0200cd936042/SMS/VERIFY/%@/%@",[UKNetworkManager getFromDefaultsWithKeyString:@"MOBILE_KEY"],_emailTF.text]];
    [DejalBezelActivityView activityViewForView:[[[UIApplication sharedApplication] delegate] window]];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            NSLog(@"URL ====== %@",url);
            
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            
            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
            
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:url];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            
            
            NSError *error;
            NSHTTPURLResponse *response = nil;
            
            NSData * urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            NSLog(@"Response code: %ld", (long)[response statusCode]);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if (urlData)
                {
                    mobileVerifDict=[[NSMutableDictionary alloc] init];
                    mobileVerifDict = [NSJSONSerialization
                                       JSONObjectWithData:[urlData mutableCopy]
                                       options:NSJSONReadingMutableContainers
                                       error:nil];
                    if ([[mobileVerifDict objectForKey:@"Status"] isEqualToString:@"Success"])
                    {
                        
                        [UKNetworkManager saveToDefaults:detailsFinalDict withKeyString:@"REGISTER_DETAILS"];
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FIRST_STEP"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    FinalRegisterVC *final;
                    final=[self.storyboard instantiateViewControllerWithIdentifier:@"FinalRegisterVC"];
                    [self.navigationController pushViewController:final animated:YES];
                        
                        
                        
                    }
                    else
                    {
                        [UKNetworkManager showAlertWithTitle:[mobileVerifDict objectForKey:@"Details"] messageTitle:nil okTitle:nil cancelTitle:AMLocalizedString(@"ok", nil) otherTitles:nil];
                    }
                    [DejalBezelActivityView removeViewAnimated:YES];
                }
                else
                {
                    NSLog(@"%@",error.localizedDescription);
                    [UKNetworkManager showAlertWithTitle:AMLocalizedString(@"error", nil) messageTitle:nil okTitle:nil cancelTitle:AMLocalizedString(@"ok", nil) otherTitles:nil];
                    [DejalBezelActivityView removeViewAnimated:YES];
                }
            });
        });
}
- (IBAction)onTapBackBtn:(UIButton *)sender {
    
    if (index!=0) {
        index=index-1;
        _emailTF.text=nil;
        __block  CGRect basketTopFrame = _emailLabel.frame;
        basketTopFrame.origin.x = 500;
        
        [UIView animateWithDuration:0.3 animations:^{
            _emailLabel.frame = basketTopFrame;
            
        } completion:^(BOOL finished) {
            basketTopFrame.origin.x = -500;
            _emailLabel.frame = basketTopFrame;
            [UIView animateWithDuration:0.3 animations:^{
                
                basketTopFrame.origin.x = 10;
                _emailLabel.frame = basketTopFrame;
                
                _emailLabel.text=[[submitNamesDict valueForKey:@"forLabel"] objectAtIndex:index];
                _emailTF.placeholder=[[submitNamesDict valueForKey:@"forTF"] objectAtIndex:index];
                
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
}


@end
