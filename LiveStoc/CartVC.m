//
//  CartVC.m
//  LiveStoc
//
//  Created by Harjit Singh on 1/22/18.
//  Copyright © 2018 Harjit Singh. All rights reserved.
//

#import "CartVC.h"
#import "AddressVC.h"
@interface CartVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableDictionary *cartDict;
    NSInteger count;
}
@end

@implementation CartVC

- (void)viewDidLoad {
    [super viewDidLoad];
//   tax_percentage
    
    self.navigationItem.title=AMLocalizedString(@"shop_cart", @"shop_cart");
    _noDataLabel.text=AMLocalizedString(@"no_item_cart", @"no_item_cart");
    _productTotalAttrib.text=AMLocalizedString(@"product_total", @"product_total");
    _shippingAttrib.text=AMLocalizedString(@"product_shipping", @"product_shipping");
    _totalAttrib.text=AMLocalizedString(@"cart_total", @"cart_total");
    [_confirmOrderBtn setTitle:AMLocalizedString(@"checkout", @"checkout") forState:UIControlStateNormal];
    _noDataLabel.hidden=YES;
    _priceVw.hidden=YES;
    _cartTblVw.hidden=YES;
    [self getCartCount];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [cartDict[@"products"] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident=@"cell";
    UKTableCell *cell=[_cartTblVw dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell=[[UKTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell.productImageVwOfCartVC sd_setImageWithURL:[NSURL URLWithString:cartDict[@"products"][indexPath.row][@"images"]] placeholderImage:[UIImage imageNamed:@"p"] options:SDWebImageHighPriority];
    
    cell.productTitleOfCartVC.text=[NSString stringWithFormat:@"%@",cartDict[@"products"][indexPath.row][@"title"]];
    cell.priceAttribOfCartVC.text=AMLocalizedString(@"price", @"price");
    cell.priceLblOfCartVC.text=[NSString stringWithFormat:@"%@ %@",[[UKModel model] currency],cartDict[@"products"][indexPath.row][@"price"]];
    cell.descripAttribOfCartVC.text=AMLocalizedString(@"description", @"description");
    cell.descripLblOfCartVC.text=[NSString stringWithFormat:@"%@",cartDict[@"products"][indexPath.row][@"description"]];
    cell.quantityAttribOfCartVC.text=AMLocalizedString(@"quantity", @"quantity");
    cell.quantityLblOfCartVC.text=[NSString stringWithFormat:@"%@",cartDict[@"products"][indexPath.row][@"qty"]];
    cell.totalAttribOfCartVC.text=AMLocalizedString(@"cart_total", @"cart_total");
    cell.totalLblOfCartVC.text=[NSString stringWithFormat:@"%@ %@",[[UKModel model] currency],cartDict[@"products"][indexPath.row][@"totalprice"]];
    cell.itemQuantityLblOfCartVC.text=[NSString stringWithFormat:@"%@",cartDict[@"products"][indexPath.row][@"qty"]];
    
    cell.minusBtnOfCartVC.tag=indexPath.row;
    cell.plusBtnOfCartVC.tag=indexPath.row;
    cell.removeBtnOfCartVC.tag=indexPath.row;

    return cell;
}

-(void)getCartCount
{
//    [DejalBezelActivityView activityViewForView:[[[UIApplication sharedApplication] delegate] window]];
    [UKNetworkManager operationType:POST fromPath:@"cart/index" withParameters:@{@"user_id":[UKNetworkManager getFromDefaultsWithKeyString:USER_ID]}.mutableCopy withUploadData:nil :^(id result) {
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            
            cartDict=[[NSMutableDictionary alloc] init];
            cartDict=result[@"data"];
            _cartTblVw.delegate=self;
            _cartTblVw.dataSource=self;
            [_cartTblVw reloadData];
            
            _taxAttrib.text=[NSString stringWithFormat:@"%@(%@)",AMLocalizedString(@"product_tax", @"product_tax"),cartDict[@"tax_percentage"]];
            _productTotalAmnt.text=[NSString stringWithFormat:@"%@",cartDict[@"total"]];
            _taxLabel.text=[NSString stringWithFormat:@"%@",cartDict[@"tax"]];
            _shippingLabel.text=[NSString stringWithFormat:@"%@",cartDict[@"shipping"]];
            _totalAmntLabel.text=[NSString stringWithFormat:@"%.2f",[cartDict[@"totalPrice"] floatValue]];
            
            _noDataLabel.hidden=YES;
            _priceVw.hidden=NO;
            _cartTblVw.hidden=NO;
            
            [[UKModel model] setCartCount:[result[@"data"][@"total"] integerValue]];
            
        } else {
            cartDict=[[NSMutableDictionary alloc] init];
            _cartTblVw.delegate=self;
            _cartTblVw.dataSource=self;
            [_cartTblVw reloadData];
            _noDataLabel.hidden=NO;
            _priceVw.hidden=YES;
            _cartTblVw.hidden=YES;
            
        }

    } :^(NSError *error, NSString *errorMessage) {

    }];
    
}

-(void)updateCartQuantityWithCount:(NSInteger)productCount withProduct:(NSInteger)productID withCart:(NSInteger)cartID
{
    [UKNetworkManager operationType:POST fromPath:@"cart/update_cart_qty" withParameters:@{@"users_id":[UKNetworkManager getFromDefaultsWithKeyString:USER_ID],@"products_id":[NSString stringWithFormat:@"%ld",(long)productID],@"cart_id":[NSString stringWithFormat:@"%ld",(long)cartID],@"qty":[NSString stringWithFormat:@"%ld",(long)productCount],@"submit":@"Go"}.mutableCopy withUploadData:nil :^(id result) {
        
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            [self getCartCount];
          [[[[UIApplication sharedApplication] delegate] window] makeToast:[result valueForKey:@"data"] duration:3.0 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-80)]];
        } else {
              [[[[UIApplication sharedApplication] delegate] window] makeToast:[[result valueForKey:@"data"]objectAtIndex:0] duration:3.0 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-80)]];
        }
      
    } :^(NSError *error, NSString *errorMessage) {
        
    }];
    
}

