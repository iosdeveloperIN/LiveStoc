//
//  OrdersVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 1/25/18.
//  Copyright © 2018 Harjit Singh. All rights reserved.
//

#import "OrdersVC.h"
#import "OrderDetailsVC.h"
@interface OrdersVC ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL isPagination;
    NSInteger page;
    NSMutableArray *allOrdersArr;
}
@end

@implementation OrdersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=AMLocalizedString(@"orders", @"orders");
    isPagination=NO;
    page=1;
    [self getOrders];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return allOrdersArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident=@"cell";
    
    UKTableCell *cell=[_ordersTblVw dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell=[[UKTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    cell.orderNumAttribOfOrdersVC.text=AMLocalizedString(@"order_number", @"order_number");
    cell.orderStatusAttribOfOrdersVC.text=AMLocalizedString(@"order_status", @"order_status");
    cell.paymentStatusAttribOfOrdersVC.text=AMLocalizedString(@"is_payment", @"is_payment");
    cell.orderTotalAttribOfOrdersVC.text=AMLocalizedString(@"order_price", @"order_price");
    cell.orderDateAttribOfOrdersVC.text=AMLocalizedString(@"order_date", @"order_date");
    cell.deliveryDateAttribOfOrdersVC.text=AMLocalizedString(@"delivery_date", @"delivery_date");
    

    
    
    cell.orderNumOfOrdersVC.text=[NSString stringWithFormat:@"%@",allOrdersArr[indexPath.row][@"order_no"]];
    
    
    
    if ([allOrdersArr[indexPath.row][@"isPayment"] integerValue]==1) {
        
        cell.paymentStatusOfOrdersVC.text=@"Completed";
        
    } else {
        
        cell.paymentStatusOfOrdersVC.text=@"Pending";
        
    }
    
    switch ([allOrdersArr[indexPath.row][@"status"] integerValue]) {
        case 0:
            cell.orderStatusOfOrdersVC.text=@"Pending";

            break;
        case 1:
            cell.orderStatusOfOrdersVC.text=@"Processing";

            break;
        case 2:
            cell.orderStatusOfOrdersVC.text=@"Completed";

            break;
        default:
            cell.orderStatusOfOrdersVC.text=@"Refund";

            break;
    }
    
    cell.orderTotalOfOrdersVC.text=[NSString stringWithFormat:@"%@",allOrdersArr[indexPath.row][@"total_price"]];
    cell.orderDateOfOrdersVC.text=[NSString stringWithFormat:@"%@",allOrdersArr[indexPath.row][@"created"]];
    cell.deliveryDateOfOrdersVC.text=[NSString stringWithFormat:@"%@",allOrdersArr[indexPath.row][@"delivery_date"]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OrderDetailsVC *deatils=[self.storyboard instantiateViewControllerWithIdentifier:@"OrderDetailsVC"];
    deatils.orderDetails=allOrdersArr[indexPath.row];
    [self.navigationController pushViewController:deatils animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.height*0.4;
}
//46.View My Orders
//http://livestoc.com/webservices/orders/index?users_id=2971&page=1&limit=10&status=0&isPayment=1
//
//
//isPayment=1 (payment success)
//isPayment=0 (payment failed)
//
//status=0 (pending)
//status=1 (processing)
//status=2 (completed)
//status=3 (refund)




-(void)getOrders
{
    if (!isPagination) {
        [DejalBezelActivityView activityViewForView:[[[UIApplication sharedApplication] delegate] window]];
    }
    [UKNetworkManager operationType:POST fromPath:@"orders/index" withParameters:@{@"page":[NSString stringWithFormat:@"%ld",(long)page],@"users_id":[UKNetworkManager getFromDefaultsWithKeyString:USER_ID],@"limit":@"10",@"status":@"",@"isPayment":@""}.mutableCopy withUploadData:nil :^(id result) {
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            
            if (isPagination) {
                allOrdersArr=[allOrdersArr arrayByAddingObjectsFromArray:[[result valueForKey:@"data"] valueForKey:@"advisory"]].mutableCopy;
                [_ordersTblVw reloadData];
                
            } else {
                allOrdersArr=[[NSMutableArray alloc] init];
                allOrdersArr=[[result valueForKey:@"data"] valueForKey:@"orders"];
                _ordersTblVw.delegate=self;
                _ordersTblVw.dataSource=self;
                [_ordersTblVw reloadData];
                
            }
        } else {
            if (isPagination) {
                isPagination=NO;
                page=page-1;
            } else {
                [UKNetworkManager showAlertWithTitle:[result valueForKey:@"message"] messageTitle:nil okTitle:nil cancelTitle:AMLocalizedString(@"ok", @"ok") otherTitles:nil];
            }
        }
        [DejalBezelActivityView removeViewAnimated:YES];
        
    } :^(NSError *error, NSString *errorMessage) {
        [DejalBezelActivityView removeViewAnimated:YES];
        if (isPagination) {
            isPagination=NO;
            page=page-1;
        } else {
            [UKNetworkManager showAlertWithTitle:errorMessage messageTitle:nil okTitle:nil cancelTitle:AMLocalizedString(@"ok", @"ok") otherTitles:nil];
        }
    }];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (allOrdersArr.count-1 == indexPath.row) {
        
        isPagination=YES;
        page=page+1;
        [self getOrders];
    }
}

@end
