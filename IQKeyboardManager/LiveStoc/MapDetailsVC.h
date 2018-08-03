//
//  MapDetailsVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 2/1/18.
//  Copyright © 2018 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapDetailsVC : UIViewController
@property (weak, nonatomic) IBOutlet GMSMapView *locationMapView;
- (IBAction)onTapCurrentLocationBtn:(UIButton *)sender;
@property(strong,nonatomic) NSDictionary *latDict;
@end
