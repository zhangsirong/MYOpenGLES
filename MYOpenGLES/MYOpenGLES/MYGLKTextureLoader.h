//
//  MYGLKTextureLoader.h
//  MYOpenGLES
//
//  Created by admin on 16/11/29.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface MYGLKTextureInfo : NSObject
{
@private
    GLuint name;
    GLenum target;
    GLuint width;
    GLuint height;
}

@property (readonly) GLuint name;
@property (readonly) GLenum target;
@property (readonly) GLuint width;
@property (readonly) GLuint height;

@end

@interface MYGLKTextureLoader : NSObject

+(MYGLKTextureInfo *)textureWithCGImage:(CGImageRef)cgImage
                                options:(NSDictionary *)options
                                  error:(NSError **)outError;

@end

