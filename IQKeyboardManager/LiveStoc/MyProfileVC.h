//
//  MyProfileVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 12/22/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProfileVC : UIViewController
@property (weak, nonatomic) IBOutlet UKImageView *profileImgVw;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *memberShipBtn;
- (IBAction)onTapMemberShipBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
- (IBAction)onTapEditBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *detailsTblVw;

@end

@interface EditProfileVC : UIViewController
@property (weak, nonatomic) IBOutlet UKImageView *myProfileImgVw;
@property (weak, nonatomic) IBOutlet UKTextField *fullNameTF;
@property (weak, nonatomic) IBOutlet KPDropMenu *genderDropDown;
@property (weak, nonatomic) IBOutlet KPDropMenu *countryDropDown;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (strong,nonatomic) NSMutableDictionary *details;
- (IBAction)onTapSubmitBtn:(UIButton *)sender;
- (IBAction)onTapImageVw:(UITapGestureRecognizer *)sender;
- (IBAction)ontapDismissBarBtn:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet KPDropMenu *addressTypeDropDown;
@property (weak, nonatomic) IBOutlet UKTextField *houseNumTF;
@property (weak, nonatomic) IBOutlet UKTextField *streetTF;
@property (weak, nonatomic) IBOutlet UKTextField *landMarkTF;
@property (weak, nonatomic) IBOutlet UKTextField *cityTF;
@property (weak, nonatomic) IBOutlet UKTextField *stateTF;
@property (weak, nonatomic) IBOutlet UKTextField *pinCodeTF;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@end

