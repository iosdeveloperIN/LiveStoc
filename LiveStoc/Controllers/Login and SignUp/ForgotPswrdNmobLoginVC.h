//
//  ForgotPswrdNmobLoginVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 11/22/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPswrdNmobLoginVC : UIViewController


@property(nonatomic) BOOL isFromForgot;
@property (strong, nonatomic) IBOutlet UKTextField *mobileNumTF;
@property (strong, nonatomic) IBOutlet UIButton *submitBtn;
- (IBAction)onTapSubmitBtn:(UIButton *)sender;

@end

@interface RecoveryPasswordVC : UIViewController
@property (nonatomic)  BOOL isFromOTP;
@property(strong,nonatomic) NSString *email;
@end
