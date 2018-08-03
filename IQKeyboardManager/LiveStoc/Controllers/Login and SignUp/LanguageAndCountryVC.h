//
//  LanguageAndCountryVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 12/20/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LanguageAndCountryVC : UIViewController
@property (weak, nonatomic) IBOutlet UKButton *englishBtn;
@property (weak, nonatomic) IBOutlet UKButton *hindiBTn;
@property (weak, nonatomic) IBOutlet UKButton *punjabiBtn;
- (IBAction)onTapLanguageBtn:(UKButton *)sender;
@property (weak, nonatomic) IBOutlet UKButton *okBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseLangaugeBtn;
@property (nonatomic)  BOOL isFromOther;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgVw;
@property (weak, nonatomic) IBOutlet UICollectionView *langColVw;
@property (weak, nonatomic) IBOutlet UITableView *indTblVw;
@property (weak, nonatomic) IBOutlet UITableView *worldTblVw;





@end

@interface CountryPopVC : UIViewController
@property (weak, nonatomic) IBOutlet UKTextField *searchTF;
- (IBAction)searchTextDidChange:(UKTextField *)sender;
@property (weak, nonatomic) IBOutlet UITableView *searchTableVw;
@property (weak, nonatomic) IBOutlet UKButton *selectCountryBtn;


@end
