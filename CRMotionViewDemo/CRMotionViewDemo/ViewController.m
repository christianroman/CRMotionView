//
//  ViewController.m
//  CRMotionViewDemo
//
//  Created by Christian Roman on 06/02/14.
//  Copyright (c) 2014 Christian Roman. All rights reserved.
//

#import "ViewController.h"
#import "CRMotionView.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (CRMotionView *)motionViewWithImage
{
    CRMotionView *motionView = [[CRMotionView alloc] initWithFrame:self.view.bounds];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Image"]];
    [motionView setContentView:imageView];
    [self.view addSubview:motionView];
    return motionView;
}


- (CRMotionView *)motionViewWithVideo
{
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"mov_bbb" ofType:@"mp4"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];

    AVPlayer *player = [AVPlayer playerWithURL:movieURL];
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;

    AVPlayerLayer *layer = [AVPlayerLayer layer];

    [layer setPlayer:player];
    [layer setFrame:CGRectMake(0, 0, 1033, 568)];
    [layer setBackgroundColor:[UIColor redColor].CGColor];
    [layer setVideoGravity:AVLayerVideoGravityResizeAspectFill];

    UIView *playerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1033, 568)];
    [playerView.layer addSublayer:layer];

    CRMotionView *motionView = [[CRMotionView alloc] initWithFrame:self.view.bounds];

    [motionView setContentView:playerView];
    [self.view addSubview:motionView];

    [player play];

    return motionView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    CRMotionView *motionView = [self motionViewWithImage];
    //CRMotionView *motionView = [self motionViewWithVideo];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, self.view.frame.size.height - 50, 110, 20)];
    [titleLabel setText:@"CRMotionView"];
    [titleLabel setShadowOffset:CGSizeMake(0, 1.0f)];
    [titleLabel setShadowColor:[[UIColor blackColor] colorWithAlphaComponent:0.2f]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
    [motionView addSubview:titleLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
