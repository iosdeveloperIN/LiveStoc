//
//  AllSaleVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 12/21/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllSaleVC : UIViewController
@property (weak, nonatomic) IBOutlet KPDropMenu *categoryDrop;
@property (weak, nonatomic) IBOutlet UILabel *noListingLbl;
@property (weak, nonatomic) IBOutlet UICollectionView *ItemsCollVw;

@end
