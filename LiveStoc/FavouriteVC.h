//
//  FavouriteVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 12/21/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavouriteVC : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *favouritesCollVw;
@property (weak, nonatomic) IBOutlet KPDropMenu *favDropMenu;
@property (weak, nonatomic) IBOutlet UILabel *listingLbl;
@end
