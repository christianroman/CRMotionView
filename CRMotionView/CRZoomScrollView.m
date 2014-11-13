//
//  CRZoomScrollView.m
//  CRMotionViewDemo
//
//  Created by Tanguy Aladenise on 2014-11-06.
//  Copyright (c) 2014 Tanguy Aladenise. All rights reserved.
//

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

static float const kTransitionAnimationDuration = .4;
static float const kAnimationDumping            = .8;

#import "CRZoomScrollView.h"

@interface CRZoomScrollView() <UIScrollViewDelegate>


@property (nonatomic) UIImageView *imageView;

@property BOOL allowCentering;

// The zoom scale required to show image with full height
@property CGRect motionFrame;

@end

@implementation CRZoomScrollView


- (id)init
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


- (id)initFromScrollView:(UIScrollView *)scrollView withImage:(UIImage *)image;
{
    self = [self initWithFrame:scrollView.frame];
    if (self) {
        self.startOffset = scrollView.contentOffset;
        self.image       = image;
    }
    
    return self;
}


- (void)initialization
{
    self.delegate        = self;
    self.backgroundColor = [UIColor blackColor];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGesture];
}


#pragma mark - UI actions


- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    if ([self.zoomDelegate respondsToSelector:@selector(zoomScrollViewWillDismiss:)]) {
        [self.zoomDelegate zoomScrollViewWillDismiss:self];
    }
    
    self.allowCentering = NO;
    [UIView animateWithDuration:kTransitionAnimationDuration delay:0 usingSpringWithDamping:kAnimationDumping initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentOffset   = self.startOffset;
        self.imageView.frame = self.motionFrame;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.1 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            if ([self.zoomDelegate respondsToSelector:@selector(zoomScrollViewDidDismiss:)]) {
                [self.zoomDelegate zoomScrollViewDidDismiss:self];
            }
        }];
    }];
    
}


#pragma mark - Zoom mechanics


- (void)prepareZoomScrollView
{
    CGRect scrollViewFrame = self.frame;
    CGFloat scaleWidth     = scrollViewFrame.size.width / self.contentSize.width;
    CGFloat scaleHeight    = scrollViewFrame.size.height / self.contentSize.height;
    CGFloat minScale       = MIN(scaleWidth, scaleHeight);
    
    self.minimumZoomScale    = minScale;
    self.maximumZoomScale = 1.0f;
    
    // Setup the scrollview to be exactly like the motion view (zoom scale and position)
    self.zoomScale     = (minScale * CGRectGetHeight(self.bounds)) / (minScale * self.imageView.image.size.height);;
    self.contentOffset = self.startOffset;
    self.motionFrame   = self.imageView.frame;
    
    // Animate to init state
    [UIView animateWithDuration:kTransitionAnimationDuration delay:0 usingSpringWithDamping:kAnimationDumping initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.zoomScale = minScale;
    } completion:^(BOOL finished) {
        self.allowCentering = YES;
    }];
    
    
    [self centerScrollViewContents];
}



- (void)centerScrollViewContents
{
    CGSize boundsSize    = self.bounds.size;
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


#pragma mark - Scrollview delegate for zooming


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (self.allowCentering || SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        NSLog(@"autoamic center");
        [self centerScrollViewContents];
    }
}


#pragma mark - Setters


- (void)setImage:(UIImage *)image
{
    // Force setup for zoomable imageView
    _image           = image;
    _imageView       = [[UIImageView alloc] initWithImage:_image];
    _imageView.frame = (CGRect){.origin = CGPointMake(0, 0), .size = _imageView.image.size};
    
    [self addSubview:_imageView];
    
    // Change contentsize accordingly
    self.contentSize = _imageView.image.size;
    
    [self prepareZoomScrollView];
}
@end
