//
//  SoldItemsVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 12/21/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import "SoldItemsVC.h"
#import "PostDetailsVC.h"

@interface SoldItemsVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,KPDropMenuDelegate>
{
    UKModel *model;
    BOOL fromPagination;
    NSInteger sortInt,pageCount;
    NSMutableDictionary *params;
    NSMutableArray *posts;
    UIRefreshControl *refreshControl;

}
@end

@implementation SoldItemsVC

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)viewWillAppear:(BOOL)animated
{
    _noListAvailLbl.text=AMLocalizedString(@"no_listing", @"no_listing");
    model=[UKModel model];
    pageCount=1;
    sortInt=3;
    fromPagination=NO;
    _soldDropMenu.items=model.sortingArray;
    _soldDropMenu.title=AMLocalizedString(model.sortingArray[0], model.sortingArray[0]);
    _soldDropMenu.delegate=self;
    _noListAvailLbl.hidden=NO;
    _soldItemsCollVw.hidden=YES;
    [self setParamDict];
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(refershControlAction) forControlEvents:UIControlEventValueChanged];
    [self.soldItemsCollVw addSubview:refreshControl];

}
-(void)refershControlAction
{
    pageCount=1;
    fromPagination=NO;
    [refreshControl endRefreshing];
    [self setParamDict];
}

-(void)setParamDict
{
    params=[[NSMutableDictionary alloc] init];
    [params setValue:[UKNetworkManager getFromDefaultsWithKeyString:USER_ID] forKey:@"users_id"];
    [params setValue:@"1" forKey:@"isCompleted"];
    [params setValue:@"" forKey:@"category_id"];
    [params setValue:[NSString stringWithFormat:@"%ld",(long)pageCount] forKey:@"page"];
    
    switch (sortInt) {
        case 1:
            [params setValue:@"1" forKey:@"isCertified"];
            break;
        case 2:
            [params setValue:@"0" forKey:@"isCertified"];
            break;
        default:
            [params setValue:@"" forKey:@"isCertified"];
            break;
    }
    
    [self getAllSales:params];
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {

    UKCollectionCell *cell=[_soldItemsCollVw dequeueReusableCellWithReuseIdentifier:@"soldItemsCell" forIndexPath:indexPath];
    
    cell.nameLabelOfAllSalesVC.text=[NSString stringWithFormat:@"%@",[[posts objectAtIndex:indexPath.row] valueForKey:@"title"]];
    cell.dateLabelOfAllSalesVC.text=[NSString stringWithFormat:@"%@",[[posts[indexPath.row][@"created"] componentsSeparatedByString:@" "]objectAtIndex:0]];
    cell.addressLabelOfAllSalesVC.text=[NSString stringWithFormat:@"%@,%@",[[posts objectAtIndex:indexPath.row] valueForKey:@"city"],[[posts objectAtIndex:indexPath.row] valueForKey:@"province"]];
    cell.priceLabelOfAllSalesVC.text=[NSString stringWithFormat:@"%@ %@",[NSString base64String:[[posts objectAtIndex:indexPath.row] valueForKey:@"cur_symbol"]],[[posts objectAtIndex:indexPath.row] valueForKey:@"price"]];
    
    cell.statusLabelOfAllSalesVC.text=[[[posts objectAtIndex:indexPath.row] valueForKey:@"isactivated"] integerValue]==1 ? [NSString stringWithFormat:@"%@%@",AMLocalizedString(@"status", @"status"),AMLocalizedString(@"active", @"active")]:[NSString stringWithFormat:@"%@%@",AMLocalizedString(@"status", @"status"),AMLocalizedString(@"not_active", @"not_active")];

    [cell.animalImgVwOfAllSalesVC sd_setImageWithURL:[NSURL URLWithString:posts[indexPath.row][@"images"][0][@"images"]] placeholderImage:[UIImage imageNamed:@"p"] options:SDWebImageHighPriority];
    if ([posts[indexPath.row][@"isCertified"] integerValue]==1) {
        cell.ratingOfAllSalesVC.hidden=NO;
        cell.ratingOfAllSalesVC.value=5;
        cell.certiLogoOfAllSalesVC.hidden=NO;
        cell.certificationabelOfAllSalesVC.text=[NSString stringWithFormat:@"%@%@",AMLocalizedString(@"cert_status", @"cert_status"),AMLocalizedString(@"yes", @"Yes")];

        
    } else {
        cell.ratingOfAllSalesVC.hidden=YES;
        cell.certiLogoOfAllSalesVC.hidden=YES;
        cell.certificationabelOfAllSalesVC.text=[NSString stringWithFormat:@"%@%@",AMLocalizedString(@"cert_status", @"cert_status"),AMLocalizedString(@"no", @"no")];

    }
//    cell.ratingOfAllSalesVC.enabled=NO;
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return posts.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_soldItemsCollVw.frame.size.width, _soldItemsCollVw.frame.size.width*0.45);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PostDetailsVC *details=[self.storyboard instantiateViewControllerWithIdentifier:@"PostDetailsVC"];
    details.postDetails=[posts objectAtIndex:indexPath.row];
    details.isFromSearch=NO;
    details.isFromAllSale=NO;
    details.isFromFavourites=NO;
    [self.navigationController pushViewController:details animated:YES];
}
-(void)didSelectItem : (KPDropMenu *) dropMenu atIndex : (int) atIndex
{
    pageCount=1;
    fromPagination=NO;
    sortInt=atIndex;
    [self setParamDict];
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    if (indexPath.row==posts.count-1) {
        fromPagination=YES;
        pageCount=pageCount+1;
        [self setParamDict];
    }
}
-(void)getAllSales:(NSMutableDictionary *)paramDict
{
    if (!fromPagination) {
        [DejalBezelActivityView activityViewForView:[[[UIApplication sharedApplication] delegate] window]];
    }
    [UKNetworkManager operationType:POST fromPath:@"selling/usermyselling" withParameters:paramDict withUploadData:nil :^(id result) {
        
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            
            if (fromPagination) {
                
                posts=[posts arrayByAddingObjectsFromArray:[[result valueForKey:@"data"] valueForKey:@"selling"]].mutableCopy;
                _soldItemsCollVw.delegate=self;
                _soldItemsCollVw.dataSource=self;
                [_soldItemsCollVw reloadData];
            } else {
                posts=[[NSMutableArray alloc] init];
                posts=[[result valueForKey:@"data"] valueForKey:@"selling"];
                _soldItemsCollVw.delegate=self;
                _soldItemsCollVw.dataSource=self;
                [_soldItemsCollVw reloadData];
                _noListAvailLbl.hidden=YES;
                _soldItemsCollVw.hidden=NO;
            }
        } else {
            if (fromPagination) {
                fromPagination=NO;
                pageCount=pageCount-1;
            } else {
                _noListAvailLbl.hidden=NO;
                _soldItemsCollVw.hidden=YES;
            }
        }
        [DejalBezelActivityView removeViewAnimated:YES];
    } :^(NSError *error, NSString *errorMessage) {
        
        [DejalBezelActivityView removeViewAnimated:YES];
    }];
}
@end
