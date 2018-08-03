//
//  WebViewVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 12/21/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import "WebViewVC.h"

@interface WebViewVC ()<UIWebViewDelegate>
{
    UKModel *type;
    NSURL *url;
}
@end

@implementation WebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    type=[UKModel model];
    _webVw.delegate=self;
    
    
    switch (type.toWebView) {
        case AboutUs:
            url=[[NSURL alloc] initWithString:@"http://livestoc.com/webservices/user/about_us"];
            self.navigationItem.title=AMLocalizedString(@"about_us", @"");
            self.navigationItem.rightBarButtonItem=nil;

            break;
        case RefundPolicy:
            url=[[NSURL alloc] initWithString:@"http://livestoc.com/webservices/user/refund"];
            self.navigationItem.title=AMLocalizedString(@"refund_policy", @"");
            self.navigationItem.rightBarButtonItem=nil;
            
            break;
            
        case ArticleDetail:
            url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://livestoc.com/webservices/article/article_details/?article_id=%@",_articleDetails[@"ID"]]];
            self.navigationItem.title=_articleDetails[@"title"];
            
            break;
        case TermsServices:
            url=[[NSURL alloc] initWithString:@"http://livestoc.com/webservices/user/terms_of_services"];
            self.navigationItem.title=AMLocalizedString(@"terms_", @"terms_");
            self.navigationItem.rightBarButtonItem=nil;
            
            break;
        default:
            url=[[NSURL alloc] initWithString:@"http://livestoc.com/webservices/user/privacy_policy"];
            self.navigationItem.title=AMLocalizedString(@"privacy_policy", @"");
            self.navigationItem.rightBarButtonItem=nil;

            break;
    }
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_webVw loadRequest:requestObj];
    [DejalBezelActivityView activityViewForView:[[[UIApplication sharedApplication] delegate] window]];

}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
//    CGSize contentSize = _webVw.scrollView.contentSize;
//    CGSize viewSize = _webVw.bounds.size;
//    
//    float rw = viewSize.width / contentSize.width;
//    
//    _webVw.scrollView.minimumZoomScale = 0.5;
//    _webVw.scrollView.maximumZoomScale = 0.5;
//    _webVw.scrollView.zoomScale = 0.5;
    
    [DejalBezelActivityView removeViewAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (IBAction)onTapShareBarBtnItem:(UIBarButtonItem *)sender {
    [self activityView];
}
-(void)activityView
{
    
    NSMutableArray *sharingItems=[[NSMutableArray alloc]init];
    NSURL *appStoreUrl=[NSURL URLWithString:@"https://itunes.apple.com"];
    [sharingItems addObject:appStoreUrl];
    NSLog(@"objects===>%@",sharingItems);
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   ];
    
    activityController.excludedActivityTypes = excludeActivities;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:activityController animated:YES completion:nil];
    }
    //if iPad
    else {
        // Change Rect to position Popover
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityController];
        [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}
@end
