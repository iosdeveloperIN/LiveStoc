//
//  SelectSellCategoryVC.h
//  LiveStoc
//
//  Created by Amazebrandlance on 26/03/18.
//  Copyright © 2018 Harjit Singh. All rights reserved.
//

#import "SelectCategoryVC.h"

@interface SelectSellCategoryVC : SelectCategoryVC
@property (weak, nonatomic) IBOutlet UICollectionView *categoryCollVw;

@property (assign) Boolean isSellCatagory;

@end
