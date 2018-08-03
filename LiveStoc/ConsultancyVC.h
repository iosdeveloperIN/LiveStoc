//
//  ConsultancyVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 1/29/18.
//  Copyright © 2018 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MessageUI;

@interface ConsultancyVC : UIViewController
- (IBAction)onTapCloseBarBtn:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *finalLabl;
@property (weak, nonatomic) IBOutlet UIButton *buybtn;
- (IBAction)onTapBuyBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UITextView *mailTextView;

@end




@interface AllInfoVC : UIViewController
- (IBAction)onTapCloseBarBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;
@property (weak, nonatomic) IBOutlet UITextView *mailTextView;

@end
