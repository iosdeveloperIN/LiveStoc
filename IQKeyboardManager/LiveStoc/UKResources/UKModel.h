//
//  UKModel.h
//  LiveStoc
//
//  Created by UdayEega on 17/12/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol SearchDelegate<NSObject>
@required
-(void)getPostFromFields:(NSInteger)page;
@end
@interface UKModel : NSObject
typedef enum AnimalSelection : NSUInteger {
    Selected=0,
    NotSelected,
} AnimalSelection;
typedef enum LocationSort : NSUInteger {
    Available=0,
    NotAvailable,
} LocationSort;
typedef enum SortBy : NSUInteger {
    All=0,
    Certified,
    NotCertified,
    Male,
    Female,
} SortBy;
typedef enum Pagination : NSUInteger {
    Yes=0,
    No,
} Pagination;
typedef enum Favaroute : NSUInteger {
    Added=0,
    Removed,
} Favaroute;

typedef enum ToWebView : NSUInteger {
    AboutUs=0,
    PrivacyPolicy,
    TermsServices,
    RefundPolicy,
    ArticleDetail,
} ToWebView;


typedef enum HomeInfo : NSUInteger {
    ChampBulls=0,
    Semen,
    Doctor,
    Advedrtise,
    ListProducts,
    WorkWithUs,
    Brokers,
    Auction,
    Insurance,
    CattleLoan,
} HomeInfo;

@property(strong,nonatomic) NSMutableDictionary *animalSelectionDict;
@property(strong,nonatomic) NSMutableArray *sortingArray;
@property(strong,nonatomic) NSMutableArray *postImages;
@property(nonatomic) CLLocationCoordinate2D location;
@property(strong,nonatomic) NSMutableDictionary *sellAnimalDetails;
@property(strong,nonatomic) NSMutableDictionary *selectedCategory;

@property(strong,nonatomic) NSString *filterCategory;
@property(strong,nonatomic) NSString *searchText;
@property(strong,nonatomic) NSString *minPrice;
@property(strong,nonatomic) NSString *maxPrice;
@property(strong,nonatomic) NSString *currency;
@property(nonatomic) NSInteger cartCount;

@property(strong,nonatomic) id<SearchDelegate> delegate;
@property(nonatomic) BOOL isHomeCell;
@property(nonatomic) AnimalSelection animalSelection;
@property(nonatomic) LocationSort locationSort;
@property(nonatomic) SortBy sortBy;
@property(nonatomic) Pagination pagination;
@property(nonatomic) Favaroute added;
@property(nonatomic) ToWebView toWebView;
@property(nonatomic) HomeInfo homeInfo;

@property(nonatomic) NSInteger pageCount;
-(void)getPosts;
+(UKModel*)model;
@end
