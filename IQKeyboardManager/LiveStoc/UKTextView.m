//
//  UKTextView.m
//  Fleet City
//
//  Created by Harjit Singh on 9/21/17.
//  Copyright © 2017 Intellisense Technology. All rights reserved.
//

#import "UKTextView.h"

@implementation UKTextView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
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
-(void)didSet {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeText) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndEditing) name:UITextViewTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBeganEditing) name:UITextViewTextDidBeginEditingNotification object:nil];
    
    if (_cornerRadius>0) {
        self.layer.cornerRadius=_cornerRadius;

    }
    if (_borderWidth>0) {
        self.layer.borderWidth=_borderWidth;
        self.layer.borderColor=_borderColor.CGColor;
    }
    
    self.layer.masksToBounds = YES;
    
    if (_placeHolder && self.text.length==0)
    {
        if (![[self.subviews lastObject] isKindOfClass:[UILabel class]]) {
            _placeHolderLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.frame.size.width, 30)];
            _placeHolderLabel.backgroundColor=[UIColor clearColor];
            _placeHolderLabel.text=_placeHolder;
            _placeHolderLabel.textAlignment=NSTextAlignmentLeft;
            _placeHolderLabel.textColor=[UIColor lightGrayColor];
            _placeHolderLabel.font=self.font;
            [self addSubview:_placeHolderLabel];
        }
    }
}
-(void)didChangeText {
    
    if (self.text.length==0) {
        
        if (![[self.subviews lastObject] isKindOfClass:[UILabel class]]) {
            _placeHolderLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.frame.size.width, 30)];
            _placeHolderLabel.backgroundColor=[UIColor clearColor];
            _placeHolderLabel.text=_placeHolder;
            _placeHolderLabel.textAlignment=NSTextAlignmentLeft;
            _placeHolderLabel.textColor=[UIColor lightGrayColor];
            _placeHolderLabel.font=self.font;
            [self addSubview:_placeHolderLabel];
        }
        _placeHolderLabel.hidden=NO;
        
    } else {
        
        _placeHolderLabel.hidden=YES;

    }
}
-(void)didEndEditing {
    
    if (self.text.length==0) {
        
        _placeHolderLabel.hidden=NO;
        
    } else {
        
        _placeHolderLabel.hidden=YES;

    }
}

-(void)didBeganEditing {
    
}
@end
