//
//  ArticlesVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 1/15/18.
//  Copyright © 2018 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticlesVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *articlesTblVw;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceOfActionPopView;
@property (weak, nonatomic) IBOutlet UITableView *popTableVw;
@property (weak, nonatomic) IBOutlet UIButton *cnacelBtn;
- (IBAction)onTapCancelBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *filterBarButton;
- (IBAction)onTapFilterBarButton:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIButton *backGroundBtn;
- (IBAction)onTapBackgroundBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *noArticlesLabel;



@end
