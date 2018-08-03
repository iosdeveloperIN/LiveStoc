//
//  AddressVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 1/22/18.
//  Copyright © 2018 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressVC : UIViewController
- (IBAction)onTapCheckbox:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *shippingAddressLbl;
@property (weak, nonatomic) IBOutlet UILabel *billingSameLbl;
@property (weak, nonatomic) IBOutlet UILabel *bllingAddrssLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceWhenNoBilling;
@property (weak, nonatomic) IBOutlet UIView *billingView;
@property(strong,nonatomic) NSDictionary *detailsDict;
@property (weak, nonatomic) IBOutlet UKTextField *fullNameShippingTF;
@property (weak, nonatomic) IBOutlet UKTextField *mobileNumShippingTF;
@property (weak, nonatomic) IBOutlet UKTextField *pinCodeShippingTF;
@property (weak, nonatomic) IBOutlet UKTextField *houseNumShippingTF;
@property (weak, nonatomic) IBOutlet UKTextField *streetShippingTF;
@property (weak, nonatomic) IBOutlet UKTextField *landMarkShippingTF;
@property (weak, nonatomic) IBOutlet UKTextField *cityShippingTF;
@property (weak, nonatomic) IBOutlet UKTextField *stateShippingTF;

@property (weak, nonatomic) IBOutlet UKTextField *fullNameBillingTF;
@property (weak, nonatomic) IBOutlet UKTextField *mobileNumBillingTF;
@property (weak, nonatomic) IBOutlet UKTextField *pinCodeBillingTF;
@property (weak, nonatomic) IBOutlet UKTextField *houseNumBillingTF;
@property (weak, nonatomic) IBOutlet UKTextField *streetBillingTF;
@property (weak, nonatomic) IBOutlet UKTextField *landMarkBillingTF;
@property (weak, nonatomic) IBOutlet UKTextField *cityBillingTF;
@property (weak, nonatomic) IBOutlet UKTextField *stateBillingTF;
@property (weak, nonatomic) IBOutlet UIButton *checkBoxBtn;
@property (weak, nonatomic) IBOutlet UIButton *deliverBtn;
- (IBAction)onTapDeliverBtn:(UIButton *)sender;


@end
