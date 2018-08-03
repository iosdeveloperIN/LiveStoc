//
//  SearchVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 11/24/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import "HomeVC.h"
#import "SearchVC.h"
#import "ShopVC.h"
#import "MyListingVC.h"
#import "MoreVC.h"
#import "FilterVC.h"
#import "PostDetailsVC.h"
#import "CartVC.h"
#import "NSString+HTML.h"

@interface SearchVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SearchDelegate,KPDropMenuDelegate,LocationDelegate>
{
    BOOL isGridLayOut;
    UKNetworkManager *postsParams;
    UKLocationManager *location;
    NSMutableArray *animalCategories;
    NSMutableArray *allPosts,*barBtns;
    NSDictionary *dropDict;
    UKModel *model;
    UIRefreshControl *refreshControl;
    JSBadgeView *badgeView;
}
@property(strong,nonatomic) UIButton *customButton;

@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    model=[UKModel model];
    location=[[UKLocationManager alloc] init];
    location.delegate=self;
//    [location startLocationTracking];
    
    isGridLayOut=YES;
    
    self.animalsCollVw.delegate=self;
    self.animalsCollVw.dataSource=self;
    
    model.pageCount=1;
    model.sortBy=All;
    model.pagination=No;

    [self getAllCategories];
    [[UKModel model] setDelegate:self];
    [[UKModel model] getPosts];

    [_layOutBtn setBackgroundImage:[UIImage imageNamed:@"grid"] forState:UIControlStateNormal];
    _noDataFoundLbl.text=AMLocalizedString(@"no_listing", @"no_listing");
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(refershControlAction) forControlEvents:UIControlEventValueChanged];
    [self.feedsCollVw addSubview:refreshControl];
    
