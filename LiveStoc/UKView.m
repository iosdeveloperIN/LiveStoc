//
//  UKView.m
//  IBDesignables
//
//  Created by Harjit Singh on 8/31/17.
//  Copyright © 2017 Pantech. All rights reserved.
//

#import "UKView.h"

@implementation UKView



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
    if (_borderWidth>0) {
        self.layer.borderWidth=self.borderWidth;
        self.layer.borderColor=self.borderColor.CGColor;
    }
    
    if (self.cornerRadius > 0) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius=self.cornerRadius;
    }
    
    if (_bottomBorder>0) {
        
        CALayer *border = [CALayer layer];
        CGFloat borderWidth = _bottomBorder;
        border.borderColor = _borderColor.CGColor;
        border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, self.frame.size.height);
        border.borderWidth = borderWidth;
        [self.layer addSublayer:border];
        self.layer.masksToBounds = YES;
    }
    if (_radiusShadow>0) {
        
//        self.clipsToBounds = NO;
        self.layer.shadowColor = _colorShadow.CGColor;
        self.layer.shadowOffset = _offsetShadow;
        self.layer.shadowOpacity = _opacityShadow;
        self.layer.shadowRadius = _radiusShadow;
    }
    
    
    
}

@end
