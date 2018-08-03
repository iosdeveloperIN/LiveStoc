//
//  ProductDetailsVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 1/24/18.
//  Copyright © 2018 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailsVC : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *imagesCollVw;
@property (weak, nonatomic) IBOutlet UICollectionView *largeCollVw;
@property (weak, nonatomic) IBOutlet UILabel *tittleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
- (IBAction)onTapMinusBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *quantityLbl;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
- (IBAction)onTapPlus:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UKButton *addToCartBtn;
- (IBAction)onTapAddToCart:(UKButton *)sender;
@property (weak, nonatomic) IBOutlet UKView *increaseView;
@property (weak, nonatomic)  NSMutableDictionary  *postDetails;


@end
