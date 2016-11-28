//
//  MYGLKView.h
//  MyOpenGLES
//
//  Created by admin on 16/11/28.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@class EAGLContext,MYGLKView;

@protocol MYGLKViewDelegate <NSObject>
@required
- (void)glkView:(MYGLKView *)view drawInRect:(CGRect)rect;

@end

typedef enum
{
    MYGLKViewDrawableDepthFormatNone = 0,
    MYGLKViewDrawableDepthFormat16,
} MYGLKViewDrawableDepthFormat;


@interface MYGLKView : UIView
{
    EAGLContext   *context;
    GLuint        defaultFrameBuffer;
    GLuint        colorRenderBuffer;
    GLuint        depthRenderBuffer;
    GLint         drawableWidth;
    GLint         drawableHeight;
}

@property (nonatomic, weak) id<MYGLKViewDelegate> delegate;
@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, readonly) NSInteger drawableWidth;
@property (nonatomic, readonly) NSInteger drawableHeight;
@property (nonatomic) MYGLKViewDrawableDepthFormat  drawableDepthFormat;

- (void)display;

@end
