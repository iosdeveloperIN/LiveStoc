//
//  SoldItemsVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 12/21/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SoldItemsVC : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *soldItemsCollVw;
@property (weak, nonatomic) IBOutlet KPDropMenu *soldDropMenu;
@property (weak, nonatomic) IBOutlet UILabel *noListAvailLbl;

@end
