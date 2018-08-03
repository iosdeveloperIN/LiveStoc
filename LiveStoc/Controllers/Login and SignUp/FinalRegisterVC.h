//
//  FinalRegisterVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 11/23/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinalRegisterVC : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *backToLogin;
@property (strong, nonatomic) IBOutlet UKTextField *fullNameTF;
@property (strong, nonatomic) IBOutlet UKTextField *mailTF;
@property (strong, nonatomic) IBOutlet UKTextField *mobileTF;
@property (strong, nonatomic) IBOutlet UKTextField *passwordTF;
@property (strong, nonatomic) IBOutlet UIButton *submitBtn;
- (IBAction)onTapSubmitBtn:(UIButton *)sender;
- (IBAction)onTapBackToLogin:(UIButton *)sender;
@property(strong,nonatomic) NSDictionary *details;
@property (weak, nonatomic) IBOutlet KPDropMenu *countryDropDown;
@end
