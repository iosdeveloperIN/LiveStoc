//
//  SearchVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 11/24/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchVC : UIViewController
- (IBAction)onTapBackBarBtn:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *animalsCollVw;
@property (weak, nonatomic) IBOutlet UICollectionView *feedsCollVw;
- (IBAction)onTaplayoutType:(UIButton *)sender;
- (IBAction)onTapMyLocation:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *myLocationBtn;
- (IBAction)onTapSearchBtn:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchBarBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cartBarBtn;
- (IBAction)onTapCartBarBtn:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet KPDropMenu *typesDropDown;
@property (weak, nonatomic) IBOutlet UILabel *rangeLabel;
@property (weak, nonatomic) IBOutlet UIButton *layOutBtn;
- (IBAction)onTapRemoveFilter:(UKButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *noDataFoundLbl;
- (IBAction)onTapChangingRange:(UITapGestureRecognizer *)sender;


@property (weak, nonatomic) IBOutlet UISlider *sliderForDistance;
- (IBAction)onDragSlider:(UISlider *)sender;
- (IBAction)onTapSlider:(UITapGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UILabel *listingSliderLbl;
@property(weak,nonatomic) IBOutlet UILabel *twoLabel;
@property(weak,nonatomic) IBOutlet UILabel *tenLbl;
@property(weak,nonatomic) IBOutlet UILabel *fiftyLabel;
@property(weak,nonatomic) IBOutlet UILabel *twoHundredLbl;
@property(weak,nonatomic) IBOutlet UILabel *fiveHundredLabel;
@property(weak,nonatomic) IBOutlet UILabel *thousandLabel;
@property(weak,nonatomic) IBOutlet UILabel *threeThousandLbl;
- (IBAction)onTapCancelRangeSelection:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtnOfRangeSelection;
- (IBAction)onTapOKAYOfRangeSelection:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *okayBtnOfRangeSelection;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerYofRangeSelectionVw;
@property (weak, nonatomic) IBOutlet UIView *rangeView;

@property (weak, nonatomic) IBOutlet UIButton *backGroundBtn;
- (IBAction)onTapBackground:(UIButton *)sender;
- (IBAction)onTapRangeBtn:(UIButton *)sender;



@end


@interface NavVC :UINavigationController
@property (weak, nonatomic) IBOutlet UITabBarItem *searchTabBar;



@end




