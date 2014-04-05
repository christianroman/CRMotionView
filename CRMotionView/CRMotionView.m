//
//  CRMotionView.m
//  CRMotionView
//
//  Created by Christian Roman on 06/02/14.
//  Copyright (c) 2014 Christian Roman. All rights reserved.
//

#import "CRMotionView.h"
#import "UIScrollView+CRScrollIndicator.h"

@import CoreMotion;

static const CGFloat CRMotionViewRotationMinimumTreshold = 0.1f;
static const CGFloat CRMotionGyroUpdateInterval = 1 / 100;
static const CGFloat CRMotionViewRotationFactor = 4.0f;

@interface CRMotionView ()

@property (nonatomic, assign) CGRect viewFrame;

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) CGFloat motionRate;
@property (nonatomic, assign) NSInteger minimumXOffset;
@property (nonatomic, assign) NSInteger maximumXOffset;

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

- (void)commonInit
{
    _scrollView = [[UIScrollView alloc] initWithFrame:_viewFrame];
    [_scrollView setUserInteractionEnabled:NO];
    [_scrollView setBounces:NO];
    [_scrollView setContentSize:CGSizeZero];
    [self addSubview:_scrollView];
    
    _imageView = [[UIImageView alloc] initWithFrame:_viewFrame];
    [_imageView setBackgroundColor:[UIColor blackColor]];
    [_scrollView addSubview:_imageView];
    
    _minimumXOffset = 0;
    
    _scrollIndicatorEnabled = YES;
    
    [self startMonitoring];
}

#pragma mark - Setters

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    CGFloat width = _viewFrame.size.height / _image.size.height * _image.size.width;
    [_imageView setFrame:CGRectMake(0, 0, width, _viewFrame.size.height)];
    [_imageView setBackgroundColor:[UIColor blackColor]];
    [_imageView setImage:_image];
    
    _scrollView.contentSize = CGSizeMake(_imageView.frame.size.width, _scrollView.frame.size.height);
    _scrollView.contentOffset = CGPointMake((_scrollView.contentSize.width - _scrollView.frame.size.width) / 2, 0);
    
    [_scrollView cr_enableScrollIndicator];
    
    _motionRate = _image.size.width / _viewFrame.size.width * CRMotionViewRotationFactor;
    _maximumXOffset = _scrollView.contentSize.width - _scrollView.frame.size.width;
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

#pragma mark - Core Motion

- (void)startMonitoring
{
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.gyroUpdateInterval = CRMotionGyroUpdateInterval;
    }
    
    if (![_motionManager isGyroActive] && [_motionManager isGyroAvailable]) {
        [_motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                    withHandler:^(CMGyroData *gyroData, NSError *error) {
                                        CGFloat rotationRate = gyroData.rotationRate.y;
                                        if (fabs(rotationRate) >= CRMotionViewRotationMinimumTreshold) {
                                            CGFloat offsetX = _scrollView.contentOffset.x - rotationRate * _motionRate;
                                            if (offsetX > _maximumXOffset) {
                                                offsetX = _maximumXOffset;
                                            } else if (offsetX < _minimumXOffset) {
                                                offsetX = _minimumXOffset;
                                            }
                                            [UIView animateWithDuration:0.3f
                                                                  delay:0.0f
                                                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut
                                                             animations:^{
                                                                 [_scrollView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
                                            }
                                                             completion:nil];
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