//    self.collectionView.alwaysBounceVertical = YES;
    
    _typesDropDown.items=model.sortingArray;
    _typesDropDown.title=AMLocalizedString(model.sortingArray[0], model.sortingArray[0]);
    _typesDropDown.delegate=self;
    _listingSliderLbl.text=[NSString stringWithFormat:@"%@ %d kms",AMLocalizedString(@"listing_within", @"listing_within"),2];
    _rangeView.hidden=YES;
    _backGroundBtn.hidden=YES;
    
    [_cancelBtnOfRangeSelection setTitle:AMLocalizedString(@"cancel", @"cancel") forState:UIControlStateNormal];
    [_okayBtnOfRangeSelection setTitle:AMLocalizedString(@"ok", @"ok") forState:UIControlStateNormal];

}
-(void)accurateFinalLocation:(CLLocationCoordinate2D)finalLocation
{
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"LocationSelected"]) {
        
        [[UKModel model] getPosts];

    } else {
        
        
    }
    
    
    NSNumber *lat = [NSNumber numberWithDouble:finalLocation.latitude];
    NSNumber *lon = [NSNumber numberWithDouble:finalLocation.longitude];
    NSDictionary *userLocation=@{@"lat":lat,@"long":lon};
    
    [[NSUserDefaults standardUserDefaults] setObject:userLocation forKey:@"userLocation"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LocationSelected"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    location.delegate=nil;
    [location stopLocation];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title=AMLocalizedString(@"tab1", @"tab1");
    [self.tabBarItem setTitle:AMLocalizedString(@"tab1", @"tab1")];
    
    [[self.tabBarController.tabBar.items objectAtIndex:1] setTitle:AMLocalizedString(@"tab2", @"tab2")];
    [[self.tabBarController.tabBar.items objectAtIndex:2] setTitle:AMLocalizedString(@"tab3", @"tab3")];
    [[self.tabBarController.tabBar.items objectAtIndex:3] setTitle:AMLocalizedString(@"tab4", @"tab4")];
    
    barBtns=[[NSMutableArray alloc] init];

    UIButton *search = [UIButton buttonWithType:UIButtonTypeCustom];
    [search setImage:[UIImage imageNamed:@"search_barBtn"] forState:UIControlStateNormal];
    [search sizeToFit];
    search.frame = CGRectMake(0.0, 0.0, 20, 20);
    [search addTarget:self action:@selector(onTapSearchBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* searchBarBtn = [[UIBarButtonItem alloc] initWithCustomView:search];

    
    _customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_customButton setImage:[UIImage imageNamed:@"cart"] forState:UIControlStateNormal];
    [_customButton sizeToFit];
    _customButton.frame = CGRectMake(0.0, 0.0, 20, 20);
    [_customButton addTarget:self action:@selector(onTapCartBarBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* customBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_customButton];
    
    barBtns=@[customBarButtonItem,searchBarBtn].mutableCopy;
    
    self.navigationItem.rightBarButtonItems = barBtns;
    badgeView = [[JSBadgeView alloc] initWithParentView:_customButton alignment:JSBadgeViewAlignmentTopRight];
    badgeView.badgeBackgroundColor=[UIColor redColor];
    badgeView.badgeText = [NSString stringWithFormat:@"%li",(long)[[UKModel model] cartCount]];
    
    
    
    
    
//    self.navigationItem.rightBarButtonItem.badgeValue=[NSString stringWithFormat:@"%ld",(long)[[UKModel model] cartCount]];
//    self.navigationItem.rightBarButtonItem.shouldHideBadgeAtZero=YES;
//    self.navigationItem.rightBarButtonItem.shouldAnimateBadge=YES;
}
-(void)refershControlAction
{
    [refreshControl endRefreshing];
    model.pageCount=1;
    model.pagination=No;
    model.sortBy=All;
    _typesDropDown.items=model.sortingArray;
    _typesDropDown.title=AMLocalizedString(model.sortingArray[0], model.sortingArray[0]);
    _typesDropDown.delegate=self;
    [self getPostFromFields:model.pageCount];
}
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _rangeLabel.layer.borderWidth=1;
    _rangeLabel.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _rangeLabel.layer.cornerRadius=_rangeLabel.frame.size.height/2;
    _rangeLabel.clipsToBounds=YES;
    
}
- (void)getPostFromFields:(NSInteger)page
{
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc] init];
    
    if (model.animalSelection==Selected) {
        [_animalsCollVw reloadData];
        for (NSString *key in [model.animalSelectionDict allKeys]) {
            [paramDict setValue:[model.animalSelectionDict valueForKey:key] forKey:key];
        }
    }
    
    NSDictionary *userLoc=[[NSUserDefaults standardUserDefaults] objectForKey:@"userLocation"];
    NSLog(@"lat %@",[userLoc objectForKey:@"lat"]);
    NSLog(@"long %@",[userLoc objectForKey:@"long"]);
    
    switch (model.sortBy) {
        case NotCertified:
            [paramDict setValue:@"0" forKey:@"isCertified"];
            break;
        case Certified:
            [paramDict setValue:@"1" forKey:@"isCertified"];
            break;
        case All:
            [paramDict setValue:@"" forKey:@"isCertified"];
            break;
        case Male:
            [paramDict setValue:@"male" forKey:@"gender"];
            break;
        default:
            [paramDict setValue:@"female" forKey:@"gender"];
            break;
    }
    
    [paramDict setValue:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [paramDict setValue:[UKNetworkManager getFromDefaultsWithKeyString:USER_ID] forKey:@"users_id"];
    if ([[model.animalSelectionDict valueForKey:@"radius"] isEqualToString:@""]) {
        
        _rangeLabel.text=[NSString stringWithFormat:@"%@ 3000 kms",AMLocalizedString(@"within", @"within")];
        
        [paramDict setValue:@"" forKey:@"radius"];
        
    } else {
        _rangeLabel.text=[NSString stringWithFormat:@"%@ %@ kms",AMLocalizedString(@"within", @"within"),[model.animalSelectionDict valueForKey:@"radius"]];
        
    }
    [_myLocationBtn setTitle:AMLocalizedString(@"my_loc", @"my_loc") forState:UIControlStateNormal];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"LocationSelected"]) {
        
        [paramDict setValue:[NSString stringWithFormat:@"%@",[userLoc objectForKey:@"lat"]] forKey:@"latitude"];
        [paramDict setValue:[NSString stringWithFormat:@"%@",[userLoc objectForKey:@"long"]] forKey:@"longitude"];
        [[[NSUserDefaults standardUserDefaults] valueForKey:@"ADDRESS"] length]>0 ? [_myLocationBtn setTitle:[[NSUserDefaults standardUserDefaults] valueForKey:@"ADDRESS"] forState:UIControlStateNormal] : @"";
        [self getSellingPostsWith:paramDict];

    } else {
        
        [_myLocationBtn setTitle:AMLocalizedString(@"my_loc", @"my_loc") forState:UIControlStateNormal];
        _noDataFoundLbl.hidden=NO;
        _feedsCollVw.hidden=YES;
        [self showLocationAlert];
        
    }
    
}
-(void)showLocationAlert
{
    UIAlertController *locAlert=[UIAlertController alertControllerWithTitle:AMLocalizedString(@"my_loc", @"my_loc") message:AMLocalizedString(@"pref_loc", @"pref_loc") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok=[UIAlertAction actionWithTitle:AMLocalizedString(@"ok", @"ok") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self performSegueWithIdentifier:@"toSearchLocations" sender:self];
        
    }];
    
    [locAlert addAction:ok];
    
    [self presentViewController:locAlert animated:YES completion:nil];
    
}


- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView.tag==112232) {
        if (model.animalSelection==Selected) {
        return 1;
        } else {
            return animalCategories.count;
        }
    } else{
        
        return allPosts.count;
    }
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (collectionView.tag==112232) {
        UKCollectionCell *animalCell=[self.animalsCollVw dequeueReusableCellWithReuseIdentifier:@"animalsCell" forIndexPath:indexPath];
        if (model.animalSelection==Selected) {

            for (NSDictionary *dict in animalCategories) {
                
                if ([[model.animalSelectionDict valueForKey:@"category_id"] isEqualToString:[dict valueForKey:@"category_id"]]) {
                    
                    [animalCell.animalImgVwOFSearchVC sd_setImageWithURL:[NSURL URLWithString:dict[@"logo"]] placeholderImage:[UIImage imageNamed:@"p"] options:SDWebImageHighPriority];
                    
                    NSString *langStr=@"";
                    NSString *currentLang=[UKNetworkManager getFromDefaultsWithKeyString:@"CURRENT_LANG"];
                    
                    if ([currentLang isEqualToString:@"es"]) {
                        langStr=@"category_spanish";
                        
                    } else if ([currentLang isEqualToString:@"hi-IN"])
                    {
                        langStr=@"category_hindi";
                        
                    }  else if ([currentLang isEqualToString:@"pa-IN"])
                    {
                        langStr=@"category_punjabi";
                        
                    }  else if ([currentLang isEqualToString:@"ur"])
                    {
                        langStr=@"category_urdu";
                        
                    }  else if ([currentLang isEqualToString:@"gu-IN"])
                    {
                        langStr=@"category_gujarati";
                        
                    }  else if ([currentLang isEqualToString:@"ta-IN"])
                    {
                        langStr=@"category_tamil";
                        
                    }  else if ([currentLang isEqualToString:@"mr-IN"])
                    {
                        langStr=@"category_marathi";
                        
                    } else if ([currentLang isEqualToString:@"kn-IN"])
                    {
                        langStr=@"category_kannada";
                        
                    } else if ([currentLang isEqualToString:@"bn-IN"])
                    {
                        langStr=@"category_bengali";
                        
                    }  else if ([currentLang isEqualToString:@"ml-IN"])
                    {
                        langStr=@"category_malayalam";
                        
                    }  else if ([currentLang isEqualToString:@"te-IN"])
                    {
                        langStr=@"category_telugu";
                        
                    }  else if ([currentLang isEqualToString:@"fr"])
                    {
                        langStr=@"category_french";
                        
                    }  else if ([currentLang isEqualToString:@"pt-PT"])
                    {
                        langStr=@"category_portuguese";
                        
                    } else {
                        langStr=@"category";
                        
                    }
                    
                    if ([currentLang isEqualToString:@"en"]) {
                        
                    animalCell.nameOfAnimalOfSearchVC.text=dict[langStr];

                    } else {
                        
                        NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:dict[langStr] options:0];
                        animalCell.nameOfAnimalOfSearchVC.text = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
                    }
                    
                    
                    animalCell.removeFilterBtnOfSearchVC.hidden=NO;

                    break;
                }
            }
            
        } else {
            
            [animalCell.animalImgVwOFSearchVC sd_setImageWithURL:[NSURL URLWithString:animalCategories[indexPath.row][@"logo"]] placeholderImage:[UIImage imageNamed:@"p"] options:SDWebImageHighPriority];
            
            NSString *langStr=@"";
            NSString *currentLang=[UKNetworkManager getFromDefaultsWithKeyString:@"CURRENT_LANG"];
            

            if ([currentLang isEqualToString:@"es"]) {
                langStr=@"category_spanish";
                
            } else if ([currentLang isEqualToString:@"hi-IN"])
            {
                langStr=@"category_hindi";

            }  else if ([currentLang isEqualToString:@"pa-IN"])
            {
                langStr=@"category_punjabi";

            }  else if ([currentLang isEqualToString:@"ur"])
            {
                langStr=@"category_urdu";

            }  else if ([currentLang isEqualToString:@"gu-IN"])
            {
                langStr=@"category_gujarati";

            }  else if ([currentLang isEqualToString:@"ta-IN"])
            {
                langStr=@"category_tamil";

            }  else if ([currentLang isEqualToString:@"mr-IN"])
            {
                langStr=@"category_marathi";

            } else if ([currentLang isEqualToString:@"kn-IN"])
            {
                langStr=@"category_kannada";

            } else if ([currentLang isEqualToString:@"bn-IN"])
            {
                langStr=@"category_bengali";

            }  else if ([currentLang isEqualToString:@"ml-IN"])
            {
                langStr=@"category_malayalam";

            }  else if ([currentLang isEqualToString:@"te-IN"])
            {
                langStr=@"category_telugu";

            }  else if ([currentLang isEqualToString:@"fr"])
            {
                langStr=@"category_french";

            }  else if ([currentLang isEqualToString:@"pt-PT"])
            {
                langStr=@"category_portuguese";

            } else {
                langStr=@"category";

            }
            
            if ([currentLang isEqualToString:@"en"]) {
                
                animalCell.nameOfAnimalOfSearchVC.text=animalCategories[indexPath.row][langStr];
                
            } else {
                
                NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:animalCategories[indexPath.row][langStr] options:0];
                animalCell.nameOfAnimalOfSearchVC.text = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
            }
            
            
            animalCell.removeFilterBtnOfSearchVC.hidden=YES;
        }
        return animalCell;
        
    } else{
        if (isGridLayOut) {
            
            UKCollectionCell *doubleCell=[self.feedsCollVw dequeueReusableCellWithReuseIdentifier:@"doubleItemCell" forIndexPath:indexPath];

            [doubleCell.postedImgVwOfSearchVC sd_setImageWithURL:[NSURL URLWithString:allPosts[indexPath.row][@"images"][0][@"images"]] placeholderImage:[UIImage imageNamed:@"p"] options:SDWebImageHighPriority];
            doubleCell.postDateLblOfSearchVC.text=[NSString stringWithFormat:@"%@",[[allPosts[indexPath.row][@"created"] componentsSeparatedByString:@" "]objectAtIndex:0]];
            doubleCell.nameOfPostedAnimalOfSearchVC.text=[NSString stringWithFormat:@"%@",allPosts[indexPath.row][@"title"]];
            doubleCell.addressOfPostOfSearchVC.text=[NSString stringWithFormat:@"%@",allPosts[indexPath.row][@"formatted_address"]];
            doubleCell.costOfPostOfSearchVC.text=[NSString stringWithFormat:@" %@ %@ ",[NSString base64String:allPosts[indexPath.row][@"cur_symbol"]],allPosts[indexPath.row][@"price"]];
            doubleCell.ageAttribOfSearchVC.text=AMLocalizedString(@"age", @"age");
            doubleCell.lactationAttribOfSearchVC.text=AMLocalizedString(@"lactation", @"lactation");
            doubleCell.yeildAttribOfSearchVC.text=AMLocalizedString(@"yield", @"yield");
            doubleCell.ageOfAnimalOfSearchVC.text=[NSString stringWithFormat:@"%@",allPosts[indexPath.row][@"age"]];
            doubleCell.lactationOfAnimalOfSearchVC.text=[NSString stringWithFormat:@"%@",allPosts[indexPath.row][@"lactation"]];
            doubleCell.yieldOfAnimalOfSearchVC.text=[NSString stringWithFormat:@"%@",allPosts[indexPath.row][@"yield_max"]];

            
            if ([allPosts[indexPath.row][@"isCertified"] integerValue]==1) {
                doubleCell.ratingVwOfSearchVC.hidden=NO;
                doubleCell.ratingVwOfSearchVC.value=5.0;
                doubleCell.certifiedImgOfSearchVC.hidden=NO;
                
            } else {
                doubleCell.ratingVwOfSearchVC.hidden=YES;
                doubleCell.certifiedImgOfSearchVC.hidden=YES;
                
            }
            
//            doubleCell.ratingVwOfSearchVC.enabled=NO;
            
            return doubleCell;
        } else {
            
            UKCollectionCell *singleCell=[self.feedsCollVw dequeueReusableCellWithReuseIdentifier:@"singleItemCell" forIndexPath:indexPath];

            [singleCell.postedImgVwOfSearchVC sd_setImageWithURL:[NSURL URLWithString:allPosts[indexPath.row][@"images"][0][@"images"]] placeholderImage:[UIImage imageNamed:@"p"] options:SDWebImageHighPriority];
            singleCell.postDateLblOfSearchVC.text=[NSString stringWithFormat:@"%@",[[allPosts[indexPath.row][@"created"] componentsSeparatedByString:@" "]objectAtIndex:0]];
            singleCell.nameOfPostedAnimalOfSearchVC.text=[NSString stringWithFormat:@"%@",allPosts[indexPath.row][@"title"]];
            singleCell.addressOfPostOfSearchVC.text=[NSString stringWithFormat:@"%@",allPosts[indexPath.row][@"formatted_address"]];
            singleCell.costOfPostOfSearchVC.text=[NSString stringWithFormat:@"  %@ %@  ",[NSString base64String:allPosts[indexPath.row][@"cur_symbol"]],allPosts[indexPath.row][@"price"]];
            singleCell.ageAttribOfSearchVC.text=AMLocalizedString(@"age", @"age");
            singleCell.lactationAttribOfSearchVC.text=AMLocalizedString(@"lactation", @"lactation");
            singleCell.yeildAttribOfSearchVC.text=AMLocalizedString(@"yield", @"yield");
            singleCell.ageOfAnimalOfSearchVC.text=[NSString stringWithFormat:@"%@",allPosts[indexPath.row][@"age"]];
            singleCell.lactationOfAnimalOfSearchVC.text=[NSString stringWithFormat:@"%@",allPosts[indexPath.row][@"lactation"]];
            singleCell.yieldOfAnimalOfSearchVC.text=[NSString stringWithFormat:@"%@",allPosts[indexPath.row][@"yield_max"]];
            
            if ([allPosts[indexPath.row][@"isCertified"] integerValue]==1) {
                singleCell.ratingVwOfSearchVC.hidden=NO;
                singleCell.ratingVwOfSearchVC.value=5.0;
                singleCell.certifiedImgOfSearchVC.hidden=NO;
                
            } else {
                singleCell.ratingVwOfSearchVC.hidden=YES;
                singleCell.certifiedImgOfSearchVC.hidden=YES;
                
            }
            
//            singleCell.ratingVwOfSearchVC.enabled=NO;
            return singleCell;
            
        }
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag==112232) {
        
        return CGSizeMake(self.animalsCollVw.frame.size.height,self.animalsCollVw.frame.size.height);
        
    } else{
        if (isGridLayOut) {
            return CGSizeMake(self.feedsCollVw.frame.size.width/2, (self.feedsCollVw.frame.size.width/2)+40);
        } else {
            return CGSizeMake(self.feedsCollVw.frame.size.width, self.feedsCollVw.frame.size.width*0.6);
        }
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag==112232) {
        
    [self performSegueWithIdentifier:@"toFilter" sender:self];
        
    } else {
        
        [self performSegueWithIdentifier:@"toPostDetails" sender:self];

    }
}
-(void)getAllCategories
{
    [UKNetworkManager operationType:POST fromPath:@"category/?" withParameters:@{@"limit":@"1000",@"page":@"1"}.mutableCopy withUploadData:nil :^(id result) {
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            
            animalCategories=[[NSMutableArray alloc] init];
            animalCategories=[[result valueForKey:@"data"] valueForKey:@"category"];
            
            _animalsCollVw.delegate=self;
            _animalsCollVw.dataSource=self;
            [_animalsCollVw reloadData];
            
        } else {
            
        }
        
    } :^(NSError *error, NSString *errorMessage) {
        
    }];
}

