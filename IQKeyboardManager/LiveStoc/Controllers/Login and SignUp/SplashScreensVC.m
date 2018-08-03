//
//  SplashScreensVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 11/21/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import "SplashScreensVC.h"
#import "LoginVC.h"

@interface SplashScreensVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableDictionary *splashDict;
    NSTimer *timerForSplash;
    NSInteger index;
}
@end

@implementation SplashScreensVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//    
//    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
//        
//        statusBar.backgroundColor = [UIColor whiteColor];
//    }
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];

    splashDict=[[NSMutableDictionary alloc] init];
    splashDict=@{@"images":@[@"first",@"second",@"third",@"fourth",@"fifth"].mutableCopy,@"names":@[@"first_sp",@"second_sp",@"third_sp",@"fourth_sp",@"fifth_sp"].mutableCopy}.mutableCopy;
    
    self.welComeLabel.text=AMLocalizedString(@"welcome", nil);
    [_skipBtn setTitle:AMLocalizedString(@"skip", @"") forState:UIControlStateNormal];
    self.splashCollVw.delegate=self;
    self.splashCollVw.dataSource=self;
    
    timerForSplash=[NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(scrollToRowAtIndexPath) userInfo:nil repeats:YES];
    index=0;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=YES;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[splashDict valueForKey:@"images"] count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ident=@"splash";
    UKCollectionCell *cell=[self.splashCollVw dequeueReusableCellWithReuseIdentifier:ident forIndexPath:indexPath];
    
    cell.imgVwOfSplashScreenVC.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[[splashDict valueForKey:@"images"] objectAtIndex:indexPath.row]]];
    
    cell.detailLblOfSplashScreenVC.text=[NSString stringWithFormat:@"%@",AMLocalizedString([[splashDict valueForKey:@"names"] objectAtIndex:indexPath.row], nil)];
    //cell.detailLblOfSplashScreenVC.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row];

    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath

{
    return CGSizeMake(self.splashCollVw.frame.size.width, self.splashCollVw.frame.size.height);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    self.pageControll.currentPage = self.splashCollVw.contentOffset.x / self.splashCollVw.frame.size.width;
}

-(void)scrollToRowAtIndexPath {
    
    
    CGFloat pageWidth = self.splashCollVw.frame.size.width;
    int currentPage = self.splashCollVw.contentOffset.x / pageWidth;
    int nextPage = currentPage + 1;
    
    
    if (nextPage==[[splashDict valueForKey:@"images"] count]) {
        
                [timerForSplash invalidate];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"LOGGEDIN"])
        {
            [[[UIApplication sharedApplication] keyWindow] setRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"tabBar"]];
            
        } else {
            [self performSegueWithIdentifier:@"goToLogin" sender:self];
            
        }

    } else {
        
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [self.splashCollVw setContentOffset:CGPointMake(pageWidth * nextPage - 1, 0)];
                             self.pageControll.currentPage=nextPage;

                         } completion:^(BOOL finished) {
                             [self.splashCollVw setContentOffset:CGPointMake(pageWidth * nextPage, 0)];

                         }];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (IBAction)onTapSkipBtn:(UIButton *)sender {
    
    [timerForSplash invalidate];

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"LOGGEDIN"])
    {
        [[[UIApplication sharedApplication] keyWindow] setRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"tabBar"]];
        
    } else {
        [self performSegueWithIdentifier:@"goToLogin" sender:self];

    }
    
}
@end
