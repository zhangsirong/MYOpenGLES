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

@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (strong, nonatomic) GLKBaseEffect *extraEffect;
@property (strong, nonatomic) MYGLKVertexAttribArrayBuffer *vertexBuffer;
@property (strong, nonatomic) MYGLKVertexAttribArrayBuffer *extraBuffer;

@property (nonatomic) GLfloat centerVertexHeight;
@property (nonatomic) BOOL shouldUseFaceNormals;
@property (nonatomic) BOOL shouldDrawNormals;


@end
