//
//  ProductDetailsVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 1/24/18.
//  Copyright © 2018 Harjit Singh. All rights reserved.
//

#import "ProductDetailsVC.h"
#import "ImagesVC.h"
@interface ProductDetailsVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSInteger selectedIndex;
    NSInteger productCount;
}
@end

@implementation ProductDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedIndex=0;
    productCount=1;
    _quantityLbl.text=[NSString stringWithFormat:@"%ld",(long)productCount];
    _tittleLabel.text=[NSString stringWithFormat:@"%@",_postDetails[@"title"]];
    _priceLabel.text=[NSString stringWithFormat:@"%@",_postDetails[@"price"]];
    _descriptionLabel.text=[NSString stringWithFormat:@"%@",_postDetails[@"description"]];
    [_addToCartBtn setTitle:AMLocalizedString(@"add_to_cart", @"add_to_cart") forState:UIControlStateNormal];
    
    _imagesCollVw.dataSource=self;
    _imagesCollVw.delegate=self;
    _largeCollVw.dataSource=self;
    _largeCollVw.delegate=self;
}


- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_postDetails[@"images"] count];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (collectionView.tag==221456) {
        
        UKCollectionCell *itemLarge=[_largeCollVw dequeueReusableCellWithReuseIdentifier:@"largeImageItem" forIndexPath:indexPath];
        [itemLarge.largeAnimalImgVwOfPostDetailsVC sd_setImageWithURL:_postDetails[@"images"][indexPath.row][@"fullimages"] placeholderImage:[UIImage imageNamed:@"p"] options:SDWebImageHighPriority];
        return itemLarge;
        
    } else {
        
        
        UKCollectionCell *itemSmall=[_imagesCollVw dequeueReusableCellWithReuseIdentifier:@"imagesItem" forIndexPath:indexPath];
        
        [itemSmall.smallAnimalImgVwOfPostDetailsVC sd_setImageWithURL:_postDetails[@"images"][indexPath.row][@"images"] placeholderImage:[UIImage imageNamed:@"p"] options:SDWebImageHighPriority];
        
        return itemSmall;
        
    }
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView.tag==221456) {
        return CGSizeMake(_largeCollVw.frame.size.width, _largeCollVw.frame.size.height);
        
    } else {
        if (selectedIndex==indexPath.row) {
            return CGSizeMake(_imagesCollVw.frame.size.height+10, _imagesCollVw.frame.size.height);
            
        } else {
            return CGSizeMake(_imagesCollVw.frame.size.height-10, _imagesCollVw.frame.size.height-20);
        }
        
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag!=221456) {
        
        selectedIndex=indexPath.row;
        [_imagesCollVw reloadData];
        [_largeCollVw scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    } else {
        
        ImagesVC *images = [self.storyboard instantiateViewControllerWithIdentifier:@"ImagesVC"];
        images.imagesArr=_postDetails[@"images"];
        images.navTitle=[_postDetails valueForKey:@"title"];
        images.selectedIndex=indexPath.row;
        [self.navigationController pushViewController:images animated:YES];

    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView.tag!=221456) {
        
        CGFloat totalCellWidth = (_imagesCollVw.frame.size.height-10) * [_postDetails[@"images"] count];
        CGFloat totalSpacingWidth = 0*([_postDetails[@"images"] count] - 1);
        CGFloat leftInset = (_imagesCollVw.frame.size.width - (totalCellWidth + totalSpacingWidth)) / 2;
        CGFloat rightInset = leftInset;
        UIEdgeInsets sectionInset = UIEdgeInsetsMake(0, leftInset, 0, rightInset);
        return sectionInset;
    } else {
        return UIEdgeInsetsZero;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag==221456) {
        
        selectedIndex = _largeCollVw.contentOffset.x / _largeCollVw.frame.size.width;
        [_imagesCollVw reloadData];
        
    }
}

- (IBAction)onTapMinusBtn:(UIButton *)sender {
    
    if (productCount>1) {
        productCount=productCount-1;
        _quantityLbl.text=[NSString stringWithFormat:@"%ld",(long)productCount];
    }
}
- (IBAction)onTapPlus:(UIButton *)sender {
    
    if (productCount<[_postDetails[@"qty"] integerValue]) {
    productCount=productCount+1;
    _quantityLbl.text=[NSString stringWithFormat:@"%ld",(long)productCount];
    }
}

//http://livestoc.com/webservices/cart/?users_id=13&products_id=2&qty=54656&submit=Go

- (IBAction)onTapAddToCart:(UKButton *)sender {
    [self addToCart];
}
-(void)addToCart
{
    
    [DejalBezelActivityView activityViewForView:[[[UIApplication sharedApplication] delegate] window]];
    [UKNetworkManager operationType:POST fromPath:@"cart/add" withParameters:@{@"users_id":[UKNetworkManager getFromDefaultsWithKeyString:USER_ID],@"products_id":_postDetails[@"products_id"],@"qty":[NSString stringWithFormat:@"%ld",(long)productCount],@"submit":@"Go"}.mutableCopy withUploadData:nil :^(id result) {
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            
            [[UKModel model] setCartCount:[[UKModel model] cartCount]+1];
            [self.navigationController popViewControllerAnimated:YES];
            [[[[UIApplication sharedApplication] delegate] window] makeToast:[result valueForKey:@"message"] duration:3.0 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-80)]];
            
        } else {
            
            [[[[UIApplication sharedApplication] delegate] window] makeToast:[result valueForKey:@"message"] duration:3.0 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-80)]];

        }
        [DejalBezelActivityView removeViewAnimated:YES];
        
    } :^(NSError *error, NSString *errorMessage) {
        [DejalBezelActivityView removeViewAnimated:YES];
        [[[[UIApplication sharedApplication] delegate] window] makeToast:errorMessage duration:3.0 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-80)]];

    }];
    
}
@end