- (IBAction)onTapConfirmOrder:(UKButton *)sender {
    NSMutableString *productIDs=[[NSMutableString alloc] init];
    NSMutableString *quantity=[[NSMutableString alloc] init];

    for (NSDictionary *dict in cartDict[@"products"]) {
        
        [productIDs appendString:[NSString stringWithFormat:@"%@,",dict[@"products_id"]]];
        [quantity appendString:[NSString stringWithFormat:@"%@,",dict[@"qty"]]];
    }
    productIDs=[productIDs substringToIndex:productIDs.length-1].mutableCopy;
    quantity=[quantity substringToIndex:quantity.length-1].mutableCopy;
    
    AddressVC *Address=[self.storyboard instantiateViewControllerWithIdentifier:@"AddressVC"];
    Address.detailsDict=@{@"products_id":productIDs,@"qty":quantity}.mutableCopy;
    [self.navigationController pushViewController:Address animated:YES];
    
}

- (IBAction)minusAction:(UIButton *)sender {
    
    count=[cartDict[@"products"][sender.tag][@"qty"] integerValue];
    if (count>1) {
        count=count-1;
        [self updateCartQuantityWithCount:count withProduct:[cartDict[@"products"][sender.tag][@"products_id"] integerValue] withCart:[cartDict[@"products"][sender.tag][@"cart_id"] integerValue]];
    }
    
}

- (IBAction)plusAction:(UIButton *)sender {
    
    count=[cartDict[@"products"][sender.tag][@"qty"] integerValue];
    count=count+1;
    [self updateCartQuantityWithCount:count withProduct:[cartDict[@"products"][sender.tag][@"products_id"] integerValue] withCart:[cartDict[@"products"][sender.tag][@"cart_id"] integerValue]];
    
}

- (IBAction)onTapRemoveFromCart:(UIButton *)sender {
    
    [UKNetworkManager operationType:POST fromPath:@"cart/delete" withParameters:@{@"cart_id":[NSString stringWithFormat:@"%@",cartDict[@"products"][sender.tag][@"cart_id"]]}.mutableCopy withUploadData:nil :^(id result) {
        if ([[result valueForKey:SUCCESS] integerValue]==1) {
            [self getCartCount];
            [[UKModel model] setCartCount:[[UKModel model] cartCount]-1];
            
        } else {
            
        }
        [[[[UIApplication sharedApplication] delegate] window] makeToast:[result valueForKey:@"data"] duration:3.0 position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-80)]];

    } :^(NSError *error, NSString *errorMessage) {
        
    }];
    
}


@end
