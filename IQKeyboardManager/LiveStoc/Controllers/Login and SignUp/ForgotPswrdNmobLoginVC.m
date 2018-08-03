//
//  ForgotPswrdNmobLoginVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 11/22/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import "ForgotPswrdNmobLoginVC.h"
#import "TabBarControllerClass.h"
@interface ForgotPswrdNmobLoginVC ()
{
    NSURL *url;
    NSMutableDictionary *mobileVerifDict;
}
@end

@implementation ForgotPswrdNmobLoginVC
@synthesize isFromForgot;
- (void)viewDidLoad {
    [super viewDidLoad];
    if (isFromForgot) {
        self.navigationItem.title=AMLocalizedString(@"forgot_pass", nil);
        _mobileNumTF.placeholder=AMLocalizedString(@"email", nil);
        [_submitBtn setTitle:AMLocalizedString(@"otp_code", nil) forState:UIControlStateNormal];
        _mobileNumTF.keyboardType=UIKeyboardTypeEmailAddress;
    } else {
        self.navigationItem.title=AMLocalizedString(@"PHONE", nil);
        _mobileNumTF.placeholder=AMLocalizedString(@"MOBILE_NO", nil);
        [_submitBtn setTitle:AMLocalizedString(@"GET_OTP", nil) forState:UIControlStateNormal];
        _mobileNumTF.keyboardType=UIKeyboardTypePhonePad;

    }
}
-(void)viewWillAppear:(BOOL)animated
{

}
-(void)viewWillDisappear:(BOOL)animated
{
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@" "
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)onTapSubmitBtn:(UIButton *)sender {
    if ([_mobileNumTF hasText]) {
      
    if (isFromForgot) {
        
        [self sendCodeToMail];
    } else{
    }
    } else {
        
        [self.view makeToast:AMLocalizedString(@"complete_fields", nil) duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];

    }
}

//
//
-(void)sendCodeToMail
{
    [DejalBezelActivityView activityViewForView:[[[UIApplication sharedApplication] delegate] window]];
    [UKNetworkManager operationType:POST fromPath:@"userlogin/checkforgot" withParameters:@{@"email":_mobileNumTF.text}.mutableCopy withUploadData:nil :^(id result) {
        
        if ([[result valueForKey:SUCCESS] integerValue]==1) {

            UIAlertController * alert=[UIAlertController
                                       
                                       alertControllerWithTitle:AMLocalizedString(@"activation_code_sent", nil) message:[NSString stringWithFormat:@"%@ %@",AMLocalizedString(@"activation_code_sent_to", nil),_mobileNumTF.text] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:AMLocalizedString(@"conti_nue", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                RecoveryPasswordVC *recovery=[self.storyboard instantiateViewControllerWithIdentifier:@"RecoveryPasswordVC"];
                recovery.isFromOTP=NO;
                recovery.email=_mobileNumTF.text;
                [self.navigationController pushViewController:recovery animated:YES];
                
            }];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            
        } else {
            
            [UKNetworkManager showAlertWithTitle:[result valueForKey:@"data"] messageTitle:nil okTitle:nil cancelTitle:AMLocalizedString(@"ok", nil) otherTitles:nil];

        }
        [DejalBezelActivityView removeViewAnimated:YES];

        
    } :^(NSError *error, NSString *errorMessage) {
        
        
        [DejalBezelActivityView removeViewAnimated:YES];
        [UKNetworkManager showAlertWithTitle:AMLocalizedString(@"error", nil) messageTitle:AMLocalizedString(@"try_again", nil) okTitle:nil cancelTitle:AMLocalizedString(@"ok", nil) otherTitles:nil];

    }];
    
}





@end

@interface RecoveryPasswordVC ()
{
    NSURL *url;
    NSMutableDictionary *mobileVerifDict;
}
@property (strong, nonatomic) IBOutlet UKTextField *verificationCodeTF;
@property (weak, nonatomic) IBOutlet UKTextField *passwordNewTF;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

