//
//  HomeVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 11/23/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import "HomeVC.h"
#import "SearchVC.h"
#import "ShopVC.h"
#import "MyListingVC.h"
#import "MyProfileVC.h"
#import "MoreVC.h"
#import "LoginVC.h"
#import <AVFoundation/AVFoundation.h>
#import "LanguageAndCountryVC.h"
#import "ArticlesVC.h"
#import "AdvisoryVC.h"
#import <math.h>
#import "CertificationVC.h"
#import "ConsultancyVC.h"
#import "WebViewVC.h"
#import "SelectCategoryVC.h"
#import "SelectSellCategoryVC.h"


@import GameplayKit;
@interface HomeVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableDictionary *hmeInfoDict,*flowLayoutDict;
    UITabBarController *tabbar;
    SearchVC *search;
    ShopVC *shop;
    MyListingVC *myListing;
    MoreVC *more;
    UKModel *model;
    AVPlayerLayer *videoLayer;
    UIView *playView;
    NSMutableArray *articles,*category;
    BOOL isPagination;
    NSInteger page;
    NSString *catID;
}
@property (nonatomic) AVPlayer *avPlayer;

@end

@implementation HomeVC
-(void)getArticles
{
    if (!isPagination) {
        [DejalBezelActivityView activityViewForView:[[[UIApplication sharedApplication] delegate] window]];
    }
    [UKNetworkManager operationType:POST fromPath:@"article/?" withParameters:@{@"category_id":catID,@"page":[NSString stringWithFormat:@"%ld",(long)page]}.mutableCopy withUploadData:nil :^(id result) {
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            
            if (isPagination) {
                articles=[articles arrayByAddingObjectsFromArray:[[result valueForKey:@"data"] valueForKey:@"category"]].mutableCopy;
                [self.hmeTblVw reloadData];
                
            } else {
                articles=[[NSMutableArray alloc] init];
                articles=[[result valueForKey:@"data"] valueForKey:@"category"];
                self.hmeTblVw.delegate=self;
                self.hmeTblVw.dataSource=self;
               // self.hmeTblVw.rowHeight=150;
                //self.hmeTblVw.estimatedRowHeight=150;
                [self.hmeTblVw reloadData];
                
            }
            
            CGFloat tableHeight=0;
            
            
            for (int i=0; i<[articles count]; i++) {
                
                tableHeight=tableHeight+[_hmeTblVw rectForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]].size.height;
                
            }
            
            _heightOfTblVw.constant=tableHeight;
            
        } else {
            isPagination=NO;
            page=page-1;
        }
        [DejalBezelActivityView removeViewAnimated:YES];
        
    } :^(NSError *error, NSString *errorMessage) {
        [DejalBezelActivityView removeViewAnimated:YES];
        isPagination=NO;
        page=page-1;
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"REGISTER_DETAILS"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FIRST_STEP"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    hmeInfoDict=[[NSMutableDictionary alloc] init];

    model=[[UKModel alloc] init]; hmeInfoDict=@{@"title":@[@"post_animal",@"buy",@"certification_animal",@"advisory_animal",@"article_animal"].mutableCopy,@"info":@[@"post_msg",@"buy_msg",@"certification_msg",@"advisory_msg",@"article_msg"].mutableCopy,@"images":@[@"thumb1",@"thumb1",@"thumb2",@"thumb3",@"thumb4"].mutableCopy}.mutableCopy;

    
    tabbar=[self.storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
    search=[self.storyboard instantiateViewControllerWithIdentifier:@"searchNav"];
    shop=[self.storyboard instantiateViewControllerWithIdentifier:@"shopNav"];
    myListing=[self.storyboard instantiateViewControllerWithIdentifier:@"myListingNav"];
    more=[self.storyboard instantiateViewControllerWithIdentifier:@"moreNav"];
    
    search.tabBarItem.title=AMLocalizedString(@"tab1", @"tab1");
    
    self.homeSegment.layer.borderColor = [UIColor whiteColor].CGColor;
    self.homeSegment.layer.borderWidth = 2.0f;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:16], NSFontAttributeName,[UIColor whiteColor], NSForegroundColorAttributeName,nil];
    
    
    [self.homeSegment setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:16], NSFontAttributeName,[UIColor blackColor], NSForegroundColorAttributeName,nil];
    
    [self.homeSegment setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    
    [self forLanguageChange];
    
    catID=@"";
    isPagination=NO;
    page=1;
     [self getArticles];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forLanguageChange) name:@"LANGCHANGED" object:nil];
    
}
-(void)itemDidFinishPlaying:(NSNotification *) notification {

    playView.hidden=YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)getCartCount
{
    [UKNetworkManager operationType:POST fromPath:@"cart/index" withParameters:@{@"user_id":[UKNetworkManager getFromDefaultsWithKeyString:USER_ID]}.mutableCopy withUploadData:nil :^(id result) {
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            
            [[UKModel model] setCartCount:[result[@"data"][@"total"] integerValue]];
     
        } else {
            
        }
        
    } :^(NSError *error, NSString *errorMessage) {
        
    }];
}

