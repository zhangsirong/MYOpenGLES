//
//  MainViewController.m
//  MYOpenGLES
//
//  Created by admin on 16/11/28.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "MainViewController.h"
#import "MYEAGLContext.h"
#import "MYGLKVertexAttribArrayBuffer.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize baseEffect;
@synthesize vertexBuffer;


typedef struct {
    GLKVector3  positionCoords;
}
SceneVertex;

static const SceneVertex vertices[] =
{
    {{-0.5f, -0.5f, 0.0}}, // lower left corner
    {{ 0.5f, -0.5f, 0.0}}, // lower right corner
    {{-0.5f,  0.5f, 0.0}}  // upper left corner
};

-(void)viewDidLoad
{
    [super viewDidLoad];
    GLKView *view = (GLKView *)self.view;
    
    view.context = [[MYEAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0, 0.0f, 0.0f, 1.0f);                     //着色语言 三角形颜色
    
    ((MYEAGLContext *)view.context).clearColor = GLKVector4Make(0.0f, 0.0f, 1.0f, 1.0f);      //背景
    
    self.vertexBuffer = [[MYGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(SceneVertex)
                                                                  numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)
                                                                             bytes:vertices
                                                                             usage:GL_STATIC_DRAW];
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.baseEffect prepareToDraw];
    [(MYEAGLContext *)view.context clear:GL_COLOR_BUFFER_BIT];
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
                           numberOfCoordinates:3
                                  attribOffset:offsetof(SceneVertex, positionCoords)
                                  shouldEnable:YES];
    
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
                        startVertexIndex:0
                        numberOfVertices:3];
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    
    GLKView *view = (GLKView *)self.view;
    [MYEAGLContext setCurrentContext:view.context];
    self.vertexBuffer = nil;
    view.context = nil;
    [EAGLContext setCurrentContext:nil];
}
@end