- (IBAction)onTapSubmitBtn:(UIButton *)sender;

@end

@implementation RecoveryPasswordVC
@synthesize isFromOTP,email;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (isFromOTP) {
        
        self.verificationCodeTF.hidden=YES;

        self.navigationItem.title=AMLocalizedString(@"otp_verify", nil);
        self.passwordNewTF.placeholder=AMLocalizedString(@"otp_enter", nil);
        [_submitBtn setTitle:AMLocalizedString(@"otp_verify", nil) forState:UIControlStateNormal];
        
    } else {
        
        self.navigationItem.title=AMLocalizedString(@"new_pass", nil);
        self.verificationCodeTF.placeholder=AMLocalizedString(@"code", nil);
        self.passwordNewTF.placeholder=AMLocalizedString(@"new_pass", nil);
        [_submitBtn setTitle:AMLocalizedString(@"submit", nil) forState:UIControlStateNormal];
    
    }
    

}
-(void)viewWillAppear:(BOOL)animated
{
        
}
- (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
    
}


-(void)verifyMobile
{
    NSString * post=[NSString stringWithFormat:@""];
    url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://2factor.in/API/V1/85aab6cd-b267-11e7-94da-0200cd936042/SMS/VERIFY/%@/%@",[UKNetworkManager getFromDefaultsWithKeyString:@"MOBILE_KEY"],_passwordNewTF.text]];
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
                    
                    
                    [UKNetworkManager operationType:POST fromPath:@"userlogin/mobilelogin" withParameters:@{@"mobile":[UKNetworkManager getFromDefaultsWithKeyString:@"MOBILE_NUMBER"],@"login":@"Login",@"fcm_ios":@"",}.mutableCopy withUploadData:nil :^(id result) {
                        
                        
                        if ([[result valueForKey:SUCCESS] integerValue]==1) {
                            
                            [UKNetworkManager saveToDefaults:[[result valueForKey:@"data"]valueForKey:@"user_info"] withKeyString:USER_DETAILS];
                            [UKNetworkManager saveToDefaults:[[[result valueForKey:@"data"] valueForKey:@"user_info"] valueForKey:@"users_id"] withKeyString:USER_ID];
                            [UKNetworkManager saveToDefaults:[[[result valueForKey:@"data"] valueForKey:@"user_info"] valueForKey:@"token"] withKeyString:TOKEN];
                            [DejalBezelActivityView removeViewAnimated:YES];

                            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LOGGEDIN"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            TabBarControllerClass *tabBar=[self.storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
                            
                            [self.navigationController pushViewController:tabBar animated:YES];
                            
                        } else {
                            
                            [UKNetworkManager showAlertWithTitle:AMLocalizedString(@"error", nil) messageTitle:AMLocalizedString(@"try_again", nil) okTitle:nil cancelTitle:AMLocalizedString(@"ok", nil) otherTitles:nil];
                            [DejalBezelActivityView removeViewAnimated:YES];

                        }

                    } :^(NSError *error, NSString *errorMessage) {
                        
                        [UKNetworkManager showAlertWithTitle:AMLocalizedString(@"error", nil) messageTitle:AMLocalizedString(@"try_again", nil) okTitle:nil cancelTitle:AMLocalizedString(@"ok", nil) otherTitles:nil];

                        [DejalBezelActivityView removeViewAnimated:YES];

                    }];
                    
                    
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
                [UKNetworkManager showAlertWithTitle:AMLocalizedString(@"error", nil) messageTitle:AMLocalizedString(@"try_again", nil) okTitle:nil cancelTitle:AMLocalizedString(@"ok", nil) otherTitles:nil];
                
                [DejalBezelActivityView removeViewAnimated:YES];
            }
        });
    });
}

