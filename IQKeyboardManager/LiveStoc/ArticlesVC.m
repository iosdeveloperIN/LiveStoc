//
//  ArticlesVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 1/15/18.
//  Copyright © 2018 Harjit Singh. All rights reserved.
//

#import "ArticlesVC.h"
#import "WebViewVC.h"
@interface ArticlesVC ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL isPagination;
    NSString *catID;
    NSMutableArray *articles,*category;
    NSInteger page;
}
@end

@implementation ArticlesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    catID=@"";
    isPagination=NO;
    page=1;
    _bottomSpaceOfActionPopView.constant=-800;
    _backGroundBtn.hidden=YES;
    _noArticlesLabel.text=AMLocalizedString(@"no_article", @"no_article");
    _noArticlesLabel.hidden=YES;
    
    self.navigationItem.title=AMLocalizedString(@"articles", @"articles");
    [self getArticles];
    [self getCategories];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==123) {
        return category.count;
    } else {
        return articles.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident=@"articles";
    static NSString *identPop=@"popCell";
    
    if (tableView.tag==123) {
        UKTableCell *cellPop=[_popTableVw dequeueReusableCellWithIdentifier:identPop];
        if (!cellPop) {
            cellPop=[[UKTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identPop];
        }
        cellPop.selectionStyle=UITableViewCellSelectionStyleNone;
        cellPop.popUpVwNameLblOfArticlesVC.text=category[indexPath.row][@"category"];
        return cellPop;
        
    } else {
        UKTableCell *cell=[_articlesTblVw dequeueReusableCellWithIdentifier:ident];
        
        if (!cell) {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
            //cell=[[UKTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        NSString *date= [NSString dateToFormatedDateWord:articles[indexPath.row][@"created"]];
        
        //NSLog(@" afbfb=%@ \n\n\n\n\n",articles);
        cell.titleLblOfArticlesVC.text=[NSString stringWithFormat:@"%@",articles[indexPath.row][@"title"]];
        cell.infoLblOfArticlesVC.text=[NSString stringWithFormat:@"%@",articles[indexPath.row][@"sub_texts"]];
        cell.nameLblOfArticlesVC.text=[NSString stringWithFormat:@"%@",articles[indexPath.row][@"author_name"]];
        [cell.articleImgOfArticlesVC sd_setImageWithURL:[NSURL URLWithString:articles[indexPath.row][@"article_image"]] placeholderImage:[UIImage imageNamed:@"p"] options:SDWebImageHighPriority];
        cell.readMoreLblOfArticlesVC.text=AMLocalizedString(@"read_more", @"read_more");
        cell.readMoreLblOfArticlesVC.text=date;
        return cell;
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==123) {
        
        catID=[NSString stringWithFormat:@"%@",category[indexPath.row][@"category_id"]];
        isPagination=NO;
        page=1;
        [self getFilterCategories];
        [self hideAndShow:-800 hideBackground:YES];
        _filterBarButton.title=[NSString stringWithFormat:@"%@",category[indexPath.row][@"category"]];
        
    } else {
        [[UKModel model] setToWebView:ArticleDetail];
        [self performSegueWithIdentifier:@"fromArticles" sender:@{@"title":articles[indexPath.row][@"title"],@"ID":articles[indexPath.row][@"article_id"]}];
    }
}
-( void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    WebViewVC *web=segue.destinationViewController;
    web.articleDetails=sender;
}
-(void)getArticles
{
    if (!isPagination) {
        [DejalBezelActivityView activityViewForView:[[[UIApplication sharedApplication] delegate] window]];
    }
    [UKNetworkManager operationType:POST fromPath:@"article/?" withParameters:@{@"category_id":catID,@"page":[NSString stringWithFormat:@"%ld",(long)page]}.mutableCopy withUploadData:nil :^(id result) {
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            
            if (isPagination) {
                articles=[articles arrayByAddingObjectsFromArray:[[result valueForKey:@"data"] valueForKey:@"category"]].mutableCopy;
                [_articlesTblVw reloadData];
                
            } else {
                articles=[[NSMutableArray alloc] init];
                articles=[[result valueForKey:@"data"] valueForKey:@"category"];
                _articlesTblVw.delegate=self;
                _articlesTblVw.dataSource=self;
                [_articlesTblVw reloadData];
                
            }
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
-(void)getFilterCategories
{
    [DejalBezelActivityView activityViewForView:[[[UIApplication sharedApplication] delegate] window]];
    [UKNetworkManager operationType:POST fromPath:@"article/?" withParameters:@{@"category_id":catID,@"page":[NSString stringWithFormat:@"%ld",(long)page]}.mutableCopy withUploadData:nil :^(id result) {
        
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            
            articles=[[NSMutableArray alloc] init];
            articles=[[result valueForKey:@"data"] valueForKey:@"category"];
            _articlesTblVw.delegate=self;
            _articlesTblVw.dataSource=self;
            [_articlesTblVw reloadData];
            _noArticlesLabel.hidden=YES;
            
        } else {
            articles=[[NSMutableArray alloc] init];
            [_articlesTblVw reloadData];
            _noArticlesLabel.hidden=NO;
            
        }
        [DejalBezelActivityView removeViewAnimated:YES];
        
    } :^(NSError *error, NSString *errorMessage) {
        [DejalBezelActivityView removeViewAnimated:YES];
    }];
}
-(void)getCategories
{
    [UKNetworkManager operationType:POST fromPath:@"article/category" withParameters:@{}.mutableCopy withUploadData:nil :^(id result) {
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            category=[[NSMutableArray alloc] init];
            category=[[[result valueForKey:@"data"] valueForKey:@"category"] mutableCopy];
            [category insertObject:@{@"category_id":@"",@"category":@"All"} atIndex:0];
            _popTableVw.delegate=self;
            _popTableVw.dataSource=self;
            
        } else {
            
        }
    } :^(NSError *error, NSString *errorMessage) {
        
    }];
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

- (IBAction)onTapCancelBtn:(UIButton *)sender {
    [self hideAndShow:-800 hideBackground:YES];
}
- (IBAction)onTapFilterBarButton:(UIBarButtonItem *)sender {
    
    [_articlesTblVw reloadData];
    [self hideAndShow:0 hideBackground:NO];
    
}
-(void)hideAndShow:(NSInteger)value hideBackground:(BOOL)hidden
{
    _bottomSpaceOfActionPopView.constant=value;
    [UIView animateWithDuration:0.3 animations:^{
        _backGroundBtn.hidden=hidden;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}
- (IBAction)onTapBackgroundBtn:(UIButton *)sender {
    [self hideAndShow:-800 hideBackground:YES];
}
@end
