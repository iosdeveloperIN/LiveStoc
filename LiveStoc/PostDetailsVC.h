//
//  PostDetailsVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 12/13/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostDetailsVC : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *imagesCollVw;
@property (weak, nonatomic) IBOutlet UITableView *detailsTblVw;
@property (weak, nonatomic) IBOutlet UICollectionView *largeCollVw;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfDetailsTblVw;
@property (weak, nonatomic) IBOutlet UILabel *certifiedAttribLbl;
@property (weak, nonatomic) IBOutlet UILabel *certifiedLbl;
@property (weak, nonatomic) IBOutlet UILabel *remarkAttribLbl;
@property (weak, nonatomic) IBOutlet UILabel *remarkNameLbl;
@property (weak, nonatomic) IBOutlet UIButton *contactSellerBtn;
- (IBAction)onTapContactSeller:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingVw;
@property (weak, nonatomic)  NSMutableDictionary  *postDetails;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewBack;
@property (weak, nonatomic) IBOutlet UILabel *certificationStatusAttrib;
@property (weak, nonatomic) IBOutlet UILabel *cartificationStatusNameLbl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *favBarBtn;
- (IBAction)onTapFavBArBtn:(UIBarButtonItem *)sender;
@property (nonatomic)  BOOL isFromSearch;
@property (nonatomic)  BOOL isFromFavourites;
@property (nonatomic)  BOOL isFromAllSale;
- (IBAction)onTapToGetCertificationIfActivated:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *activatedCertificationBtn;
- (IBAction)onTapSoldOutBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *soldOutBtn;
- (IBAction)onTapCertificationIfNotActivated:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *inactiveCertificationBtn;
- (IBAction)onTapMapBarBtn:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIView *certifiedView;
@property (weak, nonatomic) IBOutlet UKButton *certifiedBtn;
@property (weak, nonatomic) IBOutlet UITableView *certifiedTblVw;

@end
