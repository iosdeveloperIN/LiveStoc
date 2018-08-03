//
//  UKTextView.h
//  Fleet City
//
//  Created by Harjit Singh on 9/21/17.
//  Copyright © 2017 Intellisense Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface UKTextView : UITextView

@property(nonatomic) IBInspectable NSString *placeHolder;
@property(nonatomic) IBInspectable CGFloat cornerRadius;
@property(nonatomic) IBInspectable CGFloat borderWidth;
@property(nonatomic) IBInspectable UIColor *borderColor;
@property(nonatomic) UILabel *placeHolderLabel;
@end
