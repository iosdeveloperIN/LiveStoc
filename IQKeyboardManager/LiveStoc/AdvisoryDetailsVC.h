//
//  AdvisoryDetailsVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 1/17/18.
//  Copyright © 2018 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Inputbar.h"
@interface AdvisoryDetailsVC : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *commentsTblVw;
@property(strong,nonatomic) NSMutableDictionary *details;
@property (weak, nonatomic) IBOutlet Inputbar *inputBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfToolBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomOfToolBar;



@end