-(void)forLanguageChange
{
    
    flowLayoutDict=[[NSMutableDictionary alloc] init];
    flowLayoutDict=@{@"names":@[AMLocalizedString(@"buy", @"BUY"),AMLocalizedString(@"sell", @"SELL"),AMLocalizedString(@"certification", @"CERTIFICATIONS"),AMLocalizedString(@"", @"CHAMPION BULLS"),AMLocalizedString(@"", @"SEMEN"),AMLocalizedString(@"", @"CONSULTANCY"),AMLocalizedString(@"discussionforum", @"DISCUSSION FORUM"),AMLocalizedString(@"", @"NEWS & ARTICLES"),AMLocalizedString(@"", @"SHOPPING"),AMLocalizedString(@"", @"DOCTOR ON CALL"),AMLocalizedString(@"aiworkers", @"AI WORKERS"),AMLocalizedString(@"advertisewithus", @"ADVERTISE WITH US"),AMLocalizedString(@"", @"LIST YOUR PRODUCT FOR SHOPPING"),AMLocalizedString(@"", @"WORK WITH US"),AMLocalizedString(@"", @"DEALERS"),AMLocalizedString(@"", @"AUCTION"),AMLocalizedString(@"", @"INSURANCE"),AMLocalizedString(@"", @"CATTLE LOAN"),].mutableCopy,@"items":@[@"3",@"3",@"3",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"1",@"1",@"1",@"2",@"2",@"2",@"2",].mutableCopy}.mutableCopy;
    
    [[self.tabBarController.tabBar.items objectAtIndex:0] setTitle:AMLocalizedString(@"home", @"home")];
    [[self.tabBarController.tabBar.items objectAtIndex:1] setTitle:AMLocalizedString(@"tab2", @"tab2")];
    [[self.tabBarController.tabBar.items objectAtIndex:2] setTitle:AMLocalizedString(@"tab3", @"tab3")];
    [[self.tabBarController.tabBar.items objectAtIndex:3] setTitle:AMLocalizedString(@"tab4", @"tab4")];

    _fairTitleLabel.text=AMLocalizedString(@"livestoc_fair", nil);
    self.hmeTblVw.delegate=self;
    self.hmeTblVw.dataSource=self;

    [self.hmeTblVw reloadData];
    
  
    _collVw.delegate=self;
    _collVw.dataSource=self;
    [_collVw reloadData];
    
    CGFloat collHeight=0;
    
    collHeight=(self.view.frame.size.height*0.07)*10;
    _heightOfCollVw.constant=collHeight+10;
    
    [_homeSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [self.view layoutIfNeeded];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[UKModel model] setIsHomeCell:YES];
    [self getCartCount];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [[UKModel model] setIsHomeCell:NO];

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
  
    
    return [flowLayoutDict[@"names"] count];
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UKCollectionCell *cell=[_collVw dequeueReusableCellWithReuseIdentifier:@"cell2" forIndexPath:indexPath];
    
    cell.nameLbl.text=flowLayoutDict[@"names"][indexPath.row];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0:
//            self.tabBarController.viewControllers=@[search,shop,myListing,more];
//
//            break;
        {
            UIStoryboard *sellStoryBoard= [UIStoryboard storyboardWithName:@"Sell" bundle:nil];
            
            SelectSellCategoryVC *lSelectCategoryVC=[sellStoryBoard instantiateViewControllerWithIdentifier:@"SelectSellCategoryVC"];
            NSLog(@"%@",self.navigationController);
            lSelectCategoryVC.isSellCatagory=true;
            [self.navigationController pushViewController:lSelectCategoryVC animated:YES];
            break;
        }
            
        case 1:
//            self.tabBarController.hidesBottomBarWhenPushed=YES;
//            [self performSegueWithIdentifier:@"sellSegue" sender:self];
//            break;
      
        {
            UIStoryboard *sellStoryBoard= [UIStoryboard storyboardWithName:@"Sell" bundle:nil];
            
            SelectCategoryVC *lSelectCategoryVC=[sellStoryBoard instantiateViewControllerWithIdentifier:@"SelectCategoryVC"];
      NSLog(@"%@",self.navigationController);
            [self.navigationController pushViewController:lSelectCategoryVC animated:YES];
            break;
        }
            
        case 2:
        {
            CertificationVC *advisory=[self.storyboard instantiateViewControllerWithIdentifier:@"CertificationVC"];
            [self.navigationController presentViewController:advisory animated:YES completion:nil];
            break;
        }
        case 3:
        {
            AllInfoVC *info=[self.storyboard instantiateViewControllerWithIdentifier:@"AllInfoVC"];
            [[UKModel model] setHomeInfo:ChampBulls];
            [self.navigationController presentViewController:info animated:YES completion:nil];
            break;
        }
        case 4:
        {
            AllInfoVC *info=[self.storyboard instantiateViewControllerWithIdentifier:@"AllInfoVC"];
            [[UKModel model] setHomeInfo:Semen];

            [self.navigationController presentViewController:info animated:YES completion:nil];
            break;
        }
        case 5:
        {
            ConsultancyVC *advisory=[self.storyboard instantiateViewControllerWithIdentifier:@"ConsultancyVC"];
            [self.navigationController presentViewController:advisory animated:YES completion:nil];
            break;
        }
        case 6:
        {
            AdvisoryVC *advisory=[self.storyboard instantiateViewControllerWithIdentifier:@"AdvisoryVC"];
            [self.navigationController pushViewController:advisory animated:YES];
        
            break;
        }
        case 7:
        {
            ArticlesVC *Articles=[self.storyboard instantiateViewControllerWithIdentifier:@"ArticlesVC"];
            [self.navigationController pushViewController:Articles animated:YES];
            
            break;
        }
        case 8:
        {
           
            break;
        }
        case 9:
        {
            AllInfoVC *info=[self.storyboard instantiateViewControllerWithIdentifier:@"AllInfoVC"];
            [[UKModel model] setHomeInfo:Doctor];
            [self.navigationController presentViewController:info animated:YES completion:nil];
            break;
        }
        case 11:
        {
            AllInfoVC *info=[self.storyboard instantiateViewControllerWithIdentifier:@"AllInfoVC"];
            [[UKModel model] setHomeInfo:Advedrtise];
            [self.navigationController presentViewController:info animated:YES completion:nil];
            break;
        }
        case 10:
        {
            self.tabBarController.hidesBottomBarWhenPushed=YES;
            [self performSegueWithIdentifier:@"sellSegue" sender:self];
            break;
        }
        case 12:
        {
            AllInfoVC *info=[self.storyboard instantiateViewControllerWithIdentifier:@"AllInfoVC"];
            [[UKModel model] setHomeInfo:ListProducts];

            [self.navigationController presentViewController:info animated:YES completion:nil];
            break;
        }
        case 13:
        {
            AllInfoVC *info=[self.storyboard instantiateViewControllerWithIdentifier:@"AllInfoVC"];
            [[UKModel model] setHomeInfo:WorkWithUs];

            [self.navigationController presentViewController:info animated:YES completion:nil];
            break;
        }
        case 14:
        {
            AllInfoVC *info=[self.storyboard instantiateViewControllerWithIdentifier:@"AllInfoVC"];
            [[UKModel model] setHomeInfo:Brokers];

            [self.navigationController presentViewController:info animated:YES completion:nil];
            break;
        }
        case 15:
        {
            AllInfoVC *info=[self.storyboard instantiateViewControllerWithIdentifier:@"AllInfoVC"];
            [[UKModel model] setHomeInfo:Auction];

            [self.navigationController presentViewController:info animated:YES completion:nil];
            break;
        }
        case 16:
        {
            AllInfoVC *info=[self.storyboard instantiateViewControllerWithIdentifier:@"AllInfoVC"];
            [[UKModel model] setHomeInfo:Insurance];

            [self.navigationController presentViewController:info animated:YES completion:nil];
            break;
        }
        default:
            
        {
            
            AllInfoVC *info=[self.storyboard instantiateViewControllerWithIdentifier:@"AllInfoVC"];
            [[UKModel model] setHomeInfo:CattleLoan];
            [self.navigationController presentViewController:info animated:YES completion:nil];
            
        }
            break;
    }
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

