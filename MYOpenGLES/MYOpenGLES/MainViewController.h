//
//  MainViewController.h
//  MYOpenGLES
//
//  Created by admin on 16/11/28.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface MainViewController : GLKViewController
{
    GLuint vertexBufferID;
}

@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@end
