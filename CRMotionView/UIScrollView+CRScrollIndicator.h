//
//  UIScrollView+CRScrollIndicator.h
//  CRMotionView
//
//  Created by Christian Roman on 07/02/14.
//  Copyright (c) 2014 Christian Roman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (CRScrollIndicator)

- (void)cr_enableScrollIndicator;
- (void)cr_disableScrollIndicator;
- (void)cr_refreshScrollIndicator;

@end
