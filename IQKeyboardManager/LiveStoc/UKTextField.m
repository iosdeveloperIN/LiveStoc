//
//  UKTextField.m
//  IBDesignables
//
//  Created by Harjit Singh on 8/31/17.
//  Copyright © 2017 Pantech. All rights reserved.
//

#import "UKTextField.h"

@implementation UKTextField



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
    self.layer.cornerRadius=_cornerRadius;
    
    if (_leftImage || _leftPadding!=0) {
        self.leftViewMode=UITextFieldViewModeAlways;
        
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(_leftPadding, 0, 25, 25)];
        imageView.image=self.leftImage;
        imageView.tintColor=self.tintColor;
        CGFloat width=_leftPadding+25;
        
        if (self.borderStyle == UITextBorderStyleNone || self.borderStyle == UITextBorderStyleLine)
        {
            width=width+10;
        }
        
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 25)];
        [view addSubview:imageView];
        self.leftView=view;
    }
    else {
        self.leftViewMode=UITextFieldViewModeNever;
        self.leftPadding=0;
    }
    if (_rightImage) {
        self.rightViewMode=UITextFieldViewModeAlways;
        
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imageView.image=self.rightImage;
        imageView.tintColor=self.tintColor;
        CGFloat width=_rightPadding+20;
        
        
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 20)];
        [view addSubview:imageView];
        self.rightView=view;
    }
    else {
        self.rightViewMode=UITextFieldViewModeNever;
        _rightPadding=0;
    }
    
    if (_borderWidth>0 && self.borderStyle == UITextBorderStyleNone) {
        
        CGFloat borderWidth = _borderWidth;
        
        
        self.layer.borderWidth=borderWidth;
        self.layer.borderColor=_borderColor.CGColor;
//        CALayer *border = [CALayer layer];
//        border.borderColor = _borderColor.CGColor;
//        border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, self.frame.size.height);
//        border.borderWidth = borderWidth;
//        [self.layer addSublayer:border];
        self.layer.masksToBounds = YES;
    }
    
}





@end
