//
//  LoginVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 11/22/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import "LoginVC.h"
#import "ForgotPswrdNmobLoginVC.h"
#import "RegisterVC.h"
#import "FinalRegisterVC.h"
#import "TabBarControllerClass.h"
@interface LoginVC ()<GIDSignInUIDelegate,GIDSignInDelegate>
{
    NSMutableDictionary *socialNetworkDetails,*mobileVerifDict;
    NSURL *url;
}
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLanguage];
    [[GIDSignIn sharedInstance] setClientID:@"559282035376-sf3bkojc07odarq8ofkuvaao00ufognm.apps.googleusercontent.com"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLanguage) name:@"language" object:nil];
    

    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countries" ofType:@"json"]];
    NSError *localError = nil;
    NSArray *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    if (localError == nil) {
        NSString *code=[UKNetworkManager getFromDefaultsWithKeyString:@"COUNTRY_CODE"];
        for (NSDictionary *dict in parsedObject) {
            
            if ([[dict valueForKey:@"code"] isEqualToString:code]) {
                
                self.countryCodeLabel.text=[NSString stringWithFormat:@"(+%@)",[dict valueForKey:@"callingCode"]];
                [UKNetworkManager saveToDefaults:[NSString stringWithFormat:@"+%@",[dict valueForKey:@"callingCode"]] withKeyString:@"CALLING_CODE"];
                break;
                
            }
        }
    }
}
-(void)setLanguage
{
    
    _regLogFbLbl.text=AMLocalizedString(@"or_reg", @"or_reg");
    _regMobileLbl.text=AMLocalizedString(@"or_reg_mobile", @"or_reg_mobile");
    [_getOTPBtn setTitle:AMLocalizedString(@"otp_get", @"") forState:UIControlStateNormal];
    _mobileTF.placeholder=AMLocalizedString(@"mobile_no", @"");
    
    [self.languageBtn setTitle:AMLocalizedString(@"CHOOSE_LANGUAGE", nil) forState:UIControlStateNormal];
    [self.loginBtn setTitle:AMLocalizedString(@"login", nil) forState:UIControlStateNormal];
    [self.registerBtn setTitle:AMLocalizedString(@"register", nil) forState:UIControlStateNormal];
    [self.forgetPasswordBtn setTitle:[NSString stringWithFormat:@"%@?",AMLocalizedString(@"forgot", nil)] forState:UIControlStateNormal];
    self.emailTF.placeholder=AMLocalizedString(@"email", nil);
    self.passwordTF.placeholder=AMLocalizedString(@"password", nil);
    

}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=YES;

}
-(void)viewWillDisappear:(BOOL)animated{
    
    self.navigationController.navigationBar.hidden=NO;
    
}

-(void)loginWithEmail
{
    [DejalBezelActivityView activityViewForView:[[[UIApplication sharedApplication] delegate] window]];

    [UKNetworkManager operationType:POST fromPath:@"userlogin/index" withParameters:@{@"username":_emailTF.text,@"password":_passwordTF.text,@"login":@"Login",@"fcm_ios":@"",}.mutableCopy withUploadData:nil :^(id result) {
        
        
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            
            [UKNetworkManager saveToDefaults:[[result valueForKey:@"data"]valueForKey:@"user_info"] withKeyString:USER_DETAILS];
            [UKNetworkManager saveToDefaults:[[[result valueForKey:@"data"] valueForKey:@"user_info"] valueForKey:@"users_id"] withKeyString:USER_ID];
            [UKNetworkManager saveToDefaults:[[[result valueForKey:@"data"] valueForKey:@"user_info"] valueForKey:@"token"] withKeyString:TOKEN];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LOGGEDIN"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            TabBarControllerClass *tabBar=[self.storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
            
            [self.navigationController pushViewController:tabBar animated:YES];
            
        } else {
            
            [UKNetworkManager showAlertWithTitle:[result valueForKey:@"data"] messageTitle:nil okTitle:nil cancelTitle:AMLocalizedString(@"ok", nil) otherTitles:nil];

            
        }
        
        [DejalBezelActivityView removeViewAnimated:YES];

    } :^(NSError *error, NSString *errorMessage) {
        
        [UKNetworkManager showAlertWithTitle:AMLocalizedString(@"error", nil) messageTitle:AMLocalizedString(@"try_again", nil) okTitle:nil cancelTitle:AMLocalizedString(@"ok", nil) otherTitles:nil];
        
        [DejalBezelActivityView removeViewAnimated:YES];

    }];
}

