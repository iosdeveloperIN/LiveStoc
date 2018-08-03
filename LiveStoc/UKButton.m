//
//  UKButton.m
//  IBDesignables
//
//  Created by Harjit Singh on 8/31/17.
//  Copyright © 2017 Pantech. All rights reserved.
//

#import "UKButton.h"

@implementation UKButton


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
    
    if (self.cornerRadius > 0) {
        self.layer.masksToBounds = YES;
    }
    if (self.doYouWantSelectedColor) {
        if (self.selected) {
            [self setBackgroundColor:_selectedColor];
            [self setTitleColor:_selectedTextColor forState:UIControlStateNormal];
        } else {
            self.backgroundColor=self.backgroundColor;
            [self setTitleColor:[self titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
        }
    }
}


@end
