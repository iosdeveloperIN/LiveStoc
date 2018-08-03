//
//  ShopVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 11/24/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import "ShopVC.h"
#import "ProductDetailsVC.h"
@interface ShopVC ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CAAnimationDelegate>
{
    BOOL isGridLayOut;
    NSMutableArray *selectedIndexArr,*productsArr;
    NSMutableArray *filterArr;
    UKModel *model;
    UIRefreshControl *refreshControl;
    JSBadgeView *badgeView;
}
@property(strong,nonatomic) UIButton *customButton;

@end

@implementation ShopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    model=[UKModel model];
    
    selectedIndexArr=[[NSMutableArray alloc] init];
    isGridLayOut=YES;
    _pricePopUpVw.hidden=YES;
    [_backGroundBtn setHidden:YES];
    self.filterView.hidden=YES;


    
    [_gridBtn setBackgroundImage:[UIImage imageNamed:@"grid"] forState:UIControlStateNormal];

    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(refershControlAction) forControlEvents:UIControlEventValueChanged];
    [self.shopCollVw addSubview:refreshControl];
  
    model.pageCount=1;
    model.pagination=No;
    model.filterCategory=@"";
    model.searchText=@"";
    model.minPrice=@"";
    model.maxPrice=@"";
    [self getProductsFromFileds:model.pageCount];
    [self getCategories];
    
    
    _noItemsLabel.text=AMLocalizedString(@"no_item_shop", @"no_item_shop");
    [_priceFilter setTitle:AMLocalizedString(@"price_filter", @"price_filter") forState:UIControlStateNormal];
    [_clearFilterBtn setTitle:AMLocalizedString(@"clear_filter", @"clear_filter") forState:UIControlStateNormal];
    _searchTF.placeholder=AMLocalizedString(@"search", @"search");
    _orLbl.text=AMLocalizedString(@"or", @"or");
    
}
-(void)refershControlAction
{
    [refreshControl endRefreshing];
    model.pageCount=1;
    model.pagination=No;
    model.filterCategory=@"";
    model.searchText=@"";
    model.minPrice=@"";
    model.maxPrice=@"";
    [self getProductsFromFileds:model.pageCount];
}
-(void)viewWillAppear:(BOOL)animated
{
    _filterBtn.layer.cornerRadius=_filterBtn.frame.size.width/2;
    _filterBtn.clipsToBounds=YES;
    self.navigationItem.title=AMLocalizedString(@"tab2", @"tab2");
    
    

    
    _customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_customButton setImage:[UIImage imageNamed:@"cart"] forState:UIControlStateNormal];
    [_customButton sizeToFit];
    _customButton.frame = CGRectMake(0.0, 0.0, 20, 20);
    [_customButton addTarget:self action:@selector(onTapCartBarBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* customBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_customButton];
    self.navigationItem.rightBarButtonItem = customBarButtonItem;
    badgeView = [[JSBadgeView alloc] initWithParentView:_customButton alignment:JSBadgeViewAlignmentTopRight];
    badgeView.badgeBackgroundColor=[UIColor redColor];
    badgeView.badgeText = [NSString stringWithFormat:@"%li",(long)[[UKModel model] cartCount]];
    
//    self.navigationItem.rightBarButtonItem.badgeValue=[NSString stringWithFormat:@"%ld",(long)[[UKModel model] cartCount]];
//    self.navigationItem.rightBarButtonItem.shouldHideBadgeAtZero=YES;
//    self.navigationItem.rightBarButtonItem.shouldAnimateBadge=YES;
    
}
-(void)getProductsFromFileds:(NSInteger)page
{
    NSMutableDictionary *param=[[NSMutableDictionary alloc] init];
    
    [param setValue:model.filterCategory forKey:@"category_id"];
    [param setValue:model.searchText forKey:@"searchkeyword"];
    [param setValue:model.minPrice forKey:@"min_price"];
    [param setValue:model.maxPrice forKey:@"max_price"];
    [param setValue:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [self getProductsDataFromFileds:param];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return productsArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (isGridLayOut) {
        UKCollectionCell *doubleCell=[_shopCollVw dequeueReusableCellWithReuseIdentifier:@"doubleItemCell" forIndexPath:indexPath];

        [doubleCell.imgVwOfShopVC sd_setImageWithURL:[NSURL URLWithString:productsArr[indexPath.row][@"images"][0][@"images"]] placeholderImage:[UIImage imageNamed:@"p"] options:SDWebImageHighPriority];
        doubleCell.titleNameOfShopVC.text=[NSString stringWithFormat:@"%@",productsArr[indexPath.row][@"title"]];
        doubleCell.costLabelOfShopVC.text=[NSString stringWithFormat:@"%@",productsArr[indexPath.row][@"price"]];

        return doubleCell;
        
    } else {
        UKCollectionCell *singleCell=[_shopCollVw dequeueReusableCellWithReuseIdentifier:@"singleItemCell" forIndexPath:indexPath];
        
        [singleCell.imgVwOfShopVC sd_setImageWithURL:[NSURL URLWithString:productsArr[indexPath.row][@"images"][0][@"images"]] placeholderImage:[UIImage imageNamed:@"p"] options:SDWebImageHighPriority];
        singleCell.titleNameOfShopVC.text=[NSString stringWithFormat:@"%@",productsArr[indexPath.row][@"title"]];
        singleCell.priceAttribOfShopVC.text=AMLocalizedString(@"price", @"price");
        singleCell.descriptionAttribOfShopVC.text=AMLocalizedString(@"description", @"description");
        singleCell.quantityAttribOfShopVC.text=AMLocalizedString(@"quantity", @"quantity");
        singleCell.priceLabel.text=[NSString stringWithFormat:@"%@",productsArr[indexPath.row][@"price"]];
        singleCell.descriptionLabelOfShopVC.text=[NSString stringWithFormat:@"%@",productsArr[indexPath.row][@"description"]];
        singleCell.quantityLabelOfShopVC.text=[NSString stringWithFormat:@"%@",productsArr[indexPath.row][@"qty"]];
        
        return singleCell;
        
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailsVC *product=[self.storyboard instantiateViewControllerWithIdentifier:@"ProductDetailsVC"];
    product.postDetails=productsArr[indexPath.row];
    product.title=productsArr[indexPath.row][@"title"];
    [self.navigationController pushViewController:product animated:YES];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isGridLayOut) {
        return CGSizeMake(self.shopCollVw.frame.size.width/2, self.shopCollVw.frame.size.width/2);
    } else {
        return CGSizeMake(self.shopCollVw.frame.size.width, self.shopCollVw.frame.size.width*0.5);
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return filterArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([selectedIndexArr containsObject:[NSNumber numberWithInteger:section]]) {
        
        return [filterArr[section][@"sub_category"] count];
        
    } else {
        
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident=@"cell";
    UKTableCell *cell=[_filterTblVw dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell=[[UKTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    cell.subCategoryLabelOfFilterTable.text=[NSString stringWithFormat:@"%@",filterArr[indexPath.section][@"sub_category"][indexPath.row][@"category"]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UKTableCell *headerCell = [_filterTblVw dequeueReusableCellWithIdentifier:@"section"];
    if (headerCell ==nil)
    {
        headerCell=[[UKTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"section"];
    }
    
    [headerCell.sectionBtn setTitle:filterArr[section][@"category"] forState:UIControlStateNormal];
    headerCell.sectionBtn.tag=section;
    
    return headerCell.contentView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    model.filterCategory=filterArr[indexPath.section][@"sub_category"][indexPath.row][@"category_id"];
    model.pageCount=1;
    model.pagination=No;
    [self getProductsFromFileds:model.pageCount];
    [self hideMenuTable];
}

-(void)getCategories
{
    [UKNetworkManager operationType:POST fromPath:@"productcategory/?limit=1000&page=1" withParameters:nil withUploadData:nil :^(id result) {
        
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            
            filterArr=[[NSMutableArray alloc] init];
            NSArray *dummyFilter=result[@"data"][@"category"];
            
            for (NSDictionary *dict in dummyFilter) {
                NSMutableArray *arr=[[NSMutableArray alloc] init];
                NSMutableDictionary *dict2=[[NSMutableDictionary alloc] init];
                dict2=dict.mutableCopy;
                arr=[dict[@"sub_category"] mutableCopy];
                [arr addObject:@{@"category_id":@"",@"category":@"Apply All"}.mutableCopy];
                [dict2 setValue:arr forKey:@"sub_category"];
                [filterArr addObject:dict2];
            }
   
            _filterTblVw.delegate=self;
            _filterTblVw.dataSource=self;
            
        } else {
            
        }
        
    } :^(NSError *error, NSString *errorMessage) {
        
    }];
}


-(void)getProductsDataFromFileds:(NSMutableDictionary *)paramDict
{
    if (model.pagination==No) {
        [DejalBezelActivityView activityViewForView:[[[UIApplication sharedApplication] delegate] window]];
    }
    
    [UKNetworkManager operationType:POST fromPath:@"products/" withParameters:paramDict withUploadData:nil  :^(id result) {
        
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            
            if (model.pagination==No) {
                _noItemsLabel.hidden=YES;
                _shopCollVw.hidden=NO;
                productsArr=[[NSMutableArray alloc] init];
                productsArr=[[result valueForKey:@"data"] valueForKey:@"products"];
                _shopCollVw.delegate=self;
                _shopCollVw.dataSource=self;
                [_shopCollVw reloadData];
                [_shopCollVw setContentOffset:CGPointZero];
                
            } else {
                productsArr=[productsArr arrayByAddingObjectsFromArray:[[result valueForKey:@"data"] valueForKey:@"selling"]].mutableCopy;
                [_shopCollVw reloadData];
            }
            
        } else {
            
            if (model.pagination==Yes) {
                model.pagination=No;
                model.pageCount=model.pageCount-1;
            } else {
                NSLog(@"hgdfjkhgdfjkgdfgdf");
                _noItemsLabel.hidden=NO;
                _shopCollVw.hidden=YES;
            }
        }
        [DejalBezelActivityView removeViewAnimated:YES];
        
    } :^(NSError *error, NSString *errorMessage) {
        if (model.pagination==Yes) {
            model.pagination=No;
            model.pageCount=model.pageCount-1;
        }
        [DejalBezelActivityView removeViewAnimated:YES];
        
    }];
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
        NSLog(@"%ld",(long)indexPath.row);
        if (indexPath.row==productsArr.count-1) {
            model.pagination=Yes;
            model.pageCount=model.pageCount+1;
            [self getProductsFromFileds:model.pageCount];
        }
}
- (IBAction)onTapSectionOfFilter:(UIButton *)sender {
    
    if ([selectedIndexArr containsObject:[NSNumber numberWithInteger:sender.tag]]) {
        
        [selectedIndexArr removeAllObjects];
        
    } else {
        
        [selectedIndexArr removeAllObjects];
        [selectedIndexArr addObject:[NSNumber numberWithInteger:sender.tag]];
        
    }
        [_filterTblVw reloadData];
}

-(void)hideMenuTable
{
    [_backGroundBtn setHidden:YES];
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setDuration:0.20];
    [animation setTimingFunction:
     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.filterView.layer addAnimation:animation forKey:kCATransition];
    self.filterView.hidden=YES;
}
-(void)showMenuTable
{
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setDuration:0.20];
    [animation setTimingFunction:
     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.filterView.layer addAnimation:animation forKey:kCATransition];
    self.filterView.hidden=NO;
    [_backGroundBtn setHidden:NO];
}
- (IBAction)onTapFilterBtn:(UIButton *)sender {
    
    [_filterTblVw reloadData];
    [self showMenuTable];
    
}
- (IBAction)changeTextOfSearchTF:(UITextField *)sender {
    
    
    model.searchText=sender.text;
    model.pageCount=1;
    [self  getProductsFromFileds:model.pageCount];
    
}
- (IBAction)ontapGridLayout:(UIButton *)sender {
    
    if (isGridLayOut) {
        isGridLayOut=NO;
        [_gridBtn setBackgroundImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
        
    } else {
        [_gridBtn setBackgroundImage:[UIImage imageNamed:@"grid"] forState:UIControlStateNormal];
        
        isGridLayOut=YES;
    }
    [self.shopCollVw reloadData];
    _noItemsLabel.hidden=YES;
    _shopCollVw.hidden=NO;
    
}
- (IBAction)onTapClearFilterBtn:(UKButton *)sender {
    
    model.pageCount=1;
    model.pagination=No;
    model.filterCategory=@"";
    model.searchText=@"";
    model.minPrice=@"";
    model.maxPrice=@"";
    [self hideMenuTable];
    _pricePopUpVw.hidden=YES;
    [self getProductsFromFileds:model.pageCount];
    
}
- (IBAction)onTapPriceFilter:(UKButton *)sender {
    
    _pricePopUpVw.hidden=NO;
    _pricePopUpVw.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [self hideMenuTable];
    [_backGroundBtn setHidden:NO];
    [UIView animateWithDuration:0.2
                     animations:^{
//                         _pricePopUpVw.transform = CGAffineTransformMakeScale(1.5, 1.5);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              _pricePopUpVw.transform = CGAffineTransformIdentity;
                                              
                                          }];
                     }];
    
    
}
- (IBAction)onTapBackground:(UIButton *)sender {
    
    [self hideMenuTable];
    _pricePopUpVw.hidden=YES;

}

//351
//352

- (IBAction)onTapPriceSelectionBtn:(UKButton *)sender {
    
    switch (sender.tag) {
        case 31:
            model.minPrice=@"0";
            model.maxPrice=@"1000";
            
            
            break;
        case 32:
            
            model.minPrice=@"1000";
            model.maxPrice=@"5000";
            
            break;
        case 33:
            model.minPrice=@"5000";
            model.maxPrice=@"10000";
            
            break;
        case 34:
            model.minPrice=@"10000";
            model.maxPrice=@"20000";
            
            break;
        case 35:
            
            model.minPrice=@"20000";
            model.maxPrice=@"";
            break;
        default:
            model.minPrice=_minTF.text;
            model.maxPrice=_maxTF.text;
            
            
            break;
    }
    
    model.pageCount=1;
    model.pagination=No;
    [self hideMenuTable];
    _pricePopUpVw.hidden=YES;
    [self getProductsFromFileds:model.pageCount];
}
- (void)onTapCartBarBtn:(UIButton *)sender {
    
    CartVC *cart=[self.storyboard instantiateViewControllerWithIdentifier:@"CartVC"];
    [self.navigationController pushViewController:cart animated:YES];
    
}
@end