- (IBAction)onTapLanguageChange:(UIButton *)sender {
    
    
    UIAlertController * alert=[UIAlertController
                               
                               alertControllerWithTitle:@"Choose Language" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"English"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    LocalizationSetLanguage(@"en");
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"language" object:nil];
                                    
                                }];
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Punjabi"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   LocalizationSetLanguage(@"pa-IN");
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"language" object:nil];

                               }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"Cnacel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (IBAction)onTapRegisterBtn:(UIButton *)sender {
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FIRST_STEP"]) {
        
        FinalRegisterVC *final;
        final=[self.storyboard instantiateViewControllerWithIdentifier:@"FinalRegisterVC"];
        [self.navigationController pushViewController:final animated:YES];
        
    } else {
        RegisterVC *regist=[self.storyboard instantiateViewControllerWithIdentifier:@"RegisterVC"];
        [self.navigationController pushViewController:regist animated:YES];
    }
}



- (IBAction)onTapPhoneBtn:(UIButton *)sender {
    
    ForgotPswrdNmobLoginVC *forgot=[self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPswrdNmobLoginVC"];
    forgot.isFromForgot=NO;
    [self.navigationController pushViewController:forgot animated:YES];
    
}
- (IBAction)onTapForgetPasswrd:(UKButton *)sender {
    
    ForgotPswrdNmobLoginVC *forgot=[self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPswrdNmobLoginVC"];
    forgot.isFromForgot=YES;
    [self.navigationController pushViewController:forgot animated:YES];
}
- (IBAction)onTapLogin:(UIButton *)sender {
    
    if ([_emailTF hasText]) {
        if ([_passwordTF hasText]) {
            
            [self loginWithEmail];
        } else {
            [self.view makeToast:AMLocalizedString(@"enter_valid_password", nil) duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];
            
        }
    } else {
        [self.view makeToast:AMLocalizedString(@"enter_email_error", nil) duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];

    }
    
}

- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (user) {
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *fullName = user.profile.name;
    NSString *email = user.profile.email;
        
    socialNetworkDetails=[[NSMutableDictionary alloc] init];
socialNetworkDetails=@{@"email":email,@"gmail":userId,@"fullname":fullName,@"gender":@"",@"login":@"Login",@"fcm_ios":@""}.mutableCopy;
        
        [self loginWithFaceBookAndGmail:socialNetworkDetails];

    }
}

- (IBAction)onTapGooglePlusBtn:(UIButton *)sender {

    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    [[GIDSignIn sharedInstance] signIn];
    
}
- (IBAction)onTapGoogleSignOut:(UIButton *)sender {
    
    [[GIDSignIn sharedInstance] signOut];
    
}
- (IBAction)onTapFacebookBtn:(UIButton *)sender {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    if ([UIApplication.sharedApplication canOpenURL:[NSURL URLWithString:@"fb://"]])
    {
        login.loginBehavior = FBSDKLoginBehaviorSystemAccount;
    }
    
    [login logInWithReadPermissions:@[@"public_profile", @"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        
        if (error)
        {
            NSLog(@"Unexpected login error: %@", error);
            NSString *alertMessage = error.userInfo[FBSDKErrorLocalizedDescriptionKey] ?: @"There was a problem logging in. Please try again later.";
            NSString *alertTitle = error.userInfo[FBSDKErrorLocalizedTitleKey] ?: @"Oops";
            [[[UIAlertView alloc] initWithTitle:alertTitle
                                        message:alertMessage
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
        else
        {
            if(result.token)
            {
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                                   parameters:@{@"fields": @"id,gender,name, email"}]
                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id userinfo, NSError *error) {
                     if (!error) {
                         dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                         dispatch_async(queue, ^(void) {
                             
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 
                                 NSLog(@"USER DETSL :%@",userinfo);
                                 socialNetworkDetails=[[NSMutableDictionary alloc] init];
                                 
                                 socialNetworkDetails=@{@"email":[userinfo valueForKey:@"email"],@"facebook":[userinfo valueForKey:@"id"],@"fullname":[userinfo valueForKey:@"name"],@"gender":[userinfo valueForKey:@"gender"],@"login":@"Login",@"fcm_ios":@""}.mutableCopy;
                                 if ([userinfo valueForKey:@"email"]) {
                                     
                                     [self loginWithFaceBookAndGmail:socialNetworkDetails];

                                 } else {
                                     
                                     [self.view makeToast:@"Can't Login with Facebook" duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];
                                 }
                             });
                         });
                     }
                     else{
                         [self.view makeToast:[NSString stringWithFormat:@"%@\n %@",AMLocalizedString(@"error", nil),AMLocalizedString(@"try_again", nil)] duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];
                     }
                 }];
            }
        }
    }];
}