-(void)toCheckForDemo
{
    [DejalBezelActivityView activityViewForView:[[[UIApplication sharedApplication] delegate] window]];

    [UKNetworkManager operationType:POST fromPath:@"userlogin/mobilelogin" withParameters:@{@"mobile":[UKNetworkManager getFromDefaultsWithKeyString:@"MOBILE_NUMBER"],@"login":@"Login",@"fcm_ios":@"",}.mutableCopy withUploadData:nil :^(id result) {
        
        
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            
            [UKNetworkManager saveToDefaults:[[result valueForKey:@"data"]valueForKey:@"user_info"] withKeyString:USER_DETAILS];
            [UKNetworkManager saveToDefaults:[[[result valueForKey:@"data"] valueForKey:@"user_info"] valueForKey:@"users_id"] withKeyString:USER_ID];
            [UKNetworkManager saveToDefaults:[[[result valueForKey:@"data"] valueForKey:@"user_info"] valueForKey:@"token"] withKeyString:TOKEN];
            [DejalBezelActivityView removeViewAnimated:YES];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LOGGEDIN"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            TabBarControllerClass *tabBar=[self.storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
            
            [self.navigationController pushViewController:tabBar animated:YES];
            
        } else {
            
            [UKNetworkManager showAlertWithTitle:AMLocalizedString(@"error", nil) messageTitle:AMLocalizedString(@"try_again", nil) okTitle:nil cancelTitle:AMLocalizedString(@"ok", nil) otherTitles:nil];
            [DejalBezelActivityView removeViewAnimated:YES];
            
        }
        
    } :^(NSError *error, NSString *errorMessage) {
        
        [UKNetworkManager showAlertWithTitle:AMLocalizedString(@"error", nil) messageTitle:AMLocalizedString(@"try_again", nil) okTitle:nil cancelTitle:AMLocalizedString(@"ok", nil) otherTitles:nil];
        
        [DejalBezelActivityView removeViewAnimated:YES];
        
    }];
}

-(void)recoverPassword
{
    [DejalBezelActivityView activityViewForView:[[[UIApplication sharedApplication] delegate] window]];
    [UKNetworkManager operationType:POST fromPath:@"userlogin/recoverpassword" withParameters:@{@"email":email,@"activationcode":_verificationCodeTF.text,@"password":_passwordNewTF.text}.mutableCopy withUploadData:nil :^(id result) {
        
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            
            
            [self.view makeToast:[result valueForKey:@"data"] duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];

            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];

        } else {
            
            [UKNetworkManager showAlertWithTitle:[result valueForKey:@"data"] messageTitle:nil okTitle:nil cancelTitle:AMLocalizedString(@"ok", nil) otherTitles:nil];
            
        }
        [DejalBezelActivityView removeViewAnimated:YES];

        
    } :^(NSError *error, NSString *errorMessage) {
        
        [UKNetworkManager showAlertWithTitle:AMLocalizedString(@"error", nil) messageTitle:AMLocalizedString(@"try_again", nil) okTitle:nil cancelTitle:AMLocalizedString(@"ok", nil) otherTitles:nil];
        [DejalBezelActivityView removeViewAnimated:YES];

    }];
    
}
- (IBAction)onTapSubmitBtn:(UIButton *)sender {
    
    if (isFromOTP) {
        if ([_passwordNewTF hasText]) {
            
            //demo phone number and demo otp for apple app review team
            if ([[UKNetworkManager getFromDefaultsWithKeyString:@"MOBILE_NUMBER"] isEqualToString:@"5348297106"] && [_passwordNewTF.text isEqualToString:@"104072"]) {
                
                [self toCheckForDemo];
                
            } else {
                
                [self verifyMobile];
            }
            
        } else {
            [self.view makeToast:AMLocalizedString(@"complete_fields", nil) duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];
        }
    } else {
        if ([_verificationCodeTF hasText]) {
            if ([_passwordNewTF hasText]) {

                [self recoverPassword];
                

            } else {
                [self.view makeToast:AMLocalizedString(@"enter_valid_password", nil) duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];
            }
        } else {
            [self.view makeToast:AMLocalizedString(@"enter_verifiy_mobile", nil) duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];
        }
    }
}


@end



