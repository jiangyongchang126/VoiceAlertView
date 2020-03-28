//
//  UIView+Rect.h
//  Test
//
//  Created by ybd on 2019/4/27.
//  Copyright © 2019 ybd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Rect)

@property(nonatomic) CGFloat x;
@property(nonatomic) CGFloat y;
@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat top;
@property(nonatomic) CGFloat leading;
@property(nonatomic) CGFloat heading;

@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;

@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat bottom;

@property(nonatomic) CGFloat centerX;
@property(nonatomic) CGFloat centerY;

@property(nonatomic) CGPoint origin;

@property(nonatomic) CGSize size;

@end

NS_ASSUME_NONNULL_END
