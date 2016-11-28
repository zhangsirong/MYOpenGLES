//
//  MainViewController.h
//  MYOpenGLES
//
//  Created by admin on 16/11/28.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "MYGLKViewController.h"
#import <GLKit/GLKit.h>

@interface MainViewController : MYGLKViewController
{
    GLuint vertexBufferID;
}

@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@end
