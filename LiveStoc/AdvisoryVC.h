//
//  AdvisoryVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 1/15/18.
//  Copyright © 2018 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvisoryVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *advisoryTblVw;
- (IBAction)onTapAddNewQuestionBtn:(UIButton *)sender;
@end
