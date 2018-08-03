//
//  UKModel.m
//  LiveStoc
//
//  Created by UdayEega on 17/12/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import "UKModel.h"

@implementation UKModel


static UKModel *instance = nil;

+(UKModel*)model
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance)
        {
            instance= [UKModel new];
            instance.delegate=nil;
        instance.animalSelectionDict=@{@"breed_id":@"",@"min_price":@"",@"max_price":@"",@"category_id":@"",@"radius":@""}.mutableCopy;;
            //_location=CLLocationCoordinate2DMake(0.0, 0.0);
            instance.sellAnimalDetails=[NSMutableDictionary dictionary];
            instance.selectedCategory=[NSMutableDictionary dictionary];
            instance.postImages=[NSMutableArray array];
            instance.animalSelection=NotSelected;
            instance.locationSort=NotAvailable;
            instance.added=Removed;
            instance.pagination=No;
            instance.sortBy=All;
            instance.toWebView=AboutUs;
            instance.pageCount=1;
            instance.sortingArray=@[@"all",@"certified",@"not_certified",@"male",@"female"].mutableCopy;
            instance.filterCategory=@"";
            instance.searchText=@"";
            instance.minPrice=@"";
            instance.maxPrice=@"";
        }

    });
    return instance;
}

-(void)getPosts
{
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(getPostFromFields:)])
        {
            [_delegate getPostFromFields:_pageCount];
        }
    }
}
@end
