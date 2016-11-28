//
//  MYGLKVertexAttribArrayBuffer.h
//  MyOpenGLES
//
//  Created by admin on 16/11/28.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <GLKit/GLKit.h>

typedef enum {
    MYGLKVertexAttribPosition = GLKVertexAttribPosition,
    MYGLKVertexAttribNormal = GLKVertexAttribNormal,
    MYGLKVertexAttribColor = GLKVertexAttribColor,
    MYGLKVertexAttribTexCoord0 = GLKVertexAttribTexCoord0,
    MYGLKVertexAttribTexCoord1 = GLKVertexAttribTexCoord1,
} MYGLKVertexAttrib;


@interface MYGLKVertexAttribArrayBuffer : NSObject
{
    GLuint       name;
    GLsizeiptr   bufferSizeBytes;
    GLsizei      stride;
}

@property (nonatomic,readonly) GLuint name;
@property (nonatomic,readonly) GLsizeiptr bufferSizeBytes;
@property (nonatomic,readonly) GLsizei stride;

+(void)drawPreparedArraysWithMode:(GLenum)mode
                 startVertexIndex:(GLint)first
                 numberOfVertices:(GLsizei)count;

-(id)initWithAttribStride:(GLsizei)stride
        numberOfVertices:(GLsizei)count
                    bytes:(const GLvoid *)dataPtr
                    usage:(GLenum)usage;

-(void)prepareToDrawWithAttrib:(GLuint)index
        numberOfCoordinates:(GLint)count
                attribOffset:(GLsizeiptr)offset
                shouldEnable:(BOOL)shouldEnable;

-(void)drawArrayWithMode:(GLenum)mode
        startVertexIndex:(GLint)first
        numberOfVertices:(GLsizei)count;

-(void)reinitWithAttribStride:(GLsizei)stride
             numberOfVertices:(GLsizei)count
                        bytes:(const GLvoid *)dataPtr;

@end
