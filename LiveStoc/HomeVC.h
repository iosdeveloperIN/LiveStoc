//
//  HomeVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 11/23/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeVC : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *homeSegment;
- (IBAction)onTapSegment:(UISegmentedControl *)sender;
@property (weak, nonatomic) IBOutlet UITableView *hmeTblVw;
- (IBAction)onTapMenuBarBtn:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UILabel *fairTitleLabel;
- (IBAction)onTapBackBarButton:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *collVw;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfTblVw;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfCollVw;

@end
