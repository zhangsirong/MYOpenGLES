//
//  MYEAGLContext.m
//  MyOpenGLES
//
//  Created by admin on 16/11/28.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "MYEAGLContext.h"

@implementation MYEAGLContext

-(void)setClearColor:(GLKVector4)clearColorRGBA
{
    clearColor = clearColorRGBA;
    glClearColor(clearColorRGBA.r, clearColorRGBA.g, clearColorRGBA.b, clearColorRGBA.a);
}

-(GLKVector4)clearColor{
    return clearColor;
}

-(void)clear:(GLbitfield)mask
{
    glClear(mask);
}

-(void)enable:(GLenum)capability
{
    glEnable(capability);
}

-(void)disable:(GLenum)capability
{
    glDisable(capability);
}

-(void)setBlendSourceFunction:(GLenum)sfactor destinationFunction:(GLenum)dfactor
{
    glBlendFunc(sfactor, dfactor);
}


@end
