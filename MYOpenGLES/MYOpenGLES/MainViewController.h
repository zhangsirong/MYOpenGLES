//
//  MainViewController.h
//  MYOpenGLES
//
//  Created by admin on 16/11/28.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <GLKit/GLKit.h>
@class MYGLKVertexAttribArrayBuffer;

@interface MainViewController : GLKViewController
{
    GLuint _program;
    
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    GLfloat _rotation;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    GLuint _texture0ID;
    GLuint _texture1ID;
}

@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (strong, nonatomic) MYGLKVertexAttribArrayBuffer *vertexBuffer;

@end
