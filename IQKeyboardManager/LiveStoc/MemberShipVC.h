//
//  MemberShipVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 12/22/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberShipVC : UIViewController
- (IBAction)onTapBuyNowBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *memberCollVw;

@end
