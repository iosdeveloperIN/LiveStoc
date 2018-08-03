//
//  UKButton.h
//  IBDesignables
//
//  Created by Harjit Singh on 8/31/17.
//  Copyright © 2017 Pantech. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface UKButton : UIButton

@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable UIColor *selectedColor;
@property (nonatomic) IBInspectable UIColor *selectedTextColor;
@property (nonatomic) IBInspectable BOOL doYouWantSelectedColor;
@end
