//
//  CRMotionView.m
//  CRMotionView
//
//  Created by Christian Roman on 06/02/14.
//  Copyright (c) 2014 Christian Roman. All rights reserved.
//

#import "CRMotionView.h"
#import "CRZoomScrollView.h"
#import "UIScrollView+CRScrollIndicator.h"

#define isLandscape UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])


@import CoreMotion;

static const CGFloat CRMotionViewRotationMinimumTreshold = 0.1f;
static const CGFloat CRMotionGyroUpdateInterval = 1 / 100;
static const CGFloat CRMotionViewRotationFactor = 4.0f;

@interface CRMotionView () <CRZoomScrollViewDelegate, UIScrollViewDelegate>

@property (nonatomic, assign) CGRect viewFrame;

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) CRZoomScrollView *zoomScrollView;

@property (nonatomic, assign) CGFloat motionRate;
@property (nonatomic, assign) NSInteger minimumXOffset;
@property (nonatomic, assign) NSInteger maximumXOffset;
@property (nonatomic, assign) BOOL stopTracking;

@end

@implementation CRMotionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _viewFrame = CGRectMake(0.0, 0.0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        [self commonInit];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    self = [self initWithFrame:frame];
    if (self) {
        [self setImage:image];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame contentView:(UIView *)contentView;
{
    self = [self initWithFrame:frame];
    if (self) {
        [self setContentView:contentView];
    }
    return self;
}


- (void)commonInit
{
    _scrollView = [[UIScrollView alloc] initWithFrame:_viewFrame];
    [_scrollView setScrollEnabled:NO];
    [_scrollView setBounces:NO];
    [_scrollView setContentSize:CGSizeZero];
    [_scrollView setExclusiveTouch:YES];
    [self addSubview:_scrollView];
    
    _containerView = [[UIView alloc] initWithFrame:_viewFrame];
    [_containerView setClipsToBounds:YES];
    [_scrollView addSubview:_containerView];
    
    
    _minimumXOffset = 0;
    
    _motionEnabled = YES;
    _zoomEnabled   = YES;
    _scrollDragEnabled = NO;
    _scrollBounceEnabled = NO;
    [self startMonitoring];
    
    // Tap gesture to open zoomable view
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGesture];
}


#pragma mark - UI actions


- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    // Only work if the content view is an image
    if ([self.contentView isKindOfClass:[UIImageView class]] && self.isZoomEnabled) {
        
        UIImageView *imageView = (UIImageView *)self.contentView;
        if (CGRectGetWidth(self.contentView.frame) >= imageView.image.size.width) {
            return;
        }
        
        // Stop motion to avoid transition jump between two views
        //        [self stopMonitoring];
        
        
        
        // Init and setup the zoomable scroll view
        self.zoomScrollView = [[CRZoomScrollView alloc] initFromScrollView:self.scrollView withImage:imageView.image];
        self.zoomScrollView.zoomDelegate = self;
        
        [self addSubview:self.zoomScrollView];
    }
}


#pragma mark - Setters

- (void)setContentView:(UIView *)contentView
{
    if (_contentView) {
        [_contentView removeFromSuperview];
    }
    
    CGFloat width = _viewFrame.size.height / contentView.frame.size.height * contentView.frame.size.width;
    [contentView setFrame:CGRectMake(0, 0, width, _viewFrame.size.height)];
    [_containerView addSubview:contentView];
    CGRect frame = _containerView.frame;
    frame.size.width = contentView.frame.size.width;
    [_containerView setFrame:frame];
    [self setScrollIndicatorEnabled:_scrollIndicatorEnabled];
    
    NSDictionary *view = NSDictionaryOfVariableBindings(contentView);
    
    [_containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:nil views:view]];
    [_containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:view]];
    
    _scrollView.contentSize = CGSizeMake(contentView.frame.size.width, _scrollView.frame.size.height);
    _scrollView.contentOffset = CGPointMake((_scrollView.contentSize.width - _scrollView.frame.size.width) / 2, 0);
    
    [_scrollView cr_enableScrollIndicator];
    
    _motionRate = contentView.frame.size.width / _viewFrame.size.width * CRMotionViewRotationFactor;
    _maximumXOffset = _scrollView.contentSize.width - _scrollView.frame.size.width;
    
    _contentView = contentView;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self setContentView:imageView];
}

