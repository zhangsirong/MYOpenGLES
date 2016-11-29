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
    MYGLKVertexAttribArrayBuffer *vertexBuffer;
}

@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (strong, nonatomic) MYGLKVertexAttribArrayBuffer *vertexBuffer;
@property (strong, nonatomic) GLKTextureInfo *textureInfo0;
@property (strong, nonatomic) GLKTextureInfo *textureInfo1;

@end
