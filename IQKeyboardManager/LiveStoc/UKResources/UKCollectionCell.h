//
//  UKCollectionCell.h
//  LiveStoc
//
//  Created by Harjit Singh on 11/21/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"
#import "UKButton.h"
#import "UKView.h"
@interface UKCollectionCell : UICollectionViewCell
//Splash Screen
@property (strong, nonatomic) IBOutlet UIImageView *imgVwOfSplashScreenVC;
@property (strong, nonatomic) IBOutlet UILabel *detailLblOfSplashScreenVC;

//Search Screen
@property (weak, nonatomic) IBOutlet UIImageView *animalImgVwOFSearchVC;
@property (weak, nonatomic) IBOutlet UILabel *nameOfAnimalOfSearchVC;
@property (weak, nonatomic) IBOutlet UIImageView *postedImgVwOfSearchVC;
@property (weak, nonatomic) IBOutlet UILabel *postDateLblOfSearchVC;
@property (weak, nonatomic) IBOutlet UILabel *nameOfPostedAnimalOfSearchVC;
@property (weak, nonatomic) IBOutlet UILabel *addressOfPostOfSearchVC;
@property (weak, nonatomic) IBOutlet UILabel *costOfPostOfSearchVC;
@property (weak, nonatomic) IBOutlet UILabel *ageAttribOfSearchVC;
@property (weak, nonatomic) IBOutlet UILabel *lactationAttribOfSearchVC;
@property (weak, nonatomic) IBOutlet UILabel *yeildAttribOfSearchVC;
@property (weak, nonatomic) IBOutlet UILabel *ageOfAnimalOfSearchVC;
@property (weak, nonatomic) IBOutlet UILabel *lactationOfAnimalOfSearchVC;
@property (weak, nonatomic) IBOutlet UILabel *yieldOfAnimalOfSearchVC;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingVwOfSearchVC;
@property (weak, nonatomic) IBOutlet UIImageView *certifiedImgOfSearchVC;
@property (weak, nonatomic) IBOutlet UKButton *removeFilterBtnOfSearchVC;



//Post Details VC
@property (weak, nonatomic) IBOutlet UIImageView *largeAnimalImgVwOfPostDetailsVC;
@property (weak, nonatomic) IBOutlet UIImageView *smallAnimalImgVwOfPostDetailsVC;
@property (weak, nonatomic) IBOutlet UIImageView *largeAnimalImgVwOfImagesVC;
@property (weak, nonatomic) IBOutlet UIImageView *smallAnimalImgVwOfImagesVC;

//All Sales VC
@property (weak, nonatomic) IBOutlet UIImageView *animalImgVwOfAllSalesVC;
@property (weak, nonatomic) IBOutlet UILabel *dateLabelOfAllSalesVC;
@property (weak, nonatomic) IBOutlet UILabel *nameLabelOfAllSalesVC;
@property (weak, nonatomic) IBOutlet UILabel *addressLabelOfAllSalesVC;
@property (weak, nonatomic) IBOutlet UILabel *priceLabelOfAllSalesVC;
@property (weak, nonatomic) IBOutlet UILabel *statusLabelOfAllSalesVC;
@property (weak, nonatomic) IBOutlet UILabel *certificationabelOfAllSalesVC;
@property (weak, nonatomic) IBOutlet UIImageView *certiLogoOfAllSalesVC;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingOfAllSalesVC;

//MemberShip VC
@property (weak, nonatomic) IBOutlet UIImageView *animalImgVwOfMemberVC;
@property (weak, nonatomic) IBOutlet UILabel *countLblOfMemberVC;
@property (weak, nonatomic) IBOutlet UILabel *animalsLblOfMemberVC;
@property (weak, nonatomic) IBOutlet UILabel *accessLblOfMemberVC;
@property (weak, nonatomic) IBOutlet UILabel *priceLblOfMemberVC;
@property (weak, nonatomic) IBOutlet UIButton *buyNowBtnOfMemberVC;

//toEnterLocation

//Select Category VC
@property (weak, nonatomic) IBOutlet UIImageView *animalImgVwOfSelectCategoryVC;
@property (weak, nonatomic) IBOutlet UILabel *animalNameOfSelectCategoryVC;

//Almost Donr VC
@property (weak, nonatomic) IBOutlet UIImageView *selectedImgVwOFAlmostDoneVC;
@property (weak, nonatomic) IBOutlet UIButton *removeImgBtnOfAlmostDoneVC;

//ShopVC
@property (weak, nonatomic) IBOutlet UIImageView *imgVwOfShopVC;
@property (weak, nonatomic) IBOutlet UILabel *titleNameOfShopVC;
@property (weak, nonatomic) IBOutlet UILabel *costLabelOfShopVC;
@property (weak, nonatomic) IBOutlet UILabel *priceAttribOfShopVC;
@property (weak, nonatomic) IBOutlet UILabel *descriptionAttribOfShopVC;
@property (weak, nonatomic) IBOutlet UILabel *quantityAttribOfShopVC;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabelOfShopVC;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabelOfShopVC;



//LanguageVC
@property (weak, nonatomic) IBOutlet UILabel *langLbl;
@property (weak, nonatomic) IBOutlet UKView *redColorVw;




//HomeVC
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;


@end
