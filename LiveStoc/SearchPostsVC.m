//
//  SearchPostsVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 12/19/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import "SearchPostsVC.h"
#import "PostDetailsVC.h"
@interface SearchPostsVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *allPosts;
}
@end

@implementation SearchPostsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _searchTF.placeholder=AMLocalizedString(@"search", @"Search");
    
    [_searchTF becomeFirstResponder];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UKCollectionCell *doubleCell=[self.searchCollVw dequeueReusableCellWithReuseIdentifier:@"searchCell" forIndexPath:indexPath];
    
    [doubleCell.postedImgVwOfSearchVC sd_setImageWithURL:[NSURL URLWithString:allPosts[indexPath.row][@"images"][0][@"images"]] placeholderImage:[UIImage imageNamed:@"p"] options:SDWebImageHighPriority];
    doubleCell.postDateLblOfSearchVC.text=[NSString stringWithFormat:@"%@",[[allPosts[indexPath.row][@"created"] componentsSeparatedByString:@" "]objectAtIndex:0]];
    doubleCell.nameOfPostedAnimalOfSearchVC.text=[NSString stringWithFormat:@"%@",allPosts[indexPath.row][@"title"]];
    doubleCell.addressOfPostOfSearchVC.text=[NSString stringWithFormat:@"%@",allPosts[indexPath.row][@"formatted_address"]];
    doubleCell.costOfPostOfSearchVC.text=[NSString stringWithFormat:@"%@ %@",[NSString base64String:allPosts[indexPath.row][@"cur_symbol"]],allPosts[indexPath.row][@"price"]];
    doubleCell.ageAttribOfSearchVC.text=AMLocalizedString(@"age", @"age");
    doubleCell.lactationAttribOfSearchVC.text=AMLocalizedString(@"lactation", @"lactation");
    doubleCell.yeildAttribOfSearchVC.text=AMLocalizedString(@"yield", @"yield");
    doubleCell.ageOfAnimalOfSearchVC.text=[NSString stringWithFormat:@"%@",allPosts[indexPath.row][@"age"]];
    doubleCell.lactationOfAnimalOfSearchVC.text=[NSString stringWithFormat:@"%@",allPosts[indexPath.row][@"lactation"]];
    doubleCell.yieldOfAnimalOfSearchVC.text=[NSString stringWithFormat:@"%@",allPosts[indexPath.row][@"yield_max"]];
    
    if ([allPosts[indexPath.row][@"isCertified"] integerValue]==1) {
        doubleCell.ratingVwOfSearchVC.hidden=YES;
        doubleCell.certifiedImgOfSearchVC.hidden=NO;
        
    } else {
        doubleCell.ratingVwOfSearchVC.hidden=YES;
        doubleCell.certifiedImgOfSearchVC.hidden=YES;
        
    }
//    doubleCell.ratingVwOfSearchVC.enabled=NO;
    
    
    return doubleCell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return allPosts.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_searchCollVw.frame.size.width/2, (_searchCollVw.frame.size.width/2)+40);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_searchTF resignFirstResponder];
    PostDetailsVC *details=[self.storyboard instantiateViewControllerWithIdentifier:@"PostDetailsVC"];
    details.postDetails=[allPosts objectAtIndex:indexPath.row];
    
    details.isFromSearch=YES;
    details.isFromAllSale=NO;
    details.isFromFavourites=NO;
    
    [self.navigationController pushViewController:details animated:YES];
}
- (IBAction)searchTextDidChange:(UKTextField *)sender {
    if (sender.text.length>0) {
        [UKNetworkManager operationType:POST fromPath:@"selling/" withParameters:@{@"searchkeyword":sender.text,@"users_id":[UKNetworkManager getFromDefaultsWithKeyString:USER_ID]}.mutableCopy withUploadData:nil :^(id result) {
            if ([[result valueForKey:SUCCESS] integerValue]==1) {
                
                allPosts=[[NSMutableArray alloc] init];
                allPosts=[[result valueForKey:@"data"] valueForKey:@"selling"];
                _searchCollVw.delegate=self;
                _searchCollVw.dataSource=self;
                [_searchCollVw reloadData];
                [_searchCollVw setContentOffset:CGPointZero];
                
            } else {
                
            }
        } :^(NSError *error, NSString *errorMessage) {
            
        }];
    } else {
        allPosts=[[NSMutableArray alloc] init];
        [_searchCollVw reloadData];
    }
 
}

- (IBAction)onTapBackBtn:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
