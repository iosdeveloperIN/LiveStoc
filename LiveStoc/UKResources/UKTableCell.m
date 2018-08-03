//
//  UKTableCell.m
//  LiveStoc
//
//  Created by Harjit Singh on 11/23/17.
//  Copyright © 2017 Harjit Singh. All rights reserved.
//

#import "UKTableCell.h"

@implementation UKTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    if ([[UKModel model] isHomeCell]) {
        [self update];
    }
}
-(void)update
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(3, 3, self.contentView.frame.size.width-6, self.contentView.frame.size.height-6)];
    view.autoresizingMask =  UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth ;
    view.layer.borderWidth=0.5f;
    view.layer.borderColor=[UIColor blackColor].CGColor;
    view.clipsToBounds=YES;
//    [self.contentView addSubview:view];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
