//
//  MYEAGLContext.h
//  MyOpenGLES
//
//  Created by admin on 16/11/28.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface MYEAGLContext : EAGLContext
{
    GLKVector4 clearColor;
}

@property (nonatomic,assign) GLKVector4 clearColor;

-(void)clear:(GLbitfield)mask;
-(void)enable:(GLenum)capability;
-(void)disable:(GLenum)capability;
-(void)setBlendSourceFunction:(GLenum)sfactor destinationFunction:(GLenum)dfactor;

@end
