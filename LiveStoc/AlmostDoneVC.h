//
//  AlmostDoneVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 12/9/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlmostDoneVC : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *photosCollVw;
@property (weak, nonatomic) IBOutlet UIImageView *animalFeaturesImgVw;
@property (weak, nonatomic) IBOutlet UIImageView *uploadPhotosImgVw;
@property (weak, nonatomic) IBOutlet UIImageView *priceImgVw;
@property (weak, nonatomic) IBOutlet UIScrollView *animalDetailsScrollVw;
@property (weak, nonatomic) IBOutlet UKView *uploadPhotosVw;
@property (weak, nonatomic) IBOutlet UKView *priceVw;
@property (weak, nonatomic) IBOutlet UIButton *animalFeaturesBtn;
@property (weak, nonatomic) IBOutlet UIButton *upLoadPhotosBtn;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
- (IBAction)onTapNextOfFeaturesSec:(UIButton *)sender;
- (IBAction)onTapPreviousOfUploadPhotoSec:(UIButton *)sender;
- (IBAction)onTapNextOfUploadPhotoSec:(UIButton *)sender;
- (IBAction)onTapNextOfPriceSec:(UIButton *)sender;
- (IBAction)onTapPreviousOfPriceSec:(UIButton *)sender;
- (IBAction)onTapBackButton:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UKTextField *nameOfAnimalTF;
@property (weak, nonatomic) IBOutlet KPDropMenu *breedDropDwn;
@property (weak, nonatomic) IBOutlet UKTextField *breedNameTF;
@property (weak, nonatomic) IBOutlet KPDropMenu *yearsAgeDrpDwn;
@property (weak, nonatomic) IBOutlet KPDropMenu *monthsAgeDrpDwn;
@property (weak, nonatomic) IBOutlet KPDropMenu *genderDrpDwn;
@property (weak, nonatomic) IBOutlet UIView *yeildVw;
@property (weak, nonatomic) IBOutlet UITextField *minYieldTF;
@property (weak, nonatomic) IBOutlet UITextField *maxYieldTF;
@property (weak, nonatomic) IBOutlet KPDropMenu *lactationDropDwn;
@property (weak, nonatomic) IBOutlet KPDropMenu *isPregnantDrpDwn;
@property (weak, nonatomic) IBOutlet UKTextField *mothersNameTF;
@property (weak, nonatomic) IBOutlet UKTextField *fathersNameTF;
@property (weak, nonatomic) IBOutlet UKTextField *heightTF;
@property (weak, nonatomic) IBOutlet UKTextField *weightTF;
@property (weak, nonatomic) IBOutlet UKTextView *descriptionTextVw;
@property (weak, nonatomic) IBOutlet UIButton *nextLabelOfAnimalDetails;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintOfYearsDropDwn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintOfMotherNameTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintOfPregnantDropDwn;
@property (weak, nonatomic) IBOutlet KPDropMenu *pregnantMonthsDropDwn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintOfBreedNameTF;
@property (weak, nonatomic) IBOutlet UILabel *addPhotosLabel;
- (IBAction)onTapAddButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *previousBtnOfUploadPhotosVw;
@property (weak, nonatomic) IBOutlet UIButton *nextBtnOfUploadPhotosVC;
- (IBAction)onTapRemoveSelectedImg:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *enterPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyCodeLabel;
@property (weak, nonatomic) IBOutlet UKTextField *priceTF;
@property (weak, nonatomic) IBOutlet UIButton *previousBtnOfPrice;
@property (weak, nonatomic) IBOutlet UIButton *nextBtnOfPriceVw;
@property(strong,nonatomic) NSString *currencySymb;
@property (weak, nonatomic) IBOutlet UILabel *litresLbl;


@end
















@interface FinalPostVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *interestedCertificationLabel;
@property (weak, nonatomic) IBOutlet UKButton *yesBtn;
@property (weak, nonatomic) IBOutlet UKButton *noBtn;
@property (weak, nonatomic) IBOutlet UKButton *mayBeBtn;
- (IBAction)onTapPostBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *postBtn;
- (IBAction)onTapCertificationStatusBtn:(UKButton *)sender;

@end




@interface PopUpPostFinal : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *congratesLabel;
@property (weak, nonatomic) IBOutlet UILabel *congratesDetailsLabel;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
- (IBAction)onTapOkButton:(UIButton *)sender;

//presentFinalPop
@end


