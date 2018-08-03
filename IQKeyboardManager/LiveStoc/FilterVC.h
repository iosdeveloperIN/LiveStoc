//
//  FilterVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 12/12/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterVC : UIViewController
- (IBAction)onTapClose:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UISlider *sliderForDistance;
- (IBAction)onDragSlider:(UISlider *)sender;
- (IBAction)onTapSlider:(UITapGestureRecognizer *)sender;
- (IBAction)didEndDraggingSlider:(UISlider *)sender;
@property (weak, nonatomic)  NSMutableDictionary *filterDetails;
@property (weak, nonatomic) IBOutlet UIImageView *animalImgVw;
@property (weak, nonatomic) IBOutlet UILabel *nameOfAnimal;
@property (weak, nonatomic) IBOutlet UILabel *listingSliderLbl;
@property(weak,nonatomic) IBOutlet UILabel *twoLabel;
@property(weak,nonatomic) IBOutlet UILabel *tenLbl;
@property(weak,nonatomic) IBOutlet UILabel *fiftyLabel;
@property(weak,nonatomic) IBOutlet UILabel *twoHundredLbl;
@property(weak,nonatomic) IBOutlet UILabel *fiveHundredLabel;
@property(weak,nonatomic) IBOutlet UILabel *thousandLabel;
@property(weak,nonatomic) IBOutlet UILabel *threeThousandLbl;
@property(weak,nonatomic) IBOutlet UILabel *setPriceRangeLabl;
@property(weak,nonatomic) IBOutlet UILabel *priceLabel;
@property(weak,nonatomic) IBOutlet UILabel *minAttriblabel;
@property(weak,nonatomic) IBOutlet UILabel *maxAttribLabel;
@property(weak,nonatomic) IBOutlet UILabel *selectBreedLabel;
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;
- (IBAction)onTapApplyBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *minTF;
@property (weak, nonatomic) IBOutlet UITextField *maxTF;
@property (weak, nonatomic) IBOutlet UITableView *detailsTblVw;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfTableVw;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UILabel *yieldLabel;
@property (weak, nonatomic) IBOutlet UITextField *minTieldTF;
@property (weak, nonatomic) IBOutlet UITextField *maxYieldTF;
@property (weak, nonatomic) IBOutlet UIView *yieldVw;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintOfYieldVw;

@end
