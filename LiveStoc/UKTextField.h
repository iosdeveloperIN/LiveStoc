//
//  UKTextField.h
//  IBDesignables
//
//  Created by Harjit Singh on 8/31/17.
//  Copyright © 2017 Pantech. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface UKTextField : UITextField

@property(nonatomic) IBInspectable UIImage *leftImage;
@property(nonatomic) IBInspectable CGFloat leftPadding;
@property(nonatomic) IBInspectable UIImage *rightImage;
@property(nonatomic) IBInspectable CGFloat rightPadding;
@property(nonatomic) IBInspectable CGFloat cornerRadius;
@property(nonatomic) IBInspectable CGFloat borderWidth;
@property(nonatomic) IBInspectable UIColor *borderColor;

@end
