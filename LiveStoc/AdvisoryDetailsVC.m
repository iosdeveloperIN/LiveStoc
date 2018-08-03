//
//  AdvisoryDetailsVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 1/17/18.
//  Copyright © 2018 Harjit Singh. All rights reserved.
//

#import "AdvisoryDetailsVC.h"
#import "IQKeyboardManager.h"
@interface AdvisoryDetailsVC ()<UITableViewDataSource,UITableViewDelegate,InputbarDelegate>
{
    BOOL isPagination;
    NSMutableArray *advisoryComments;
    NSInteger page;
}
@end

@implementation AdvisoryDetailsVC
@synthesize details;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=[NSString stringWithFormat:@"%@ Details",AMLocalizedString(@"advisory", @"advisory")];
    isPagination=NO;
    page=1;
    _commentsTblVw.estimatedRowHeight=100;
    _commentsTblVw.delegate=self;
    _commentsTblVw.dataSource=self;
    [self getAdvisoryDetails];


    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
//    [[IQKeyboardManager sharedManager] settoo];
    

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(inputKeyboardDidShow)
//                                                 name:UIKeyboardDidShowNotification
//                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(inputKeyboardDidHide)
//                                                 name:UIKeyboardDidHideNotification
//                                               object:nil];
    
    [self setInputbar];
    
}

#pragma mark - Keyboard Notifications

- (void)inputKeyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardEndFrameWindow;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardEndFrameWindow];
    
    double keyboardTransitionDuration;
    [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&keyboardTransitionDuration];
    
    UIViewAnimationCurve keyboardTransitionAnimationCurve;
    [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&keyboardTransitionAnimationCurve];
    
    
    _bottomOfToolBar.constant=keyboardEndFrameWindow.size.height;
    [self.commentsTblVw scrollRectToVisible:CGRectMake(0, self.commentsTblVw.contentSize.height - self.commentsTblVw.bounds.size.height, self.commentsTblVw.bounds.size.width, self.commentsTblVw.bounds.size.height) animated:YES];

    [UIView animateWithDuration:keyboardTransitionDuration
                          delay:0.0f
                        options:UIViewAnimationOptionTransitionCurlUp
                     animations:^{
                         
                             [self.view layoutIfNeeded];
                     }
                     completion:^(__unused BOOL finished){
                         
                     }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    // Unregister for keyboard notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    
    // For the sake of 4.X compatibility
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:@"UIKeyboardWillChangeFrameNotification"
//                                                  object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:@"UIKeyboardDidChangeFrameNotification"
//                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
}

- (void)inputKeyboardWillHide:(NSNotification *)notification
{
    CGRect keyboardEndFrameWindow;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardEndFrameWindow];

    double keyboardTransitionDuration;
    [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&keyboardTransitionDuration];

    UIViewAnimationCurve keyboardTransitionAnimationCurve;
    [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&keyboardTransitionAnimationCurve];


    _bottomOfToolBar.constant=10;

    [UIView animateWithDuration:keyboardTransitionDuration
                          delay:0.0f
                        options:UIViewAnimationOptionTransitionCurlDown
                     animations:^{
                         [self.view layoutIfNeeded];

                     }
                     completion:^(__unused BOOL finished){
                         
                     }];
}

-(void)setInputbar
{
    
    self.inputBar.placeholder = AMLocalizedString(@"add_comments", @"add_comments");
    self.inputBar.delegate = self;
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:details[@"image"]] options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        
        self.inputBar.leftButtonImage=image;
        
    }];
    
    self.inputBar.rightButtonText = @"";
    self.inputBar.rightButtonTextColor = [UIColor colorWithRed:0 green:124/255.0 blue:1 alpha:1];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    __weak Inputbar *inputbar = _inputBar;
