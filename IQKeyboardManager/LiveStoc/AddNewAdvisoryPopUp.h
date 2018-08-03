//
//  AddNewAdvisoryPopUp.h
//  LiveStoc
//
//  Created by Harjit Singh on 1/17/18.
//  Copyright © 2018 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewAdvisoryPopUp : UIViewController
- (IBAction)onTapBackgroundOfPopUp:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *addQuestionLabel;
@property (weak, nonatomic) IBOutlet UKTextField *titleTF;
@property (weak, nonatomic) IBOutlet UKTextView *queryTV;
@property (weak, nonatomic) IBOutlet UIButton *postBtn;
- (IBAction)onTapPostQuestion:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImgVw;
@property (weak, nonatomic) IBOutlet UIImageView *thumbNailImgVw;
- (IBAction)onTapSelectImage:(UITapGestureRecognizer *)sender;

@end
