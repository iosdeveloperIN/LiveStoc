//
//  SplashScreensVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 11/21/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplashScreensVC : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *welComeLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *splashCollVw;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControll;
@property (strong, nonatomic) IBOutlet UIButton *skipBtn;
- (IBAction)onTapSkipBtn:(UIButton *)sender;

@end
