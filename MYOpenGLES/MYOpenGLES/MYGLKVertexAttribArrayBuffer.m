//
//  MYGLKVertexAttribArrayBuffer.m
//  MyOpenGLES
//
//  Created by admin on 16/11/28.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "MYGLKVertexAttribArrayBuffer.h"

@interface MYGLKVertexAttribArrayBuffer ()

@property (nonatomic, assign) GLsizeiptr bufferSizeBytes;

@property (nonatomic, assign) GLsizei stride;

@end

@implementation MYGLKVertexAttribArrayBuffer
@synthesize name;
@synthesize bufferSizeBytes;
@synthesize stride;

-(id)initWithAttribStride:(GLsizei)aStride
         numberOfVertices:(GLsizei)count
                    bytes:(const GLvoid *)dataPtr
                    usage:(GLenum)usage
{
    if (nil != (self = [super init])) {
        stride = aStride;
        bufferSizeBytes = stride * count;
        glGenBuffers(1, &name);                                                 //1
        glBindBuffer(GL_ARRAY_BUFFER, self.name);                               //2
        glBufferData(GL_ARRAY_BUFFER, bufferSizeBytes, dataPtr, usage);         //3
    }
    return self;
}

-(void)reinitWithAttribStride:(GLsizei)aStride
             numberOfVertices:(GLsizei)count
                        bytes:(const GLvoid *)dataPtr
{
    self.stride = aStride;
    self.bufferSizeBytes = aStride * count;
    glBindBuffer(GL_ARRAY_BUFFER, self.name);                                   //2
    glBufferData(GL_ARRAY_BUFFER, bufferSizeBytes, dataPtr, GL_DYNAMIC_DRAW);   //3
}

-(void)prepareToDrawWithAttrib:(GLuint)index
           numberOfCoordinates:(GLint)count
                  attribOffset:(GLsizeiptr)offset
                  shouldEnable:(BOOL)shouldEnable
{
    glBindBuffer(GL_ARRAY_BUFFER, self.name);                                   //2
    if (shouldEnable) {
        glEnableVertexAttribArray(index);                                       //4
    }
    
    glVertexAttribPointer(index, count, GL_FLOAT, GL_FALSE, [self stride], NULL + offset); //5
    
#ifdef DEBUG
    {
        GLenum error = glGetError();
        if(GL_NO_ERROR != error)
        {
            NSLog(@"GL Error: 0x%x", error);
        }
    }
#endif
}

-(void)drawArrayWithMode:(GLenum)mode
        startVertexIndex:(GLint)first
        numberOfVertices:(GLsizei)count
{
    glDrawArrays(mode, first, count);
}

+(void)drawPreparedArraysWithMode:(GLenum)mode
                 startVertexIndex:(GLint)first
                 numberOfVertices:(GLsizei)count
{
    glDrawArrays(mode, first, count);                                           //6
}

-(void)dealloc
{
    if (0 != name) {
        glDeleteBuffers(1, &name);                                              //7
        name = 0;
    }
}

@end