-(void)getSellingPostsWith:(NSMutableDictionary *)params
{
    if (model.pagination==No) {
        [DejalBezelActivityView activityViewForView:[[[UIApplication sharedApplication] delegate] window]];
    }
    
    [UKNetworkManager operationType:POST fromPath:@"selling/" withParameters:params withUploadData:nil  :^(id result) {
        
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            
            if (model.pagination==No) {
                _noDataFoundLbl.hidden=YES;
                _feedsCollVw.hidden=NO;
                allPosts=[[NSMutableArray alloc] init];
                allPosts=[[result valueForKey:@"data"] valueForKey:@"selling"];
                _feedsCollVw.delegate=self;
                _feedsCollVw.dataSource=self;
                [_feedsCollVw reloadData];
//                if (model.added==Added) {
//                    model.added=Removed;
//                } else {
                [_feedsCollVw setContentOffset:CGPointZero];
//                }
            } else {
                allPosts=[allPosts arrayByAddingObjectsFromArray:[[result valueForKey:@"data"] valueForKey:@"selling"]].mutableCopy;
                _feedsCollVw.delegate=self;
                _feedsCollVw.dataSource=self;
                [_feedsCollVw reloadData];
            }
            
        } else {
            
            if (model.pagination==Yes) {
                model.pagination=No;
                model.pageCount=model.pageCount-1;
            } else {
                NSLog(@"hgdfjkhgdfjkgdfgdf");
                _noDataFoundLbl.hidden=NO;
                _feedsCollVw.hidden=YES;
            }
        }
        [DejalBezelActivityView removeViewAnimated:YES];
        
    } :^(NSError *error, NSString *errorMessage) {
        
        [DejalBezelActivityView removeViewAnimated:YES];

    }];
}
-(void)didSelectItem : (KPDropMenu *) dropMenu atIndex : (int) atIndex
{
    switch (atIndex) {
        case 0:
            model.sortBy=All;
            break;
        case 1:
            model.sortBy=Certified;
            break;
        case 2:
            model.sortBy=NotCertified;
            break;
        case 3:
            model.sortBy=Male;
            break;
        default:
            model.sortBy=Female;
            break;
    }
    model.pageCount=1;
    model.pagination=No;
    [self getPostFromFields:model.pageCount];
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag!=112232) {
        NSLog(@"%ld",(long)indexPath.row);
        if (indexPath.row==allPosts.count-1) {
            model.pagination=Yes;
            model.pageCount=model.pageCount+1;
            [self getPostFromFields:model.pageCount];
        }
    }
}
- (IBAction)onTapBackBarBtn:(UIBarButtonItem *)sender {
    
    HomeVC *home=[self.storyboard instantiateViewControllerWithIdentifier:@"homeNav"];
    ShopVC *shop=[self.storyboard instantiateViewControllerWithIdentifier:@"shopNav"];
    MyListingVC *myListing=[self.storyboard instantiateViewControllerWithIdentifier:@"myListingNav"];
    MoreVC *more=[self.storyboard instantiateViewControllerWithIdentifier:@"moreNav"];
    
    self.tabBarController.viewControllers=@[home,shop,myListing,more];
    
}

