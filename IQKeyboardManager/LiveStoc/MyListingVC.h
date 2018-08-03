//
//  MyListingVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 11/24/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyListingVC : UIViewController
- (IBAction)onTapSegmentButtons:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *allSaleBtn;
@property (weak, nonatomic) IBOutlet UIButton *soldBtn;
@property (weak, nonatomic) IBOutlet UIButton *favouriteBtn;
@property (weak, nonatomic) IBOutlet UIView *barVw;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthOfBarView;
@property (weak, nonatomic) IBOutlet UIView *targetVw;
@property (nonatomic,strong) UIPageViewController *PageViewController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cartbarBtn;
- (IBAction)ontapCartBarBtn:(UIBarButtonItem *)sender;

@end
