//
//  UKLabel.h
//  IBDesignables
//
//  Created by Harjit Singh on 8/31/17.
//  Copyright © 2017 Pantech. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface UKLabel : UILabel

@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable NSString *labelText;

@end
