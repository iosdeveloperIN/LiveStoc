//
//  ShopVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 11/24/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopVC : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *shopCollVw;
@property (weak, nonatomic) IBOutlet UITableView *filterTblVw;
- (IBAction)onTapSectionOfFilter:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *noItemsLabel;
@property (weak, nonatomic) IBOutlet UIButton *filterBtn;
- (IBAction)onTapFilterBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
- (IBAction)changeTextOfSearchTF:(UITextField *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *searchIcon;
@property (weak, nonatomic) IBOutlet UIButton *gridBtn;
- (IBAction)ontapGridLayout:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UKButton *clearFilterBtn;
- (IBAction)onTapClearFilterBtn:(UKButton *)sender;
@property (weak, nonatomic) IBOutlet UKButton *priceFilter;
- (IBAction)onTapPriceFilter:(UKButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *backGroundBtn;
- (IBAction)onTapBackground:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *filterView;
@property (weak, nonatomic) IBOutlet UIView *pricePopUpVw;
- (IBAction)onTapPriceSelectionBtn:(UKButton *)sender;
@property (weak, nonatomic) IBOutlet UKTextField *minTF;
@property (weak, nonatomic) IBOutlet UKTextField *maxTF;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cartBarBtn;
- (IBAction)onTapCartBarBtn:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UILabel *orLbl;



@end