- (IBAction)onTaplayoutType:(UIButton *)sender {
    
    if (isGridLayOut) {
        isGridLayOut=NO;
        [_layOutBtn setBackgroundImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];

    } else {
        [_layOutBtn setBackgroundImage:[UIImage imageNamed:@"grid"] forState:UIControlStateNormal];

        isGridLayOut=YES;
    }
    [self.feedsCollVw reloadData];
}

- (IBAction)onTapMyLocation:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"toSearchLocations" sender:self];
}
- (void)onTapSearchBtn:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"toSearchPosts" sender:self];
}
- (void)onTapCartBarBtn:(UIButton *)sender {
    CartVC *cart=[self.storyboard instantiateViewControllerWithIdentifier:@"CartVC"];
    [self.navigationController pushViewController:cart animated:YES];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"toFilter"]){
        FilterVC *filter = (FilterVC *)segue.destinationViewController;
        filter.filterDetails=animalCategories[_animalsCollVw.indexPathsForSelectedItems[0].row];        
    } else if ([segue.identifier isEqualToString:@"toPostDetails"]) {
        PostDetailsVC *postDetails = (PostDetailsVC *)segue.destinationViewController;
        postDetails.postDetails=allPosts[_feedsCollVw.indexPathsForSelectedItems[0].row];
        postDetails.isFromSearch=YES;
    }
}

