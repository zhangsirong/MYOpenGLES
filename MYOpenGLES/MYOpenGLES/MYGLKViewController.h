//
//  MYGLKViewController.h
//  MyOpenGLES
//
//  Created by admin on 16/11/28.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYGLKView.h"

@interface MYGLKViewController : UIViewController<MYGLKViewDelegate>
{
    CADisplayLink     *displayLink;
    NSInteger         preferredFramesPerSecond;
}

@property (nonatomic) NSInteger preferredFramesPerSecond;
@property (nonatomic, readonly) NSInteger framesPerSecond;
@property (nonatomic, getter=isPaused) BOOL paused;


@end
