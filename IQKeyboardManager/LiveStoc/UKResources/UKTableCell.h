//
//  UKTableCell.h
//  LiveStoc
//
//  Created by Harjit Singh on 11/23/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UKImageView.h"
@interface UKTableCell : UITableViewCell

//Home VC
@property (weak, nonatomic) IBOutlet UILabel *titleLblOfHmeVC;
@property (weak, nonatomic) IBOutlet UILabel *infoLblOfHmeVC;
@property (weak, nonatomic) IBOutlet UIImageView *imgVwOfHmeVC;
@property (weak, nonatomic) IBOutlet UKView *viewOfHmeVC;
//Enter Location VC
@property (weak, nonatomic) IBOutlet UKTextField *locationTF;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

//Post Details VC
@property (weak, nonatomic) IBOutlet UILabel *attribNameOfPostDetailsVC;
@property (weak, nonatomic) IBOutlet UILabel *typeNameOfPostDetailsVC;
@property (weak, nonatomic) IBOutlet UILabel *typeLabelOfFilterVC;
@property (weak, nonatomic) IBOutlet UIImageView *checkedImgVwOfFilterVC;

//Location Search VC

@property (weak, nonatomic) IBOutlet UILabel *nameLabelOfSearchVC;

//Country Search VC
@property (weak, nonatomic) IBOutlet UILabel *countryNameLabelOfCountrySearchVC;

// Menu VC
@property (weak, nonatomic) IBOutlet UILabel *menuNameLabel;

//My Profile VC
@property (weak, nonatomic) IBOutlet UILabel *attribLabelOfMyProfileVC;
@property (weak, nonatomic) IBOutlet UILabel *nameLabelOfMyProfileVC;
@property (weak, nonatomic) IBOutlet UILabel *nameFbLabelOfMyProfileVC;


// ArticlesVC
@property (weak, nonatomic) IBOutlet UIImageView *articleImgOfArticlesVC;
@property (weak, nonatomic) IBOutlet UILabel *nameLblOfArticlesVC;
@property (weak, nonatomic) IBOutlet UILabel *titleLblOfArticlesVC;
@property (weak, nonatomic) IBOutlet UILabel *infoLblOfArticlesVC;
@property (weak, nonatomic) IBOutlet UILabel *readMoreLblOfArticlesVC;
@property (weak, nonatomic) IBOutlet UILabel *popUpVwNameLblOfArticlesVC;






//AdvisoryVC
@property (weak, nonatomic) IBOutlet UKImageView *iconImgVwOfAdvisoryVC;
@property (weak, nonatomic) IBOutlet UILabel *questionLblOfAdvisoryVC;
@property (weak, nonatomic) IBOutlet UILabel *nameLblOfAdvisoryVC;
@property (weak, nonatomic) IBOutlet UILabel *commentsCountsOfAdvisoryVC;
@property (weak, nonatomic) IBOutlet UILabel *dateLblOfAdvisoryVC;
@property (weak, nonatomic) IBOutlet UIImageView *mainImgVwOfAdvisoryVC;




//AdvisoryDetailsVC
@property (weak, nonatomic) IBOutlet UKImageView *commentsIconImgVwOfAdvisoryDetailsVC;
@property (weak, nonatomic) IBOutlet UILabel *nameLabelOfAdvisoryDetailsVC;
@property (weak, nonatomic) IBOutlet UILabel *commenDetailOfAdvisoryDetailsVC;
@property (weak, nonatomic) IBOutlet UILabel *dateOfAdvisoryDetailsVC;



@property (weak, nonatomic) IBOutlet UKImageView *iconImageVwOfAdvisoryDetailsVC;
@property (weak, nonatomic) IBOutlet UIImageView *fullImageVwOfAdvisoryDetailsVC;
@property (weak, nonatomic) IBOutlet UILabel *questionLabelOfAdvisoryDetailsVC;
@property (weak, nonatomic) IBOutlet UILabel *nameForDetailsLabelOfAdvisoryDetailsVC;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabelOfAdvisoryDetailsVC;
@property (weak, nonatomic) IBOutlet UILabel *dateForDetailsOfAdvisoryDetailsVC;



//CartVC
@property (weak, nonatomic) IBOutlet UIImageView *productImageVwOfCartVC;
@property (weak, nonatomic) IBOutlet UIButton *removeBtnOfCartVC;
@property (weak, nonatomic) IBOutlet UILabel *productTitleOfCartVC;
@property (weak, nonatomic) IBOutlet UILabel *priceAttribOfCartVC;
@property (weak, nonatomic) IBOutlet UILabel *priceLblOfCartVC;
@property (weak, nonatomic) IBOutlet UILabel *descripAttribOfCartVC;
@property (weak, nonatomic) IBOutlet UILabel *descripLblOfCartVC;
@property (weak, nonatomic) IBOutlet UILabel *quantityAttribOfCartVC;
@property (weak, nonatomic) IBOutlet UILabel *quantityLblOfCartVC;
@property (weak, nonatomic) IBOutlet UILabel *totalAttribOfCartVC;
@property (weak, nonatomic) IBOutlet UILabel *totalLblOfCartVC;
@property (weak, nonatomic) IBOutlet UILabel *itemQuantityLblOfCartVC;
@property (weak, nonatomic) IBOutlet UIButton *minusBtnOfCartVC;
@property (weak, nonatomic) IBOutlet UIButton *plusBtnOfCartVC;


//ShopVC Filter Cell
@property (weak, nonatomic) IBOutlet UIButton *sectionBtn;
@property (weak, nonatomic) IBOutlet UILabel *subCategoryLabelOfFilterTable;




//OrdersVC

@property (weak, nonatomic) IBOutlet UILabel *orderNumAttribOfOrdersVC;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusAttribOfOrdersVC;
@property (weak, nonatomic) IBOutlet UILabel *paymentStatusAttribOfOrdersVC;
@property (weak, nonatomic) IBOutlet UILabel *orderTotalAttribOfOrdersVC;
@property (weak, nonatomic) IBOutlet UILabel *orderDateAttribOfOrdersVC;
@property (weak, nonatomic) IBOutlet UILabel *deliveryDateAttribOfOrdersVC;


@property (weak, nonatomic) IBOutlet UILabel *orderNumOfOrdersVC;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusOfOrdersVC;
@property (weak, nonatomic) IBOutlet UILabel *paymentStatusOfOrdersVC;
@property (weak, nonatomic) IBOutlet UILabel *orderTotalOfOrdersVC;
@property (weak, nonatomic) IBOutlet UILabel *orderDateOfOrdersVC;
@property (weak, nonatomic) IBOutlet UILabel *deliveryDateOfOrdersVC;

//OrderDetailsVC
@property (weak, nonatomic) IBOutlet UILabel *attribLabelOfOrderDetailsVC;
@property (weak, nonatomic) IBOutlet UILabel *valueLabelOfOrderDetailsVC;




// LanguageVC
@property (weak, nonatomic) IBOutlet UKView *indBackVw;
@property (weak, nonatomic) IBOutlet UILabel *indLbl;
@property (weak, nonatomic) IBOutlet UILabel *worldLbl;
@property (weak, nonatomic) IBOutlet UKView *worldVw;




@end
