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


@interface GLKEffectPropertyTexture (MYGLKAdditions)

- (void)glkSetParameter:(GLenum)parameterID
                  value:(GLint)value;

@end

@implementation GLKEffectPropertyTexture (MYGLKAdditions)

- (void)glkSetParameter:(GLenum)parameterID
                  value:(GLint)value;
{
    glBindTexture(self.target, self.name);
    glTexParameteri(self.target, parameterID, value);
}

@end


@interface MainViewController ()

@end

@implementation MainViewController
@synthesize baseEffect;
@synthesize vertexBuffer;


typedef struct {
    GLKVector3  positionCoords;
    GLKVector2  textureCoords;
}
SceneVertex;

static const SceneVertex vertices[] =
{
    {{-1.0f, -0.67f, 0.0f}, {0.0f, 0.0f}},  // 第一个三角形
    {{ 1.0f, -0.67f, 0.0f}, {1.0f, 0.0f}},
    {{-1.0f,  0.67f, 0.0f}, {0.0f, 1.0f}},
    {{ 1.0f, -0.67f, 0.0f}, {1.0f, 0.0f}},  // 第二个三角形
    {{-1.0f,  0.67f, 0.0f}, {0.0f, 1.0f}},
    {{ 1.0f,  0.67f, 0.0f}, {1.0f, 1.0f}},
};


#pragma mark - ViewLifeCycle

-(void)viewDidLoad
{
    [super viewDidLoad];

    GLKView *view = (GLKView *)self.view;
    view.context = [[MYEAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);                     //着色语言 三角形颜色
    
    ((MYEAGLContext *)view.context).clearColor = GLKVector4Make(0.0f, 1.0, 0.0f, 0.3f);      //背景
    
    self.vertexBuffer = [[MYGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(SceneVertex)
                                                                  numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)
                                                                             bytes:vertices
                                                                             usage:GL_STATIC_DRAW];
    
    NSDictionary *options = @{GLKTextureLoaderOriginBottomLeft : [NSNumber numberWithBool:YES]};

    CGImageRef imageRef0 = [UIImage imageNamed:@"leaves.gif"].CGImage;
    self.textureInfo0 = [GLKTextureLoader textureWithCGImage:imageRef0 options:options error:NULL];
    CGImageRef imageRef1 = [UIImage imageNamed:@"beetle.png"].CGImage;
    self.textureInfo1 = [GLKTextureLoader textureWithCGImage:imageRef1 options:options error:NULL];
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
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


#pragma mark - GLKViewDelegate

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [(MYEAGLContext *)view.context clear:GL_COLOR_BUFFER_BIT];
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
                           numberOfCoordinates:3
                                  attribOffset:offsetof(SceneVertex, positionCoords)
                                  shouldEnable:YES];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0
                           numberOfCoordinates:2
                                  attribOffset:offsetof(SceneVertex, textureCoords)
                                  shouldEnable:YES];
    
    self.baseEffect.texture2d0.name = self.textureInfo0.name;
    self.baseEffect.texture2d0.target = self.textureInfo0.target;
    [self.baseEffect prepareToDraw];
    
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
                        startVertexIndex:0
                        numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)];
    
    self.baseEffect.texture2d0.name = self.textureInfo1.name;
    self.baseEffect.texture2d0.target = self.textureInfo1.target;
    [self.baseEffect prepareToDraw];
    
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
                        startVertexIndex:0
                        numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)];
    
}


@end
