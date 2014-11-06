//
//  CRZoomScrollView.m
//  CRMotionViewDemo
//
//  Created by Tanguy Aladenise on 2014-11-06.
//  Copyright (c) 2014 Christian Roman. All rights reserved.
//

static float const kTransitionAnimationDuration = .4;
static float const kAnimationDumping = .8;

#import "CRZoomScrollView.h"

@interface CRZoomScrollView() <UIScrollViewDelegate>

@property float fullHeightZoomScale;

@end

@implementation CRZoomScrollView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialization];
    }
    
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialization];
    }
    
    return self;
}


- (void)initialization
{
    self.delegate = self;
    self.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    if ([self.zoomDelegate respondsToSelector:@selector(zoomScrollViewWillDismiss:)]) {
        [self.zoomDelegate zoomScrollViewWillDismiss:self];
    }

    [UIView animateWithDuration:kTransitionAnimationDuration delay:0 usingSpringWithDamping:kAnimationDumping initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.zoomScale = self.fullHeightZoomScale;
        self.contentOffset = self.startOffset;
    } completion:^(BOOL finished) {
        if ([self.zoomDelegate respondsToSelector:@selector(zoomScrollViewDidDismiss:)]) {
            [self.zoomDelegate zoomScrollViewDidDismiss:self];
        }
        [UIView animateWithDuration:0.1 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
}

- (void)prepareZoomScrollView
{
    CGRect scrollViewFrame = self.frame;
    CGFloat scaleWidth  = scrollViewFrame.size.width / self.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.contentSize.height;
    CGFloat minScale    = MIN(scaleWidth, scaleHeight);
    self.minimumZoomScale = minScale;
    self.fullHeightZoomScale = (minScale * CGRectGetHeight(self.bounds)) / (minScale * self.imageView.image.size.height);
    self.zoomScale = self.fullHeightZoomScale;
    self.contentOffset = self.startOffset;

    [UIView animateWithDuration:kTransitionAnimationDuration delay:0 usingSpringWithDamping:kAnimationDumping initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.zoomScale = minScale;
    } completion:nil];

    self.maximumZoomScale = 1.0f;
    
    [self centerScrollViewContents];
}

- (void)setImageView:(UIImageView *)imageView
{
    _imageView = imageView;
    _imageView.frame = (CGRect){.origin = CGPointMake(0, 0), .size = _imageView.image.size};
    
    [self addSubview:_imageView];
    self.contentSize = _imageView.image.size;
    
    [self prepareZoomScrollView];
}


- (void)centerScrollViewContents {
    CGSize boundsSize = self.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageView.frame = contentsFrame;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that you want to zoom
    return self.imageView;
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView {

    // The scroll view has zoomed, so you need to re-center the contents
    [self centerScrollViewContents];
}
@end
