//
//  ViewController.m
//  CRMotionViewDemo
//
//  Created by Christian Roman on 06/02/14.
//  Copyright (c) 2014 Christian Roman. All rights reserved.
//

#import "ViewController.h"
#import "CRMotionView.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    CRMotionView *motionView = [[CRMotionView alloc] initWithFrame:self.view.bounds];
    [motionView setImage:[UIImage imageNamed:@"Image"]];
    [self.view addSubview:motionView];
    
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
