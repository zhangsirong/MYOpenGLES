//
//  MYGLKViewController.m
//  MyOpenGLES
//
//  Created by admin on 16/11/28.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "MYGLKViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation MYGLKViewController

static const NSInteger kMYGLKDefaultFramesPerSecond = 30;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawView:)];
        self.preferredFramesPerSecond = kMYGLKDefaultFramesPerSecond;
        
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.paused = NO;
    }
    return self;
}

-(id)initWithCoder:(NSCoder*)coder
{
    if (nil != (self = [super initWithCoder:coder]))
    {
        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawView:)];
        self.preferredFramesPerSecond = kMYGLKDefaultFramesPerSecond;
        
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.paused = NO;
    }
    
    return self;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    MYGLKView *view = [[MYGLKView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = view;
    view.opaque = YES;
    view.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.paused = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.paused = YES;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    }else{
        return YES;
    }
}

-(void)drawView:(id)sender
{
    [(MYGLKView *)self.view display];
}

-(NSInteger)framesPerSecond
{
    return 60 / displayLink.frameInterval;
}

-(NSInteger)preferredFramesPerSecond
{
    return preferredFramesPerSecond;
}

- (void)setPreferredFramesPerSecond:(NSInteger)aValue
{
    preferredFramesPerSecond = aValue;
    displayLink.frameInterval = MAX(1, (60 / aValue));
}

-(BOOL)isPaused
{
    return displayLink.paused;
}

-(void)setPaused:(BOOL)aValue
{
    displayLink.paused = aValue;
}

-(void)glkView:(MYGLKView *)view drawInRect:(CGRect)rect
{
    
}

@end
