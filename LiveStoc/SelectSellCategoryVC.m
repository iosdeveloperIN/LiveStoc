//
//  SelectSellCategoryVC.m
//  LiveStoc
//
//  Created by Amazebrandlance on 26/03/18.
//  Copyright © 2018 Harjit Singh. All rights reserved.
//

#import "SelectSellCategoryVC.h"

@interface SelectSellCategoryVC ()

@end

@implementation SelectSellCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"sgfd %d",self.isSellCatagory);
    
    // Do any additional setup after loading the view.
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:AMLocalizedString(@"select_gender", @"Select Gender")
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleAlert];
    
        //Add Buttons
    
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:AMLocalizedString(@"male", @"Male")
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                    
                                    }];
    
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:AMLocalizedString(@"female", @"Female")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                      
                                   }];
    
        //Add your buttons to alert controller
    
        [alert addAction:yesButton];
        [alert addAction:noButton];
    
        [self presentViewController:alert animated:YES completion:nil];
 
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
