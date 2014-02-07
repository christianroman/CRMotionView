//
//  CRMotionView.h
//  CRMotionView
//
//  Created by Christian Roman on 06/02/14.
//  Copyright (c) 2014 Christian Roman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRMotionView : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign, getter = isMotionEnabled) BOOL motionEnabled;

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;

@end
