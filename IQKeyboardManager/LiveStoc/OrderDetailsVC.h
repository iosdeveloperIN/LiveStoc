//
//  OrderDetailsVC.h
//  LiveStoc
//
//  Created by Harjit Singh on 1/25/18.
//  Copyright © 2018 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailsVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *detailsTblVw;
@property (weak, nonatomic) IBOutlet UIImageView *detailImgVw;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceAttrib;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *descriptionAttrib;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLbl;
@property (weak, nonatomic) IBOutlet UILabel *quantityAttrib;
@property (weak, nonatomic) IBOutlet UILabel *quantityLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceAttrib;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLbl;
@property (weak, nonatomic) IBOutlet UKView *detailsVw;
@property(strong,nonatomic) NSDictionary *orderDetails;
@end
