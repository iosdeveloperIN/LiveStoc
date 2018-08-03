//
//  LoginVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 11/22/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LoginVC : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *languageBtn;
- (IBAction)onTapLanguageChange:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UKTextField *emailTF;
@property (strong, nonatomic) IBOutlet UKTextField *passwordTF;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)onTapLogin:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UKButton *forgetPasswordBtn;
- (IBAction)onTapForgetPasswrd:(UKButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *registerBtn;
- (IBAction)onTapRegisterBtn:(UIButton *)sender;
- (IBAction)onTapFacebookBtn:(UIButton *)sender;
- (IBAction)onTapGooglePlusBtn:(UIButton *)sender;
- (IBAction)onTapPhoneBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *countryCodeLabel;
@property (weak, nonatomic) IBOutlet UITextField *mobileTF;
@property (weak, nonatomic) IBOutlet UIButton *getOTPBtn;
- (IBAction)onTapGetOtp:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *regMobileLbl;
@property (weak, nonatomic) IBOutlet UILabel *regLogFbLbl;

@end
