//
//  UKCollectionCell.m
//  LiveStoc
//
//  Created by Harjit Singh on 11/21/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import "UKCollectionCell.h"

@implementation UKCollectionCell

- (IBAction)ratingVw:(id)sender {
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _costOfPostOfSearchVC.layer.cornerRadius=_costOfPostOfSearchVC.frame.size.height/2;
    _costOfPostOfSearchVC.clipsToBounds=YES;
}
@end
