//
//  UKLabel.m
//  IBDesignables
//
//  Created by Harjit Singh on 8/31/17.
//  Copyright © 2017 Pantech. All rights reserved.
//

#import "UKLabel.h"

@implementation UKLabel


- (void)drawRect:(CGRect)rect
{
    [self didSet];
    
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self didSet];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self didSet];
    }
    return self;
}

- (void)setNeedsLayout {
    [super setNeedsLayout];
    [self setNeedsDisplay];
}


- (void)prepareForInterfaceBuilder {
    
    [self didSet];
}
-(void)didSet
{
    self.layer.cornerRadius=self.cornerRadius;
    self.layer.borderWidth=self.borderWidth;
    self.layer.borderColor=self.borderColor.CGColor;
    self.text=self.labelText;
    if (self.cornerRadius > 0) {
        self.layer.masksToBounds = YES;
    }
    self.text=self.text;
}


@end