//    switch ([flowLayoutDict[@"items"][indexPath.row] integerValue]) {
//        case 1:
//
//            return CGSizeMake(_collVw.frame.size.width/[flowLayoutDict[@"items"][indexPath.row] integerValue], self.view.frame.size.height*0.06);
//
//            break;
//        case 2:
//
//            return CGSizeMake(_collVw.frame.size.width/[flowLayoutDict[@"items"][indexPath.row] integerValue], self.view.frame.size.height*0.06);
//
//            break;
//        default:
//
//            return CGSizeMake( [self getLabelWidth:flowLayoutDict[@"names"][indexPath.row]]+10, self.view.frame.size.height*0.06);
//
//            break;
//    }
    if (indexPath.row<3) {
        
        if (indexPath.row==2) {
            
            return CGSizeMake(_collVw.frame.size.width/2, self.view.frame.size.height*0.07);

        } else {
            
            return CGSizeMake(_collVw.frame.size.width/4, self.view.frame.size.height*0.07);
        }
        
    } else {
        
        return CGSizeMake(_collVw.frame.size.width/[flowLayoutDict[@"items"][indexPath.row] integerValue], self.view.frame.size.height*0.07);

    }

}


- (CGFloat)getLabelWidth:(NSString *)str
{
    CGSize constraint = CGSizeMake(CGFLOAT_MAX,self.view.frame.size.height*0.06);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [str boundingRectWithSize:constraint
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}
                                           context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.width;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return articles.count;
   // return [[hmeInfoDict valueForKey:@"title"] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
      static NSString *ident=@"articles";
    
//    static NSString *ident=@"homeCell";
//
//    UKTableCell *cell=[self.hmeTblVw dequeueReusableCellWithIdentifier:ident];
//    if (cell==nil) {
//        cell=[[UKTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
//    }
//    cell.tag=9849;
//    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//    cell.titleLblOfHmeVC.text=AMLocalizedString([[hmeInfoDict valueForKey:@"title"] objectAtIndex:indexPath.row], nil);
//    cell.infoLblOfHmeVC.text=AMLocalizedString([[hmeInfoDict valueForKey:@"info"] objectAtIndex:indexPath.row], nil);
//    cell.imgVwOfHmeVC.image=[UIImage imageNamed:[[hmeInfoDict valueForKey:@"images"] objectAtIndex:indexPath.row]];
    
    UKTableCell *cell=[_hmeTblVw dequeueReusableCellWithIdentifier:ident];
    
    if (!cell) {
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
        //cell=[[UKTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    NSString *date= [NSString dateToFormatedDateWord:articles[indexPath.row][@"created"]];
    
   
    cell.titleLblOfArticlesVC.text=[NSString stringWithFormat:@"%@",articles[indexPath.row][@"title"]];
    cell.infoLblOfArticlesVC.text=[NSString stringWithFormat:@"%@",articles[indexPath.row][@"sub_texts"]];
    cell.nameLblOfArticlesVC.text=[NSString stringWithFormat:@"%@",articles[indexPath.row][@"author_name"]];
    [cell.articleImgOfArticlesVC sd_setImageWithURL:[NSURL URLWithString:articles[indexPath.row][@"article_image"]] placeholderImage:[UIImage imageNamed:@"p"] options:SDWebImageHighPriority];
    cell.readMoreLblOfArticlesVC.text=AMLocalizedString(@"read_more", @"read_more");
    cell.readMoreLblOfArticlesVC.text=date;
    return cell;
    
  
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag!=123) {
        
        if (articles.count-1 == indexPath.row) {
            
            isPagination=YES;
            page=page+1;
            [self getArticles];
        }
    }
}
-( void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    WebViewVC *web=segue.destinationViewController;
    web.articleDetails=sender;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    
            [[UKModel model] setToWebView:ArticleDetail];
            [self performSegueWithIdentifier:@"fromArticles" sender:@{@"title":articles[indexPath.row][@"title"],@"ID":articles[indexPath.row][@"article_id"]}];
        

//    if (indexPath.row==0) {
//        self.tabBarController.hidesBottomBarWhenPushed=YES;
//        [self performSegueWithIdentifier:@"sellSegue" sender:self];
//    }
//    if (indexPath.row==1) {
//        self.tabBarController.viewControllers=@[search,shop,myListing,more];
//    }
//    if (indexPath.row==2) {
//        [self.tabBarController setSelectedIndex:2];
//    }
//    if (indexPath.row==3) {
//        AdvisoryVC *advisory=[self.storyboard instantiateViewControllerWithIdentifier:@"AdvisoryVC"];
//        [self.navigationController pushViewController:advisory animated:YES];
//    }
//    if (indexPath.row==4) {
//        ArticlesVC *Articles=[self.storyboard instantiateViewControllerWithIdentifier:@"ArticlesVC"];
//        [self.navigationController pushViewController:Articles animated:YES];
//    }
}


