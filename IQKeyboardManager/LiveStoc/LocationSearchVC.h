//
//  LocationSearchVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 12/19/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UKLocationManager.h"

@interface LocationSearchVC : UIViewController
- (IBAction)onTapBackBarBtn:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UILabel *locationAttribLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
- (IBAction)onTapMyLocationBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *myLocationBtn;
@property (weak, nonatomic) IBOutlet GMSMapView *searchMap;
- (IBAction)onTapSelectLocation:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *selectlocationBtn;
@property (weak, nonatomic) IBOutlet UITableView *searchTblVw;
@property (weak, nonatomic) IBOutlet UIButton *backGroundBtn;
- (IBAction)onTapBackGroundBtn:(UIButton *)sender;
- (IBAction)editingChanged:(UKTextField *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfSearchTblVw;
@property (weak, nonatomic) IBOutlet UKTextField *searchTF;

@end