- (void)setMotionEnabled:(BOOL)motionEnabled
{
    _motionEnabled = motionEnabled;
    if (_motionEnabled) {
        [self startMonitoring];
    } else {
        [self stopMonitoring];
    }
}

- (void)setScrollIndicatorEnabled:(BOOL)scrollIndicatorEnabled
{
    _scrollIndicatorEnabled = scrollIndicatorEnabled;
    if (scrollIndicatorEnabled) {
        [_scrollView cr_enableScrollIndicator];
    } else {
        [_scrollView cr_disableScrollIndicator];
    }
}

- (void)setScrollDragEnabled:(BOOL)scrollDragEnabled
{
    _scrollDragEnabled = scrollDragEnabled;
    
    if (scrollDragEnabled) {
        [_scrollView setScrollEnabled:YES];
        [_scrollView setDelegate:self];
    } else {
        [_scrollView setScrollEnabled:NO];
        [_scrollView setDelegate:nil];
    }
}

- (void)setScrollBounceEnabled:(BOOL)scrollBounceEnabled
{
    _scrollBounceEnabled = scrollBounceEnabled;
    
    [_scrollView setBounces:scrollBounceEnabled];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (_motionEnabled) [self stopMonitoring];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.delegate scrollViewDidScrollToOffset:self.scrollView.contentOffset];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (_motionEnabled) [self startMonitoring];
}

#pragma mark - ZoomScrollView delegate

// When user dismisses zoomable view, put back motion tracking
- (void)zoomScrollViewWillDismiss:(CRZoomScrollView *)zoomScrollView
{
    self.stopTracking = YES;
}

// When user dismisses zoomable view, put back motion tracking
- (void)zoomScrollViewDidDismiss:(CRZoomScrollView *)zoomScrollView
{
    // Put back motion if it was enabled
    self.stopTracking = NO;
}

#pragma mark - Core Motion

- (void)startMonitoring
{
    if ([self.contentView isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)self.contentView;
        if (CGRectGetWidth(self.contentView.frame) >= imageView.image.size.width) {
            return;
        }
    }
    
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.gyroUpdateInterval = CRMotionGyroUpdateInterval;
    }
    
    if (![_motionManager isGyroActive] && [_motionManager isGyroAvailable] ) {
        [_motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                    withHandler:^(CMGyroData *gyroData, NSError *error) {
                                        CGFloat rotationRate = isLandscape ? gyroData.rotationRate.x : gyroData.rotationRate.y;
                                        if (fabs(rotationRate) >= CRMotionViewRotationMinimumTreshold) {
                                            CGFloat offsetX = _scrollView.contentOffset.x - rotationRate * _motionRate;
                                            if (offsetX > _maximumXOffset) {
                                                offsetX = _maximumXOffset;
                                            } else if (offsetX < _minimumXOffset) {
                                                offsetX = _minimumXOffset;
                                            }
                                            
                                            if (!self.stopTracking) {
                                                [UIView animateWithDuration:0.3f
                                                                      delay:0.0f
                                                                    options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut
                                                                 animations:^{
                                                                     [_scrollView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
                                                                     self.zoomScrollView.startOffset = CGPointMake(offsetX, 0);
                                                                 }
                                                                 completion:nil];
                                            }
                                            
                                        }
                                    }];
    } else {
        NSLog(@"There is not available gyro.");
    }
}

- (void)stopMonitoring
{
    [_motionManager stopGyroUpdates];
}

- (void)dealloc
{
    [self.scrollView cr_disableScrollIndicator];
}

@end
