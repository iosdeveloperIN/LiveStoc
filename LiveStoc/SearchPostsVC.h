//
//  SearchPostsVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 12/19/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchPostsVC : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *searchCollVw;
@property (weak, nonatomic) IBOutlet UKTextField *searchTF;
- (IBAction)searchTextDidChange:(UKTextField *)sender;
- (IBAction)onTapBackBtn:(UIBarButtonItem *)sender;

@end
