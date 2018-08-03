//
//  MoreVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 11/24/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import "MoreVC.h"
#import "SearchVC.h"
#import "AdvisoryVC.h"
@interface MoreVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *menuItems;
    JSBadgeView *badgeView;
}
@property(strong,nonatomic) UIButton *customButton;
@end

@implementation MoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    menuItems=[[NSMutableArray alloc] init];
    menuItems=@[@"change_lang",@"profile",@"about_us",@"advisory",@"privacy_policy",@"terms_services",@"refund_policy",@"contact_us",@"orders",@"logout",].mutableCopy;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forLanguageChange) name:@"LANGCHANGED" object:nil];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [[self.tabBarController.tabBar.items objectAtIndex:0] isKindOfClass:[SearchVC class]] ? [[self.tabBarController.tabBar.items objectAtIndex:0] setTitle:AMLocalizedString(@"tab1", @"tab1")]: [[self.tabBarController.tabBar.items objectAtIndex:0] setTitle:AMLocalizedString(@"home", @"home")];

    self.navigationItem.title=AMLocalizedString(@"menu", @"menu");
    _menuTblVw.delegate=self;
    _menuTblVw.dataSource=self;
    [_menuTblVw reloadData];
    
    _customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_customButton setImage:[UIImage imageNamed:@"cart"] forState:UIControlStateNormal];
    [_customButton sizeToFit];
    _customButton.frame = CGRectMake(0.0, 0.0, 20, 20);
    [_customButton addTarget:self action:@selector(onTapCartBarBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* customBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_customButton];
    self.navigationItem.rightBarButtonItem = customBarButtonItem;
    badgeView = [[JSBadgeView alloc] initWithParentView:_customButton alignment:JSBadgeViewAlignmentTopRight];
    badgeView.badgeBackgroundColor=[UIColor redColor];
    badgeView.badgeText = [NSString stringWithFormat:@"%li",(long)[[UKModel model] cartCount]];
    
    
//    self.navigationItem.rightBarButtonItem.badgeValue=[NSString stringWithFormat:@"%ld",(long)[[UKModel model] cartCount]];
//    self.navigationItem.rightBarButtonItem.shouldHideBadgeAtZero=NO;
//    self.navigationItem.rightBarButtonItem.shouldAnimateBadge=YES;
    
}
-(void)forLanguageChange
{
    [_menuTblVw reloadData];
    
    [[[[[self.tabBarController viewControllers] objectAtIndex:0] childViewControllers] objectAtIndex:0] isKindOfClass:[SearchVC class]] ? [[self.tabBarController.tabBar.items objectAtIndex:0] setTitle:AMLocalizedString(@"tab1", @"tab1")]: [[self.tabBarController.tabBar.items objectAtIndex:0] setTitle:AMLocalizedString(@"home", @"home")];
    [[self.tabBarController.tabBar.items objectAtIndex:1] setTitle:AMLocalizedString(@"tab2", @"tab2")];
    [[self.tabBarController.tabBar.items objectAtIndex:2] setTitle:AMLocalizedString(@"tab3", @"tab3")];
    [[self.tabBarController.tabBar.items objectAtIndex:3] setTitle:AMLocalizedString(@"tab4", @"tab4")];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return menuItems.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ident=@"menuCell";
    UKTableCell *cell=[_menuTblVw dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell=[[UKTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.menuNameLabel.text=AMLocalizedString([menuItems objectAtIndex:indexPath.row], [menuItems objectAtIndex:indexPath.row]);
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.height*0.1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            LanguageAndCountryVC *lang=[self.storyboard instantiateViewControllerWithIdentifier:@"LanguageAndCountryVC"];
            lang.isFromOther=YES;
            [self.navigationController presentViewController:lang animated:YES completion:nil];
            break;
        }
        case 1:
        {
            MyProfileVC *profile=[self.storyboard instantiateViewControllerWithIdentifier:@"MyProfileVC"];
            [self.navigationController pushViewController:profile animated:YES];

            break;
        }
        case 2:
        {
            [[UKModel model] setToWebView:AboutUs];
            [self performSegueWithIdentifier:@"toWebView" sender:self];
            break;
        }
        case 3:
        {
            AdvisoryVC *advisory=[self.storyboard instantiateViewControllerWithIdentifier:@"AdvisoryVC"];
            [self.navigationController pushViewController:advisory animated:YES];

            break;
        }
        case 4:
        {
            [[UKModel model] setToWebView:PrivacyPolicy];
            [self performSegueWithIdentifier:@"toWebView" sender:self];

            break;
        }
        case 5:
        {
            [[UKModel model] setToWebView:TermsServices];
            [self performSegueWithIdentifier:@"toWebView" sender:self];
            
            break;
        }
        case 6:
        {
            [[UKModel model] setToWebView:RefundPolicy];
            [self performSegueWithIdentifier:@"toWebView" sender:self];

            break;
        }
        case 7:
        {
            ContactUsVC *contact=[self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsVC"];
            [self.navigationController pushViewController:contact animated:YES];

            break;
        }
        case 8:
        {
            OrdersVC *contact=[self.storyboard instantiateViewControllerWithIdentifier:@"OrdersVC"];
            [self.navigationController pushViewController:contact animated:YES];
            
            break;
        }
        default:
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
//                NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//                [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
//                [[NSUserDefaults  standardUserDefaults]synchronize];
                [[[UIApplication sharedApplication] keyWindow] setRootViewController:login];

            }];

            [alert addAction:cancelAction];
            [alert addAction:logoutAction];
            [self presentViewController:alert animated:YES completion:nil];
            break;
        }
    }
}

- (void)onTapCartBarBtn:(UIButton *)sender {
    
    CartVC *cart=[self.storyboard instantiateViewControllerWithIdentifier:@"CartVC"];
    [self.navigationController pushViewController:cart animated:YES];
    
}
@end