//    __weak UITableView *tableView = _commentsTblVw;
//    __weak AdvisoryDetailsVC *controller = self;
//
//    self.view.keyboardTriggerOffset = inputbar.frame.size.height;
//    [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
//        /*
//         Try not to call "self" inside this block (retain cycle).
//         But if you do, make sure to remove DAKeyboardControl
//         when you are done with the view controller by calling:
//         [self.view removeKeyboardControl];
//         */
//
//        CGRect toolBarFrame = inputbar.frame;
//        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
//        inputbar.frame = toolBarFrame;
//
//        CGRect tableViewFrame = tableView.frame;
//        tableViewFrame.size.height = toolBarFrame.origin.y - 64;
//        tableView.frame = tableViewFrame;
//
//        [controller tableViewScrollToBottomAnimated:NO];
//    }];
}
- (void)tableViewScrollToBottomAnimated:(BOOL)animated
{
    NSInteger numberOfRows = advisoryComments.count;
    if (numberOfRows)
    {
        [_commentsTblVw scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:advisoryComments.count-1 inSection:0]
                          atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}
-(void)inputbarDidChangeHeight:(CGFloat)new_height
{
    //Update DAKeyboardControl
    _heightOfToolBar.constant=new_height;
//    self.view.keyboardTriggerOffset = new_height;
}

-(void)inputbarDidPressRightButton:(Inputbar *)inputbar
{
    if (_inputBar.text.length>0) {
        [self postNewComment:_inputBar.text];
    } else {
        [self.view makeToast:AMLocalizedString(@"COMPLETE_ALL_FIELDS", nil) duration:1.5 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-80)]];
    }
}
-(void)inputbarDidPressLeftButton:(Inputbar *)inputbar
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return advisoryComments.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident=@"commentsCell";
    
    UKTableCell *cell=[_commentsTblVw dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell=[[UKTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell.commentsIconImgVwOfAdvisoryDetailsVC sd_setImageWithURL:[NSURL URLWithString:advisoryComments[indexPath.row][@"image"]] placeholderImage:[UIImage imageNamed:@"p"] options:SDWebImageHighPriority];
    cell.nameLabelOfAdvisoryDetailsVC.text=[NSString stringWithFormat:@"%@", advisoryComments[indexPath.row][@"fullname"]];
    cell.commenDetailOfAdvisoryDetailsVC.text=[NSString stringWithFormat:@"%@", advisoryComments[indexPath.row][@"description"]];
    cell.dateOfAdvisoryDetailsVC.text=[NSString stringWithFormat:@"%@", advisoryComments[indexPath.row][@"created"]];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_inputBar resignFirstResponder];

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UKTableCell *headerView = [_commentsTblVw dequeueReusableCellWithIdentifier:@"section"];
    if (headerView ==nil)
    {
        
        headerView=[[UKTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headerCell"];
        
    }
    
    [headerView.iconImageVwOfAdvisoryDetailsVC sd_setImageWithURL:[NSURL URLWithString:details[@"image"]] placeholderImage:[UIImage imageNamed:@"p"] options:SDWebImageHighPriority];
    [headerView.fullImageVwOfAdvisoryDetailsVC sd_setImageWithURL:[NSURL URLWithString:details[@"images"]] placeholderImage:[UIImage imageNamed:@"p"] options:SDWebImageHighPriority];
    headerView.questionLabelOfAdvisoryDetailsVC.text=[NSString stringWithFormat:@"%@",details[@"title"]];
    headerView.nameForDetailsLabelOfAdvisoryDetailsVC.text=[NSString stringWithFormat:@"%@",details[@"fullname"]];
    headerView.commentsLabelOfAdvisoryDetailsVC.text=[NSString stringWithFormat:@"Comments(%@)",details[@"total_comments"]];
    headerView.dateForDetailsOfAdvisoryDetailsVC.text=[NSString stringWithFormat:@"%@",details[@"created"]];

    return headerView.contentView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if ([details[@"images"] containsString:@"no_uploaded"]) {
        
        return 170;

    } else {
        
        return self.view.frame.size.height*0.4;
        
    }
    
}
-(void)getAdvisoryDetails
{
    if (!isPagination) {
        [DejalBezelActivityView activityViewForView:[[[UIApplication sharedApplication] delegate] window]];
    }
    [UKNetworkManager operationType:POST fromPath:@"advisory/view_comment" withParameters:@{@"page":[NSString stringWithFormat:@"%ld",(long)page],@"advisory_qus_id":details[@"advisory_qus_id"]}.mutableCopy withUploadData:nil :^(id result) {
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            
            if (isPagination) {
                advisoryComments=[advisoryComments arrayByAddingObjectsFromArray:[[result valueForKey:@"data"] valueForKey:@"comments"]].mutableCopy;
                [_commentsTblVw reloadData];
                
            } else {
                advisoryComments=[[NSMutableArray alloc] init];
                advisoryComments=[[result valueForKey:@"data"] valueForKey:@"comments"];
                _commentsTblVw.delegate=self;
                _commentsTblVw.dataSource=self;
                [_commentsTblVw reloadData];
                
            }
        } else {
            if (isPagination) {
                isPagination=NO;
                page=page-1;
            } else {
//                [UKNetworkManager showAlertWithTitle:[result valueForKey:@"data"] messageTitle:nil okTitle:nil cancelTitle:AMLocalizedString(@"ok", @"ok") otherTitles:nil];
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
    if (advisoryComments.count-1 == indexPath.row) {
        
        isPagination=YES;
        page=page+1;
        [self getAdvisoryDetails];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}


-(void)postNewComment:(NSString *)comments
{
    [DejalBezelActivityView activityViewForView:[[[UIApplication sharedApplication] delegate] window]];
    
    [UKNetworkManager operationType:POST fromPath:@"advisory/add_comment" withParameters:@{@"users_id":[UKNetworkManager getFromDefaultsWithKeyString:USER_ID],@"submit":@"Go",@"advisory_qus_id":details[@"advisory_qus_id"],@"description":comments}.mutableCopy withUploadData:nil :^(id result) {
        
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            
            [advisoryComments addObject:[result valueForKey:@"return"]];
            [_commentsTblVw reloadData];
            [[[[UIApplication sharedApplication] delegate] window] makeToast:[result valueForKey:@"data"] duration:3.0 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-80)]];
            [self tableViewScrollToBottomAnimated:NO];


        } else {
            
            [UKNetworkManager showAlertWithTitle:AMLocalizedString(@"error", nil) messageTitle:AMLocalizedString(@"try_again", nil) okTitle:nil cancelTitle:AMLocalizedString(@"ok", @"ok") otherTitles:nil];
        }
        [DejalBezelActivityView removeViewAnimated:YES];
        
    } :^(NSError *error, NSString *errorMessage) {
        [DejalBezelActivityView removeViewAnimated:YES];
        [UKNetworkManager showAlertWithTitle:errorMessage messageTitle:nil okTitle:nil cancelTitle:AMLocalizedString(@"ok", @"ok") otherTitles:nil];
        
    }];
}
@end