//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return self.view.frame.size.height*0.15;
//}
- (IBAction)onTapSegment:(UISegmentedControl *)sender {
    
    
    
    if (sender.selectedSegmentIndex==0) {
        
        
        self.tabBarController.viewControllers=@[search,shop,myListing,more];
        
//        tabbar.viewControllers=@[search,shop,myListing,more];
//        tabbar.navigationController.navigationBarHidden=YES;
//        [self.navigationController pushViewController:tabbar animated:YES];
//        [self.navigationController presentViewController:tabbar animated:YES completion:nil];

    } else if (sender.selectedSegmentIndex==1) {
        self.tabBarController.hidesBottomBarWhenPushed=YES;
        [self performSegueWithIdentifier:@"sellSegue" sender:self];
    } else{
        
        [self.tabBarController setSelectedIndex:2];
    }
    
    [_homeSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
}

- (IBAction)onTapMenuBarBtn:(UIBarButtonItem *)sender {

    UIAlertController * alert=[UIAlertController
                               
                               alertControllerWithTitle:AMLocalizedString(@"text_select", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* logout = [UIAlertAction
                                actionWithTitle:AMLocalizedString(@"logout", nil)
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                    
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:AMLocalizedString(@"logout", nil) message:AMLocalizedString(@"logout_msg", nil) preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:AMLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                        

                                    }];
     
    UIAlertAction *logoutAction=[UIAlertAction actionWithTitle:AMLocalizedString(@"logout", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                        if ([FBSDKAccessToken currentAccessToken]) {
                                            
                                            FBSDKLoginManager *logout=[[FBSDKLoginManager alloc] init];
                                            [logout logOut];
                                        }
                                        if ([[GIDSignIn sharedInstance] hasAuthInKeychain]) {
                                            
                                            [[GIDSignIn sharedInstance] signOut];
                                        }
                                        
                                        LoginVC *login=[self.storyboard instantiateViewControllerWithIdentifier:@"loginNav"];
        
            [[SDImageCache sharedImageCache]clearMemory];
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
        
                                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LOGGEDIN"];
                                        [[NSUserDefaults standardUserDefaults] synchronize];
//                                        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//                                        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
//                                        [[NSUserDefaults  standardUserDefaults]synchronize];
                                        [[[UIApplication sharedApplication] keyWindow] setRootViewController:login];
                                        
                                    }];
                                    
                                    [alert addAction:cancelAction];
                                    [alert addAction:logoutAction];
                                    [self presentViewController:alert animated:YES completion:nil];
                                    
                                    
                                    
                                }];
    UIAlertAction*profile  = [UIAlertAction
                               actionWithTitle:AMLocalizedString(@"profile", nil)
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                    MyProfileVC *profile=[self.storyboard instantiateViewControllerWithIdentifier:@"MyProfileVC"];
                    [self.navigationController pushViewController:profile animated:YES];
                                   
                               }];
    UIAlertAction* changeLang = [UIAlertAction
                               actionWithTitle:AMLocalizedString(@"change_lang", nil)
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   LanguageAndCountryVC *lang=[self.storyboard instantiateViewControllerWithIdentifier:@"LanguageAndCountryVC"];
                                   lang.isFromOther=YES;
                                   [self.navigationController presentViewController:lang animated:YES completion:nil];
                                   
                               }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:AMLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    [alert addAction:logout];
    [alert addAction:profile];
    [alert addAction:changeLang];
    [alert addAction:cancelAction];

    [self presentViewController:alert animated:YES completion:nil];
    
}
- (IBAction)onTapBackBarButton:(UIBarButtonItem *)sender {
}
@end
