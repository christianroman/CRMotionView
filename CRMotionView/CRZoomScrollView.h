//
//  CRZoomScrollView.h
//  CRMotionViewDemo
//
//  Created by Tanguy Aladenise on 2014-11-06.
//  Copyright (c) 2014 Christian Roman. All rights reserved.
//


@protocol CRZoomScrollViewDelegate;

#import <UIKit/UIKit.h>

@interface CRZoomScrollView : UIScrollView

@property (nonatomic, assign) id <CRZoomScrollViewDelegate> zoomDelegate;

@property (nonatomic) UIImage *image;
@property CGPoint startOffset;


- (id)initFromScrollView:(UIScrollView *)scrollView withImage:(UIImage *)image;

@end


@protocol CRZoomScrollViewDelegate <NSObject>

@optional
- (void)zoomScrollViewWillDismiss:(CRZoomScrollView *)zoomScrollView;
- (void)zoomScrollViewDidDismiss:(CRZoomScrollView *)zoomScrollView;

@end
