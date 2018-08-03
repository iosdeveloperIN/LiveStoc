//
//  UKImageView.m
//  LiveStoc
//
//  Created by Harjit Singh on 1/17/18.
//  Copyright © 2018 Harjit Singh. All rights reserved.
//

#import "UKImageView.h"

@implementation UKImageView

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
-(void)layoutSubviews{
    [super layoutSubviews];
    [self didSet];
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
    
//    if (self.cornerRadius > 0) {
        self.layer.cornerRadius=self.frame.size.width/2;
        self.layer.masksToBounds = YES;

//    }
    
    if (_bottomBorder>0) {
        
        CALayer *border = [CALayer layer];
        CGFloat borderWidth = _bottomBorder;
        border.borderColor = _borderColor.CGColor;
        border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, self.frame.size.height);
        border.borderWidth = borderWidth;
        [self.layer addSublayer:border];
        self.layer.masksToBounds = YES;
    }
    
}

@end
