//
//  SelectCategoryVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 12/9/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCategoryVC : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *categoryCollVw;
- (IBAction)onTapBackButton:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UILabel *typeOfAnimal;

@end


