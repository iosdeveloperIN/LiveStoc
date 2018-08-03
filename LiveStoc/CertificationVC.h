//
//  CertificationVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 1/29/18.
//  Copyright © 2018 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MessageUI;
@interface CertificationVC : UIViewController
- (IBAction)onTapClose:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellerBenefitLbl;
@property (weak, nonatomic) IBOutlet UILabel *anwSellerBenefitLbl;
@property (weak, nonatomic) IBOutlet UILabel *processLbl;
@property (weak, nonatomic) IBOutlet UILabel *anwProcessLbl;
@property (weak, nonatomic) IBOutlet UILabel *buyerBenftLbl;
@property (weak, nonatomic) IBOutlet UILabel *anwBenftLbl;
@property (weak, nonatomic) IBOutlet UILabel *eightLabel;
@property (weak, nonatomic) IBOutlet UILabel *nineLabel;
@property (weak, nonatomic) IBOutlet UITextView *mailTextView;

@end
