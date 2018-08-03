//
//  EnterLocationVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 12/9/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnterLocationVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *locTblVw;
@property (weak, nonatomic) IBOutlet UKView *backView;
- (IBAction)onTapBackButton:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UILabel *animalLocatedLabel;
@property (weak, nonatomic) IBOutlet UKButton *locationBtn;
- (IBAction)onTapLocationBtn:(UKButton *)sender;

@end
