//
//  UKView.h
//  IBDesignables
//
//  Created by Harjit Singh on 8/31/17.
//  Copyright © 2017 Pantech. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface UKView : UIView
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable UIColor *borderColor;
@property(nonatomic) IBInspectable CGFloat bottomBorder;

//For Shadow
@property (nonatomic) IBInspectable CGFloat opacityShadow;
@property (nonatomic) IBInspectable CGFloat radiusShadow;
@property (nonatomic) IBInspectable UIColor *colorShadow;
@property(nonatomic) IBInspectable CGSize offsetShadow;

@end
