//
//  RegisterVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 11/22/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterVC : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *infoLabl;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
- (IBAction)onTapNextBtn:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UKTextField *emailTF;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
- (IBAction)onTapBackBtn:(UIButton *)sender;

@end
