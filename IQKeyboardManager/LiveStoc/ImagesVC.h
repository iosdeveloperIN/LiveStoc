//
//  ImagesVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 12/14/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MessageUI;
@interface ImagesVC : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *largeCollVw;
@property (weak, nonatomic) IBOutlet UICollectionView *smallCollVw;
@property(nonatomic)  NSInteger selectedIndex;
@property (weak, nonatomic)  NSMutableArray *imagesArr;
@property(strong,nonatomic) NSString *navTitle;
@end

@interface ContactUsVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *fillFormLabel;
@property (weak, nonatomic) IBOutlet UKTextField *fullNameTf;
@property (weak, nonatomic) IBOutlet UKTextField *emailTF;
@property (weak, nonatomic) IBOutlet UKTextField *mobileNumberTF;
@property (weak, nonatomic) IBOutlet UKTextView *descriptionTextVw;
@property (weak, nonatomic) IBOutlet UIButton *sendMailBtn;
- (IBAction)onTapSendMail:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *orLabel;
@property (weak, nonatomic) IBOutlet UILabel *tollFreeLbl;
@property (weak, nonatomic) IBOutlet UIButton *callToNumberBtn;
- (IBAction)onTapCallToBtn:(UIButton *)sender;


@end
