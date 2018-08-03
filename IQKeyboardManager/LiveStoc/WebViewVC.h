//
//  WebViewVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 12/21/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewVC : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webVw;
@property(strong,nonatomic) NSDictionary *articleDetails;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareBarBtn;
- (IBAction)onTapShareBarBtnItem:(UIBarButtonItem *)sender;

@end
