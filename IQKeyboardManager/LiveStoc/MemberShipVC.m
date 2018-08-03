//
//  MemberShipVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 12/22/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import "MemberShipVC.h"
#import "ImagesVC.h"
@interface MemberShipVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *plansArr,*imagesArr;
}
@end

@implementation MemberShipVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=AMLocalizedString(@"choose_plan", @"choose_plan");
    
    plansArr=[[NSMutableArray alloc] init];
    imagesArr=[[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4", nil];
    
    [self getPlans];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (IBAction)onTapBuyNowBtn:(UIButton *)sender
{
    ContactUsVC *contact=[self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsVC"];
    [self.navigationController pushViewController:contact animated:YES];
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UKCollectionCell *cell=[_memberCollVw dequeueReusableCellWithReuseIdentifier:@"memberShipCell" forIndexPath:indexPath];
    cell.animalImgVwOfMemberVC.image=[UIImage imageNamed:[imagesArr objectAtIndex:indexPath.row]];
    cell.countLblOfMemberVC.text=[NSString stringWithFormat:@"%@",[[plansArr objectAtIndex:indexPath.row] valueForKey:@"access"]];
    cell.animalsLblOfMemberVC.text=AMLocalizedString(@"animal", @"animal");
    NSString *str=[plansArr[indexPath.row][@"title"] componentsSeparatedByString:@"("] [1];
    str=[str substringToIndex:str.length-1];
    cell.accessLblOfMemberVC.text=str;
    cell.priceLblOfMemberVC.text=[NSString stringWithFormat:@"Rs %@",plansArr[indexPath.row][@"price"]];
    [cell.buyNowBtnOfMemberVC setTitle:AMLocalizedString(@"buy_now", @"buy_now") forState:UIControlStateNormal];
    
    return cell;
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return plansArr.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_memberCollVw.frame.size.width, _memberCollVw.frame.size.height);
}
-(void)getPlans
{
    [DejalBezelActivityView activityViewForView:[[[UIApplication sharedApplication] delegate] window]];
    
    [UKNetworkManager operationType:GET fromPath:@"user/access_plans" withParameters:nil withUploadData:nil :^(id result) {
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            
            plansArr=[[[result valueForKey:@"data"] valueForKey:@"plans"] mutableCopy];
            
            _memberCollVw.delegate=self;
            _memberCollVw.dataSource=self;
            [_memberCollVw reloadData];
            
        } else {
            
        }
        [DejalBezelActivityView removeViewAnimated:YES];
    } :^(NSError *error, NSString *errorMessage) {
        
        [DejalBezelActivityView removeViewAnimated:YES];
    }];
}

@end
