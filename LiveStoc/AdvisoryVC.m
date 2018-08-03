//
//  AdvisoryVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 1/15/18.
//  Copyright © 2018 Harjit Singh. All rights reserved.
//

#import "AdvisoryVC.h"
#import "AddNewAdvisoryPopUp.h"
#import "AdvisoryDetailsVC.h"
@interface AdvisoryVC ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL isPagination;
    NSMutableArray *advisoryArr;
    NSInteger page;
}
@end

@implementation AdvisoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=AMLocalizedString(@"advisory", @"advisory");
    isPagination=NO;
    page=1;
    _advisoryTblVw.estimatedRowHeight=100;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getAdvisory];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return advisoryArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident=@"advisory";
    
    UKTableCell *cell=[_advisoryTblVw dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell=[[UKTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell.iconImgVwOfAdvisoryVC sd_setImageWithURL:[NSURL URLWithString:advisoryArr[indexPath.row][@"image"]] placeholderImage:[UIImage imageNamed:@"p"] options:SDWebImageHighPriority];
    cell.questionLblOfAdvisoryVC.text=[NSString stringWithFormat:@"%@",advisoryArr[indexPath.row][@"title"]];
    cell.nameLblOfAdvisoryVC.text=[NSString stringWithFormat:@"%@",advisoryArr[indexPath.row][@"fullname"]];
    cell.commentsCountsOfAdvisoryVC.text=[NSString stringWithFormat:@"Comments(%@)",advisoryArr[indexPath.row][@"total_comments"]];
    cell.dateLblOfAdvisoryVC.text=[NSString stringWithFormat:@"%@",advisoryArr[indexPath.row][@"created"]];
    [cell.mainImgVwOfAdvisoryVC sd_setImageWithURL:[NSURL URLWithString:advisoryArr[indexPath.row][@"images"]] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageHighPriority];
    
    if ([advisoryArr[indexPath.row][@"images"] containsString:@"no_uploaded"]) {
        
        cell.mainImgVwOfAdvisoryVC.hidden=YES;
    } else {
        
        cell.mainImgVwOfAdvisoryVC.hidden=NO;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AdvisoryDetailsVC *details=[self.storyboard instantiateViewControllerWithIdentifier:@"AdvisoryDetailsVC"];
    details.details=advisoryArr[indexPath.row];
    [self.navigationController pushViewController:details animated:YES];
}

- (IBAction)onTapAddNewQuestionBtn:(UIButton *)sender {
    
    AddNewAdvisoryPopUp *pop=[self.storyboard instantiateViewControllerWithIdentifier:@"AddNewAdvisoryPopUp"];
    [self.navigationController presentViewController:pop animated:YES completion:nil];
}

-(void)getAdvisory
{
    if (!isPagination) {
        [DejalBezelActivityView activityViewForView:[[[UIApplication sharedApplication] delegate] window]];
    }
    [UKNetworkManager operationType:POST fromPath:@"advisory/?" withParameters:@{@"page":[NSString stringWithFormat:@"%ld",(long)page]}.mutableCopy withUploadData:nil :^(id result) {
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            
            if (isPagination) {
                advisoryArr=[advisoryArr arrayByAddingObjectsFromArray:[[result valueForKey:@"data"] valueForKey:@"advisory"]].mutableCopy;
                [_advisoryTblVw reloadData];
                
            } else {
                advisoryArr=[[NSMutableArray alloc] init];
                advisoryArr=[[result valueForKey:@"data"] valueForKey:@"advisory"];
                _advisoryTblVw.delegate=self;
                _advisoryTblVw.dataSource=self;
                [_advisoryTblVw reloadData];
            }
        } else {
            if (isPagination) {
            isPagination=NO;
            page=page-1;
            } else {
                [UKNetworkManager showAlertWithTitle:[result valueForKey:@"message"] messageTitle:nil okTitle:nil cancelTitle:AMLocalizedString(@"ok", @"ok") otherTitles:nil];
            }
        }
        [DejalBezelActivityView removeViewAnimated:YES];
        
    } :^(NSError *error, NSString *errorMessage) {
        [DejalBezelActivityView removeViewAnimated:YES];
        if (isPagination) {
        isPagination=NO;
        page=page-1;
        } else {
            [UKNetworkManager showAlertWithTitle:errorMessage messageTitle:nil okTitle:nil cancelTitle:AMLocalizedString(@"ok", @"ok") otherTitles:nil];
        }
    }];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (advisoryArr.count-1 == indexPath.row) {
            
        isPagination=YES;
        page=page+1;
        [self getAdvisory];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([advisoryArr[indexPath.row][@"images"] containsString:@"no_uploaded"]) {
        
        return 180;
        
    } else {
        
        return self.view.frame.size.height*0.4;
        
    }
}
@end
