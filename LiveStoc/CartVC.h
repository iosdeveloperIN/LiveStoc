//
//  CartVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 1/22/18.
//  Copyright © 2018 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartVC : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *cartTblVw;
@property (weak, nonatomic) IBOutlet UILabel *productTotalAttrib;
@property (weak, nonatomic) IBOutlet UILabel *taxAttrib;
@property (weak, nonatomic) IBOutlet UILabel *shippingAttrib;
@property (weak, nonatomic) IBOutlet UILabel *totalAttrib;
@property (weak, nonatomic) IBOutlet UILabel *productTotalAmnt;
@property (weak, nonatomic) IBOutlet UILabel *taxLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmntLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmOrderBtn;
- (IBAction)onTapConfirmOrder:(UKButton *)sender;
- (IBAction)minusAction:(UIButton *)sender;
- (IBAction)plusAction:(UIButton *)sender;
- (IBAction)onTapRemoveFromCart:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UKView *priceVw;
@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;

@end