-(void)loginWithFaceBookAndGmail:(NSMutableDictionary *)params
{
    [DejalBezelActivityView activityViewForView:[[[UIApplication sharedApplication] delegate] window]];

    [UKNetworkManager operationType:POST fromPath:@"userlogin/gmaillogin" withParameters:params withUploadData:nil :^(id result) {
        
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            
            [UKNetworkManager saveToDefaults:[[result valueForKey:@"data"]valueForKey:@"user_info"] withKeyString:USER_DETAILS];
            [UKNetworkManager saveToDefaults:[[[result valueForKey:@"data"] valueForKey:@"user_info"] valueForKey:@"users_id"] withKeyString:USER_ID];
            [UKNetworkManager saveToDefaults:[[[result valueForKey:@"data"] valueForKey:@"user_info"] valueForKey:@"token"] withKeyString:TOKEN];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SOCIAL_LOGIN"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LOGGEDIN"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            TabBarControllerClass *tabBar=[self.storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
            [self.navigationController pushViewController:tabBar animated:YES];
            
        } else {
            
            [self.view makeToast:[NSString stringWithFormat:@"%@\n %@",AMLocalizedString(@"error", nil),AMLocalizedString(@"try_again", nil)] duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];

        }
        
        [DejalBezelActivityView removeViewAnimated:YES];
    } :^(NSError *error, NSString *errorMessage) {
        
        [self.view makeToast:[NSString stringWithFormat:@"%@\n %@",AMLocalizedString(@"error", nil),AMLocalizedString(@"try_again", nil)] duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];
        [DejalBezelActivityView removeViewAnimated:YES];
    }];
    
    
}

- (IBAction)onTapGetOtp:(UIButton *)sender {
    if ([_mobileTF hasText]) {
        // checking demo phone number for apple app review team
        if ([_mobileTF.text isEqualToString:@"5348297106"]) {
            
            [UKNetworkManager saveToDefaults:_mobileTF.text withKeyString:@"MOBILE_NUMBER"];
            
            RecoveryPasswordVC *recovery=[self.storyboard instantiateViewControllerWithIdentifier:@"RecoveryPasswordVC"];
            recovery.isFromOTP=YES;
            [self.navigationController pushViewController:recovery animated:YES];
            
            
        } else {
            [self verifyMobile];

        }
    } else {
        
        [self.view makeToast:AMLocalizedString(@"enter_mobile_msg", nil) duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];
    }
}

-(void)verifyMobile
{
    NSString * post=[NSString stringWithFormat:@""];
    url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://2factor.in/API/V1/85aab6cd-b267-11e7-94da-0200cd936042/SMS/%@/AUTOGEN/login",_mobileTF.text]];
    
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
                    
                    [UKNetworkManager saveToDefaults:[mobileVerifDict valueForKey:@"Details"] withKeyString:@"MOBILE_KEY"];
                    [UKNetworkManager saveToDefaults:_mobileTF.text withKeyString:@"MOBILE_NUMBER"];
                    
                    RecoveryPasswordVC *recovery=[self.storyboard instantiateViewControllerWithIdentifier:@"RecoveryPasswordVC"];
                    recovery.isFromOTP=YES;
                    [self.navigationController pushViewController:recovery animated:YES];
                    
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


@end
