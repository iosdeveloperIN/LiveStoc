//
//  PostDetailsVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 12/13/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import "PostDetailsVC.h"
#import "ImagesVC.h"
#import "MapDetailsVC.h"
@interface PostDetailsVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>
{
    NSInteger selectedIndex;
    NSMutableDictionary *attribValuesDict;
    NSMutableString *strForAppend;
    BOOL isFavroute;
}
@end

@implementation PostDetailsVC
@synthesize isFromSearch,isFromAllSale,isFromFavourites;
- (void)viewDidLoad {
    [super viewDidLoad];
    selectedIndex=0;
    NSLog(@"POSTDETSILSKSNH====%@",_postDetails);
    strForAppend=[[NSMutableString alloc] init];
    self.navigationItem.title=[_postDetails valueForKey:@"category"];
    attribValuesDict=[[NSMutableDictionary alloc] init];
    attribValuesDict=@{
                       @"attrib":@[@"uid",@"price",@"category",@"breed",@"description",@"seller_name",@"seller_email",@"seller_contact",@"primary_add",@"secondry_add"].mutableCopy,
                       @"values":@[[self emptyStringReturn:[_postDetails valueForKey:@"selling_id"]],
                                   [self emptyStringReturn:[_postDetails valueForKey:@"price"]],
                                   [self emptyStringReturn:[_postDetails valueForKey:@"category"]],
                                   [self emptyStringReturn:[_postDetails valueForKey:@"breed_name"]],
                                   [self emptyStringReturn:[_postDetails valueForKey:@"description"]],
                                   [self emptyStringReturn:[_postDetails valueForKey:@"fullname"]],
                                   [self emptyStringReturn:[_postDetails valueForKey:@"email"]],
                                   [self emptyStringReturn:[_postDetails valueForKey:@"mobile"]],
                                   [self emptyStringReturn:[_postDetails valueForKey:@"formatted_address"]],
                                   [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",[_postDetails valueForKey:@"user_street"],[_postDetails valueForKey:@"user_village"],[_postDetails valueForKey:@"user_post_office"],[_postDetails valueForKey:@"user_tehsil"],[_postDetails valueForKey:@"user_district"],[_postDetails valueForKey:@"user_state"],[_postDetails valueForKey:@"user_pin_no"]]].mutableCopy}.mutableCopy;
    
    
    
    
    [attribValuesDict[@"attrib"] insertObject:@"age" atIndex:4];
    
    if ([[_postDetails valueForKey:@"age"] integerValue]>0) {
        
        [strForAppend appendString:[NSString stringWithFormat:@"%@ %@",[_postDetails valueForKey:@"age"],AMLocalizedString(@"year", @"year")]];
        
    } else if ([[_postDetails valueForKey:@"age_month"] integerValue]>0) {
        
        [strForAppend appendString:[NSString stringWithFormat:@"  %@ %@",[_postDetails valueForKey:@"age_month"],AMLocalizedString(@"month", @"month")]];
        
    } else {
        strForAppend=@" ".mutableCopy;
    }
    
    [attribValuesDict[@"values"] insertObject:strForAppend atIndex:4];
    
    [attribValuesDict[@"attrib"] insertObject:@"height" atIndex:5];
    [attribValuesDict[@"attrib"] insertObject:@"weight" atIndex:6];
    
    [attribValuesDict[@"values"] insertObject:[[_postDetails valueForKey:@"height"] integerValue]>0 ? [NSString stringWithFormat:@"%@ %@",[_postDetails valueForKey:@"height"],AMLocalizedString(@"foot", @"foot")]:@" " atIndex:5];
    [attribValuesDict[@"values"] insertObject:[[_postDetails valueForKey:@"weight"] integerValue]>0 ? [NSString stringWithFormat:@"%@ %@",[_postDetails valueForKey:@"weight"],AMLocalizedString(@"kilogram", @"kilogram")]:@" " atIndex:6];

    if ([_postDetails[@"category_id"] integerValue]!=9)
    {
        [attribValuesDict[@"attrib"] insertObject:@"gender" atIndex:2];
        [attribValuesDict[@"values"] insertObject:[self emptyStringReturn:[_postDetails valueForKey:@"gender"]] atIndex:2];

        if ([_postDetails[@"gender"] isEqualToString:@"female"])
        {
            [attribValuesDict[@"attrib"] insertObject:@"is_pregnat" atIndex:6];
            [attribValuesDict[@"values"] insertObject:[self emptyStringReturn:[_postDetails valueForKey:@"isPregnant"]] atIndex:6];
            
            if ([[_postDetails valueForKey:@"category_id"] integerValue] ==1 || [[_postDetails valueForKey:@"category_id"] integerValue] ==8 || [[_postDetails valueForKey:@"category_id"] integerValue] ==11 || [[_postDetails valueForKey:@"category_id"] integerValue] ==10) {
                
                [attribValuesDict[@"attrib"] insertObject:@"yield" atIndex:6];
                [attribValuesDict[@"values"] insertObject:[NSString stringWithFormat:@"%d-%@ %@",(long)[[_postDetails valueForKey:@"yield"] integerValue]>0 ? [[_postDetails valueForKey:@"yield"] integerValue]:0,[self emptyStringReturn:[_postDetails valueForKey:@"yield_max"]],AMLocalizedString(@"liter", @"liter")] atIndex:6];
                
                [attribValuesDict[@"attrib"] insertObject:@"lactation" atIndex:6];
                [attribValuesDict[@"values"] insertObject:[self emptyStringReturn:[_postDetails valueForKey:@"lactation"]] atIndex:6];
            }
        }
    }
    
//
//    @"gender" [self emptyStringReturn:[_postDetails valueForKey:@"gender"]]
//
//    @"age" [NSString stringWithFormat:@"%@%@ %@%@",[_postDetails valueForKey:@"age"],AMLocalizedString(@"year", @"year"),[_postDetails valueForKey:@"age_month"],AMLocalizedString(@"month", @"month")]
//
//    @"height"[NSString stringWithFormat:@"%@ %@",[_postDetails valueForKey:@"height"],AMLocalizedString(@"foot", @"foot")]
//
//    @"weight"[NSString stringWithFormat:@"%@ %@",[_postDetails valueForKey:@"weight"],AMLocalizedString(@"kilogram", @"kilogram")]
//
//    @"is_pregnat" [self emptyStringReturn:[_postDetails valueForKey:@"isPregnant"]]
    
    
    
    _imagesCollVw.dataSource=self;
    _imagesCollVw.delegate=self;
    _largeCollVw.dataSource=self;
    _largeCollVw.delegate=self;
    _detailsTblVw.dataSource=self;
    _detailsTblVw.delegate=self;

    if ([[_postDetails valueForKey:@"isCertified"] integerValue]==1) {
        
        _scrollViewBack.backgroundColor=[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5];
        _certifiedLbl.text=[_postDetails valueForKey:@"certifiedBy"];
        _ratingVw.hidden=NO;
        _ratingVw.value=[[_postDetails valueForKey:@"stars"] floatValue];
        
        _ratingVw.value=5.0;
        _certifiedView.hidden=YES;
        _certifiedTblVw.estimatedRowHeight=200;
        _certifiedTblVw.rowHeight=UITableViewAutomaticDimension;
        _certifiedTblVw.delegate=self;
        _certifiedTblVw.dataSource=self;
        [_certifiedTblVw reloadData];
    } else {
        _scrollViewBack.backgroundColor=[UIColor clearColor];
        _certifiedLbl.text=AMLocalizedString(@"not_certified", @"not_certified");
        _ratingVw.hidden=YES;
        _certifiedView.hidden=YES;

    }
    
    [_inactiveCertificationBtn setTitle:AMLocalizedString(@"certification_msg", @"certification_msg") forState:UIControlStateNormal];

    _certificationStatusAttrib.text=AMLocalizedString(@"certification_status", @"certification_status");
    _cartificationStatusNameLbl.text=AMLocalizedString(@"certified", @"certified");
    _remarkNameLbl.text=[[_postDetails valueForKey:@"remarks"] isEqual:@""] ? @"N/A":[_postDetails valueForKey:@"remarks"];
    _certifiedAttribLbl.text=AMLocalizedString(@"certified", @"certified");
    _remarkAttribLbl.text=AMLocalizedString(@"remark", @"remark");
    [_contactSellerBtn setTitle:AMLocalizedString(@"contact_seller", @"contact_seller") forState:UIControlStateNormal];
    [_soldOutBtn setTitle:AMLocalizedString(@"mark_sold", @"mark_sold") forState:UIControlStateNormal];
    _heightOfDetailsTblVw.constant=([attribValuesDict[@"attrib"] count]*49)+80;
    _detailsTblVw.layer.borderWidth=1;
    _detailsTblVw.layer.borderColor=[UIColor darkGrayColor].CGColor;
    [_activatedCertificationBtn setTitle:AMLocalizedString(@"apply_cert", @"apply_cert") forState:UIControlStateNormal];
    
    if (isFromSearch) {
        
        _cartificationStatusNameLbl.hidden=YES;
        _certificationStatusAttrib.hidden=YES;
        
//        _contactSellerBtn.hidden=YES;
        
        _inactiveCertificationBtn.hidden=YES;
        _soldOutBtn.hidden=YES;
        _activatedCertificationBtn.hidden=YES;

        if ([[_postDetails valueForKey:@"favorite_id"] integerValue]>0) {
            _favBarBtn.tintColor=[UIColor redColor];
            _favBarBtn.image=[UIImage imageNamed:@"heart"];
            isFavroute=YES;
        } else {
            _favBarBtn.tintColor=[UIColor lightGrayColor];
            _favBarBtn.image=[UIImage imageNamed:@"heart_stroke"];
            isFavroute=NO;
        }
        
    } else {
        if (isFromFavourites) {
            
            _favBarBtn.tintColor=[UIColor redColor];
            _favBarBtn.image=[UIImage imageNamed:@"heart"];
            isFavroute=YES;
            _cartificationStatusNameLbl.text=[_postDetails[@"isCertified"] integerValue]==1 ? AMLocalizedString(@"certified", @"certified"):AMLocalizedString(@"not_certified", @"not_certified") ;
            _contactSellerBtn.hidden=YES;
            _inactiveCertificationBtn.hidden=YES;
            _activatedCertificationBtn.hidden=YES;
            _soldOutBtn.hidden=YES;
        } else {
            
            if (isFromAllSale) {
                if ([[_postDetails valueForKey:@"isactivated"] integerValue]==1) {
                    
                    _inactiveCertificationBtn.hidden=YES;
                    
                } else {
                    _activatedCertificationBtn.hidden=YES;
                    _soldOutBtn.hidden=YES;
                }
                _contactSellerBtn.hidden=YES;

            } else {
                
                _inactiveCertificationBtn.hidden=YES;
                _activatedCertificationBtn.hidden=YES;
                _soldOutBtn.hidden=YES;
                _contactSellerBtn.hidden=YES;
            }
            self.navigationItem.rightBarButtonItem=nil;
        }
        
    }
}

-(NSString *)emptyStringReturn:(NSString *)value
{
    NSLog(@"%@",value);
    if ([value isEqualToString:@""] || [value length]==0) {
        return @"  ";
    } else {
        return value;
    }
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
        [self performSegueWithIdentifier:@"toImages" sender:self];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //toSearchLocationstoSearchPoststoContactUs
    
    if([segue.identifier isEqualToString:@"toImages"]){
        ImagesVC *images = (ImagesVC *)segue.destinationViewController;
        images.imagesArr=_postDetails[@"images"];
        images.selectedIndex=selectedIndex;
        images.navTitle=[_postDetails valueForKey:@"category"];
    } else if ([segue.identifier isEqualToString:@"toContactUs"]) {
        
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
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag==321) {
        
        return 30;
        
    } else {
        
        return [attribValuesDict[@"attrib"] count];

    }
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *ident=@"detailsCell";
    static NSString *general=@"general";
    static NSString *test=@"test";
    static NSString *certi=@"certi";

    
    if (tableView.tag==321) {
        
        if (indexPath.row<10) {
            
            UKTableCell *generalCell=[_certifiedTblVw dequeueReusableCellWithIdentifier:general];
            
            if (!generalCell) {
                generalCell=[[UKTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:general];
            }
            
            
            return generalCell;
            
        } else if (indexPath.row<20) {
            
            UKTableCell *testCell=[_certifiedTblVw dequeueReusableCellWithIdentifier:test];
            
            if (!testCell) {
                testCell=[[UKTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:test];
            }
            
            
            return testCell;
            
        } else {
            
            UKTableCell *certiCell=[_certifiedTblVw dequeueReusableCellWithIdentifier:certi];
            
            if (!certiCell) {
                certiCell=[[UKTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:certi];
            }
  
            
            return certiCell;
            
        }
        
    } else {
        
    
    UKTableCell *cell=[_detailsTblVw dequeueReusableCellWithIdentifier:ident];
    
    if (!cell) {
        cell=[[UKTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }

    if (indexPath.row==0) {
        cell.typeNameOfPostDetailsVC.textColor=[UIColor redColor];

    } else {
        cell.typeNameOfPostDetailsVC.textColor=[UIColor blackColor];
    }
    
    cell.attribNameOfPostDetailsVC.text=AMLocalizedString(attribValuesDict[@"attrib"][indexPath.row], attribValuesDict[@"attrib"][indexPath.row]);
    cell.typeNameOfPostDetailsVC.text=attribValuesDict[@"values"][indexPath.row];
    
    return cell;
    }
}


- (IBAction)onTapContactSeller:(UIButton *)sender {
    
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[_postDetails valueForKey:@"mobile"]]];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened %@",[NSString stringWithFormat:@"tel://%@",[_postDetails valueForKey:@"mobile"]]);
        }
    }];
}


- (IBAction)onTapFavBArBtn:(UIBarButtonItem *)sender {
    NSString *path;
    if (isFavroute) {
        _favBarBtn.tintColor=[UIColor lightGrayColor];
        _favBarBtn.image=[UIImage imageNamed:@"heart_stroke"];
        
        path=@"selling/deletefavorite";

    } else {
        _favBarBtn.tintColor=[UIColor redColor];
        _favBarBtn.image=[UIImage imageNamed:@"heart"];
        path=@"selling/favorite";
    }
    [UKNetworkManager operationType:POST fromPath:path withParameters:@{@"selling_id":[_postDetails valueForKey:@"selling_id"],@"users_id":[UKNetworkManager getFromDefaultsWithKeyString:USER_ID]}.mutableCopy withUploadData:nil :^(id result) {
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            
            if (isFavroute) {
                
                if (isFromFavourites) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                isFavroute=NO;
            } else {
                isFavroute=YES;
            }
//            [[UKModel model] setAdded:Added];
        } else {
            if (isFavroute) {
                _favBarBtn.tintColor=[UIColor redColor];
                _favBarBtn.image=[UIImage imageNamed:@"heart"];
                
            } else {
                _favBarBtn.tintColor=[UIColor lightGrayColor];
                _favBarBtn.image=[UIImage imageNamed:@"heart_stroke"];
            }
        }
    } :^(NSError *error, NSString *errorMessage) {
        if (isFavroute) {
            
            _favBarBtn.tintColor=[UIColor redColor];
            _favBarBtn.image=[UIImage imageNamed:@"heart"];
            
        } else {
            _favBarBtn.tintColor=[UIColor lightGrayColor];
            _favBarBtn.image=[UIImage imageNamed:@"heart_stroke"];
        }
    }];
    
}

- (IBAction)onTapToGetCertificationIfActivated:(UIButton *)sender {
    [self performSegueWithIdentifier:@"toContactUs" sender:self];

}

- (IBAction)onTapSoldOutBtn:(UIButton *)sender {
    
    [DejalBezelActivityView activityViewForView:[[[UIApplication sharedApplication] delegate] window]];
    
    [UKNetworkManager operationType:POST fromPath:@"selling/sellDone" withParameters:@{@"selling_id":[NSString stringWithFormat:@"%@",[_postDetails valueForKey:@"selling_id"]],@"isCompleted":@"1"}.mutableCopy withUploadData:nil :^(id result) {
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.view makeToast:[NSString stringWithFormat:@"%@\n %@",AMLocalizedString(@"error", nil),AMLocalizedString(@"try_again", nil)] duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];

        }
        [DejalBezelActivityView removeViewAnimated:YES];
    } :^(NSError *error, NSString *errorMessage) {
        [self.view makeToast:[NSString stringWithFormat:@"%@\n %@",AMLocalizedString(@"error", nil),AMLocalizedString(@"try_again", nil)] duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-120)]];

        [DejalBezelActivityView removeViewAnimated:YES];
    }];
    
}

- (IBAction)onTapCertificationIfNotActivated:(UIButton *)sender {
    [self performSegueWithIdentifier:@"toContactUs" sender:self];
}
- (IBAction)onTapMapBarBtn:(UIBarButtonItem *)sender {

    MapDetailsVC *map=[self.storyboard instantiateViewControllerWithIdentifier:@"MapDetailsVC"];
    map.latDict=@{@"lat":_postDetails[@"latitude"],@"long":_postDetails[@"longitude"],@"address":[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",[_postDetails valueForKey:@"user_street"],[_postDetails valueForKey:@"user_village"],[_postDetails valueForKey:@"user_post_office"],[_postDetails valueForKey:@"user_tehsil"],[_postDetails valueForKey:@"user_district"],[_postDetails valueForKey:@"user_state"],[_postDetails valueForKey:@"user_pin_no"]]};
    [self.navigationController pushViewController:map animated:YES];
    
}
@end