- (IBAction)onTapRemoveFilter:(UKButton *)sender {
    model.animalSelection=NotSelected;
model.animalSelectionDict=@{@"breed_id":@"",@"min_price":@"",@"max_price":@"",@"category_id":@"",@"radius":@""}.mutableCopy;
    [_animalsCollVw reloadData];
    model.pageCount=1;
    model.sortBy=All;
    model.pagination=No;
    _typesDropDown.items=model.sortingArray;
    _typesDropDown.title=AMLocalizedString(model.sortingArray[0], model.sortingArray[0]);
    _typesDropDown.delegate=self;
    [self getPostFromFields:model.pageCount];

}
- (IBAction)onTapChangingRange:(UITapGestureRecognizer *)sender {
}

- (IBAction)onDragSlider:(UISlider *)sender {
    
    CGFloat i=sender.value;
    [self setSliderBuble:i];
}

- (IBAction)onTapSlider:(UITapGestureRecognizer *)sender {
    CGPoint  pointTaped = [sender locationInView:_sliderForDistance];
    
    float new=_sliderForDistance.minimumValue+pointTaped.x/_sliderForDistance.bounds.size.width*(_sliderForDistance.maximumValue-_sliderForDistance.minimumValue);
    CGFloat i=new;
    [self setSliderBuble:i];
}

