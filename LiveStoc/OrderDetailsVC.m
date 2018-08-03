//
//  OrderDetailsVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 1/25/18.
//  Copyright © 2018 Harjit Singh. All rights reserved.
//

#import "OrderDetailsVC.h"

@interface OrderDetailsVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableDictionary *dataDict;
}
@end

@implementation OrderDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    dataDict=[[NSMutableDictionary alloc] init];
    
    self.navigationItem.title=AMLocalizedString(@"detail_order", @"detail_order");
    dataDict=@{@"attribs":@[@"order_number",@"order_status",@"is_payment",@"product_total",@"product_tax",@"product_shipping",@"cart_total",@"order_date",@"delivery_date",@"shipping_address",@"billing_address"].mutableCopy,@"values":@[[ self emptyStringReturn:_orderDetails[@"order_no"]],[ self emptyStringReturn:_orderDetails[@" "]],[ self emptyStringReturn:_orderDetails[@" "]],[ self emptyStringReturn:_orderDetails[@"price"]],[ self emptyStringReturn:_orderDetails[@"total_tax"]],[ self emptyStringReturn:_orderDetails[@"total_shipping"]],[ self emptyStringReturn:_orderDetails[@"total_price"]],[ self emptyStringReturn:_orderDetails[@"created"]],[ self emptyStringReturn:_orderDetails[@"delivery_date"]],[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",[_orderDetails valueForKey:@"shipping_house_no"],[_orderDetails valueForKey:@"shipping_landmark"],[_orderDetails valueForKey:@"shipping_street"],[_orderDetails valueForKey:@"shipping_city"],[_orderDetails valueForKey:@"shipping_state"],[_orderDetails valueForKey:@"shipping_pin_code"]],[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",[_orderDetails valueForKey:@"billing_house_no"],[_orderDetails valueForKey:@"billing_landmark"],[_orderDetails valueForKey:@"billing_street"],[_orderDetails valueForKey:@"billing_city"],[_orderDetails valueForKey:@"billing_state"],[_orderDetails valueForKey:@"billing_pin_code"]]].mutableCopy}.mutableCopy;
    
    
    if ([_orderDetails[@"isPayment"] integerValue]==1) {
        
        [dataDict[@"values"] replaceObjectAtIndex:1 withObject:@"Completed"];
        
    } else {
        
        [[dataDict valueForKey:@"values"] replaceObjectAtIndex:1 withObject:@"Pending"];
        
    }
    
    switch ([_orderDetails[@"total_price"] integerValue]) {
        case 0:
            [[dataDict valueForKey:@"values"] replaceObjectAtIndex:2 withObject:@"Pending"];

            
            break;
        case 1:
            [dataDict[@"values"] replaceObjectAtIndex:2 withObject:@"Processing"];
            
            break;
        case 2:
            [dataDict[@"values"] replaceObjectAtIndex:2 withObject:@"Completed"];

            break;
        default:
            [dataDict[@"values"] replaceObjectAtIndex:2 withObject:@"Refund"];
            
            break;
    }

 
    [_detailImgVw sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_orderDetails[@"orderDetails"][0][@"fullimages"]]] placeholderImage:[UIImage imageNamed:@"p"] options:SDWebImageHighPriority];
    _priceAttrib.text=AMLocalizedString(@"price", @"price");
    _descriptionAttrib.text=AMLocalizedString(@"description", @"description");
    _quantityAttrib.text=AMLocalizedString(@"quantity", @"quantity");
    _totalPriceAttrib.text=AMLocalizedString(@"cart_total", @"cart_total");
    _totalPriceLbl.text=[NSString stringWithFormat:@"%@",_orderDetails[@"orderDetails"][0][@"totalPrice"]];
    _descriptionLbl.text=[NSString stringWithFormat:@"%@",_orderDetails[@"orderDetails"][0][@"description"]];
    _priceLbl.text=[NSString stringWithFormat:@"%@",_orderDetails[@"orderDetails"][0][@"price"]];
    _quantityLbl.text=[NSString stringWithFormat:@"%@",_orderDetails[@"orderDetails"][0][@"qty"]];
    _titleLbl.text=[NSString stringWithFormat:@"%@",_orderDetails[@"orderDetails"][0][@"title"]];

    
    _detailsTblVw.delegate=self;
    _detailsTblVw.dataSource=self;
    _detailsTblVw.estimatedRowHeight=54;
    _detailsTblVw.rowHeight=UITableViewAutomaticDimension;

}

-(NSString *)emptyStringReturn:(NSString *)value
{
    NSLog(@"%@",value);
    if ([value isEqualToString:@""] || [value length]==0) {
        return @"  ";
    } else {
        return value;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataDict[@"values"] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident=@"cell";
    
    UKTableCell *cell=[_detailsTblVw dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell=[[UKTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (indexPath.row<3) {
        cell.valueLabelOfOrderDetailsVC.textColor=[UIColor redColor];

    } else {
        cell.valueLabelOfOrderDetailsVC.textColor=[UIColor blackColor];
    }
    
    cell.attribLabelOfOrderDetailsVC.text=AMLocalizedString(dataDict[@"attribs"][indexPath.row], dataDict[@"attrib"][indexPath.row]);
    cell.valueLabelOfOrderDetailsVC.text=[NSString stringWithFormat:@"%@",dataDict[@"values"][indexPath.row]];
    return cell;
}

@end
