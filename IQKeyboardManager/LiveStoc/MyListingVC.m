//
//  MyListingVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 11/24/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import "MyListingVC.h"

@interface MyListingVC ()<UIScrollViewDelegate,UIPageViewControllerDelegate,UIPageViewControllerDataSource>
{
    NSMutableArray *controllers,*controllersArr,*leftBarButtons;
    NSMutableDictionary *dict;
    float contentOffSet,store;
    NSInteger sek;
    JSBadgeView *badgeView;

}
@property(strong,nonatomic) UIButton *customButton;
@end

@implementation MyListingVC



- (void)viewDidLoad {
    [super viewDidLoad];

    dict=[[NSMutableDictionary alloc] init];
    controllers=[[NSMutableArray alloc] init];
    controllersArr=[[NSMutableArray alloc] init];
    
    controllers=@[@"AllSaleVC",@"SoldItemsVC",@"FavouriteVC"].mutableCopy;
    
    for (NSString *str in controllers)
    {
        
        UIViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:str];
        [controllersArr  addObject:vc];
        
    }
    
    // Create page view controller
    self.PageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyListPageViewController"];
    self.PageViewController.dataSource = self;
    self.PageViewController.delegate = self;
    
    UIViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    
    
    
    [self.PageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.PageViewController.view.frame = CGRectMake(0, 0, self.targetVw.frame.size.width, self.targetVw.frame.size.height);
    
    [self addChildViewController:_PageViewController];
    [self.targetVw addSubview:_PageViewController.view];
    [self.PageViewController didMoveToParentViewController:self];
    
    for (UIView *view in self.PageViewController.view.subviews)
    {
        if ([view isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)view setDelegate:self];
            UIScrollView *scroll=(UIScrollView *)view;
        }
    }
    contentOffSet=self.view.frame.size.width;
    
    NSInteger lead=0;
    
    for (int i=0; i<controllersArr.count; i++)
    {
        
        [dict setValue:[NSString stringWithFormat:@"%ld",(long)lead] forKey:[NSString stringWithFormat:@"%d",i]];
        lead=lead+contentOffSet/controllersArr.count;
    }
    
    self.widthOfBarView.constant=self.view.frame.size.width/controllersArr.count;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [_allSaleBtn setTitle:AMLocalizedString(@"selling", @"selling") forState:UIControlStateNormal];
    [_soldBtn setTitle:AMLocalizedString(@"sold", @"sold") forState:UIControlStateNormal];
    [_favouriteBtn setTitle:AMLocalizedString(@"favorite", @"favorite") forState:UIControlStateNormal];
    self.navigationItem.title=AMLocalizedString(@"tab3", @"tab3");
    
    
//    JSBadgeView *badgeView;
//@property(strong,nonatomic) UIButton *customButton;
    
    _customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_customButton setImage:[UIImage imageNamed:@"cart"] forState:UIControlStateNormal];
    [_customButton sizeToFit];
    _customButton.frame = CGRectMake(0.0, 0.0, 20, 20);
    [_customButton addTarget:self action:@selector(ontapCartBarBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* customBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_customButton];
    self.navigationItem.rightBarButtonItem = customBarButtonItem;
    badgeView = [[JSBadgeView alloc] initWithParentView:_customButton alignment:JSBadgeViewAlignmentTopRight];
    badgeView.badgeBackgroundColor=[UIColor redColor];
    badgeView.badgeText = [NSString stringWithFormat:@"%li",(long)[[UKModel model] cartCount]];
    
    
    
//    self.navigationItem.rightBarButtonItem.badgeValue=[NSString stringWithFormat:@"%ld",(long)[[UKModel model] cartCount]];
//    self.navigationItem.rightBarButtonItem.shouldHideBadgeAtZero=YES;
//    self.navigationItem.rightBarButtonItem.shouldAnimateBadge=YES;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index=[controllersArr indexOfObject:viewController];
    
    if ((index == 0) || (index == NSNotFound))
    {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index=[controllersArr indexOfObject:viewController];
    
    if (index == NSNotFound)
    {
        return nil;
    }
    index++;
    if (index == [controllers count])
    {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        id currentView = pageViewController.viewControllers.firstObject;
        sek=[controllersArr indexOfObject:currentView];
        NSLog(@"previousViewControllers %@",currentView);
        [self showAnime:sek];
//        if (sek==1)
//        {
//            [self.completedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [self.onGoingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            
//        }
//        else
//        {
//            [self.completedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [self.onGoingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        }
        
    }
    
}


-(void)showAnime:(NSInteger)index
{
    CGAffineTransform translate = CGAffineTransformMakeTranslation([[dict valueForKey:[NSString stringWithFormat:@"%ld",(long)index]] integerValue],0);
    
    [UIView animateWithDuration:0.2 animations:^{
        _barVw.transform=translate;
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - Other Methods
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    
    return [controllersArr objectAtIndex:index];
}

-(void)page:(NSInteger)index
{
    
    id currentView = self.PageViewController.viewControllers.firstObject;
    sek=[controllersArr indexOfObject:currentView];
    
    NSArray *viewControllers = @[[self viewControllerAtIndex:index]];
    
    UIPageViewControllerNavigationDirection animateDirection =
    index >= sek ? UIPageViewControllerNavigationDirectionForward
    : UIPageViewControllerNavigationDirectionReverse;
    
    [self.PageViewController setViewControllers:viewControllers direction:animateDirection animated:YES completion:nil];
    [self showAnime:index];
    
}

- (IBAction)onTapSegmentButtons:(UIButton *)sender {
    
    id currentView = self.PageViewController.viewControllers.firstObject;
    sek=[controllersArr indexOfObject:currentView];
    
    if (sender.tag==11) {
        [self page:0];

    } else if (sender.tag==12) {
        [self page:1];

    } else {
        [self page:2];

    }
}
- (void)ontapCartBarBtn:(UIButton *)sender {
    
    CartVC *cart=[self.storyboard instantiateViewControllerWithIdentifier:@"CartVC"];
    [self.navigationController pushViewController:cart animated:YES];
}
@end
