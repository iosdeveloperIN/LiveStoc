//
//  UKImageView.h
//  LiveStoc
//
//  Created by Harjit Singh on 1/17/18.
//  Copyright © 2018 Harjit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface UKImageView : UIImageView
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable UIColor *borderColor;
@property(nonatomic) IBInspectable CGFloat bottomBorder;
@end