- (IBAction)didEndDraggingSlider:(UISlider *)sender {
    CGFloat i=sender.value;
    [self setSliderBuble:i];
}

-(void)setSliderBuble:(CGFloat)position
{
    
    if (position<0.5) {
        
        [_sliderForDistance setValue:0 animated:YES];
        [_twoLabel setTextColor:[UIColor redColor]];
        [model.animalSelectionDict setValue:@"2" forKey:@"radius"];
        _listingSliderLbl.text=[NSString stringWithFormat:@"%@ 2 kms",AMLocalizedString(@"listing_within", @"listing_within")];
        
        _rangeLabel.text=[NSString stringWithFormat:@"%@ 2 kms",AMLocalizedString(@"within", @"within")];

        [_tenLbl setTextColor:[UIColor blackColor]];
        [_fiftyLabel setTextColor:[UIColor blackColor]];
        [_twoHundredLbl setTextColor:[UIColor blackColor]];
        [_fiveHundredLabel setTextColor:[UIColor blackColor]];
        [_thousandLabel setTextColor:[UIColor blackColor]];
        [_threeThousandLbl setTextColor:[UIColor blackColor]];
        
    } else if (position>0.5 && position<1.5) {
        [_sliderForDistance setValue:1 animated:YES];
        
        [_twoLabel setTextColor:[UIColor blackColor]];
        [model.animalSelectionDict setValue:@"10" forKey:@"radius"];
        _listingSliderLbl.text=[NSString stringWithFormat:@"%@ 10 kms",AMLocalizedString(@"listing_within", @"listing_within")];
        
        _rangeLabel.text=[NSString stringWithFormat:@"%@ 10 kms",AMLocalizedString(@"within", @"within")];

        [_tenLbl setTextColor:[UIColor redColor]];
        [_fiftyLabel setTextColor:[UIColor blackColor]];
        [_twoHundredLbl setTextColor:[UIColor blackColor]];
        [_fiveHundredLabel setTextColor:[UIColor blackColor]];
        [_thousandLabel setTextColor:[UIColor blackColor]];
        [_threeThousandLbl setTextColor:[UIColor blackColor]];
    } else if (position>1.5 && position<2.5) {
        [_sliderForDistance setValue:2 animated:YES];
        [_twoLabel setTextColor:[UIColor blackColor]];
        [model.animalSelectionDict setValue:@"50" forKey:@"radius"];
        _listingSliderLbl.text=[NSString stringWithFormat:@"%@ 50 kms",AMLocalizedString(@"listing_within", @"listing_within")];
        
        _rangeLabel.text=[NSString stringWithFormat:@"%@ 50 kms",AMLocalizedString(@"within", @"within")];

        [_tenLbl setTextColor:[UIColor blackColor]];
        [_fiftyLabel setTextColor:[UIColor redColor]];
        [_twoHundredLbl setTextColor:[UIColor blackColor]];
        [_fiveHundredLabel setTextColor:[UIColor blackColor]];
        [_thousandLabel setTextColor:[UIColor blackColor]];
        [_threeThousandLbl setTextColor:[UIColor blackColor]];
        
    } else if (position>2.5 && position<3.5) {
        [_sliderForDistance setValue:3 animated:YES];
        [_twoLabel setTextColor:[UIColor blackColor]];
        [model.animalSelectionDict setValue:@"200" forKey:@"radius"];
        _listingSliderLbl.text=[NSString stringWithFormat:@"%@ 200kms",AMLocalizedString(@"listing_within", @"listing_within")];
        
        _rangeLabel.text=[NSString stringWithFormat:@"%@ 200kms",AMLocalizedString(@"within", @"within")];

        [_tenLbl setTextColor:[UIColor blackColor]];
        [_fiftyLabel setTextColor:[UIColor blackColor]];
        [_twoHundredLbl setTextColor:[UIColor redColor]];
        [_fiveHundredLabel setTextColor:[UIColor blackColor]];
        [_thousandLabel setTextColor:[UIColor blackColor]];
        [_threeThousandLbl setTextColor:[UIColor blackColor]];
        
    } else if (position>3.5 && position<4.5) {
        [_sliderForDistance setValue:4 animated:YES];
        [_twoLabel setTextColor:[UIColor blackColor]];
        [model.animalSelectionDict setValue:@"500" forKey:@"radius"];
        _listingSliderLbl.text=[NSString stringWithFormat:@"%@ 500kms",AMLocalizedString(@"listing_within", @"listing_within")];
        
        _rangeLabel.text=[NSString stringWithFormat:@"%@ 500kms",AMLocalizedString(@"within", @"within")];

        [_tenLbl setTextColor:[UIColor blackColor]];
        [_fiftyLabel setTextColor:[UIColor blackColor]];
        [_twoHundredLbl setTextColor:[UIColor blackColor]];
        [_fiveHundredLabel setTextColor:[UIColor redColor]];
        [_thousandLabel setTextColor:[UIColor blackColor]];
        [_threeThousandLbl setTextColor:[UIColor blackColor]];
    } else if (position>4.5 && position<5.5) {
        [_sliderForDistance setValue:5 animated:YES];
        [_twoLabel setTextColor:[UIColor blackColor]];
        [model.animalSelectionDict setValue:@"1000" forKey:@"radius"];
        _listingSliderLbl.text=[NSString stringWithFormat:@"%@ 1000 kms",AMLocalizedString(@"listing_within", @"listing_within")];
        
        _rangeLabel.text=[NSString stringWithFormat:@"%@ 1000 kms",AMLocalizedString(@"within", @"within")];

        [_tenLbl setTextColor:[UIColor blackColor]];
        [_fiftyLabel setTextColor:[UIColor blackColor]];
        [_twoHundredLbl setTextColor:[UIColor blackColor]];
        [_fiveHundredLabel setTextColor:[UIColor blackColor]];
        [_thousandLabel setTextColor:[UIColor redColor]];
        [_threeThousandLbl setTextColor:[UIColor blackColor]];
    } else{
        [_sliderForDistance setValue:6 animated:YES];
        [_twoLabel setTextColor:[UIColor blackColor]];
        [model.animalSelectionDict setValue:@"3000" forKey:@"radius"];
        _listingSliderLbl.text=[NSString stringWithFormat:@"%@ 3000 kms",AMLocalizedString(@"listing_within", @"listing_within")];
        
        _rangeLabel.text=[NSString stringWithFormat:@"%@ 3000 kms",AMLocalizedString(@"within", @"within")];

        [_tenLbl setTextColor:[UIColor blackColor]];
        [_fiftyLabel setTextColor:[UIColor blackColor]];
        [_twoHundredLbl setTextColor:[UIColor blackColor]];
        [_fiveHundredLabel setTextColor:[UIColor blackColor]];
        [_thousandLabel setTextColor:[UIColor blackColor]];
        [_threeThousandLbl setTextColor:[UIColor redColor]];
    }
}

- (IBAction)onTapBackground:(UIButton *)sender {
    
    _rangeView.hidden=YES;
    _backGroundBtn.hidden=YES;
    
}

- (IBAction)onTapRangeBtn:(UIButton *)sender {
    _rangeView.hidden=NO;
    _rangeView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [_backGroundBtn setHidden:NO];
    [UIView animateWithDuration:0.2
                     animations:^{
                         //                         _pricePopUpVw.transform = CGAffineTransformMakeScale(1.5, 1.5);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              _rangeView.transform = CGAffineTransformIdentity;
                                              
                                          }];
                     }];
}



- (IBAction)onTapCancelRangeSelection:(UIButton *)sender {
    
    _rangeView.hidden=YES;
    _backGroundBtn.hidden=YES;
}
- (IBAction)onTapOKAYOfRangeSelection:(UIButton *)sender {
    
    _rangeView.hidden=YES;
    _backGroundBtn.hidden=YES;
}

@end




@interface NavVC ()

@end

@implementation NavVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _searchTabBar.title=AMLocalizedString(@"tab1", @"tab1");
    
    self.tabBarItem.title=AMLocalizedString(@"tab1", @"tab1");
    
}

@end
