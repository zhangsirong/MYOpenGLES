//
//  MYGLKTextureLoader.m
//  MYOpenGLES
//
//  Created by admin on 16/11/29.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "MYGLKTextureLoader.h"
typedef enum
{
    MYGLK1 = 1,
    MYGLK2 = 2,
    MYGLK4 = 4,
    MYGLK8 = 8,
    MYGLK16 = 16,
    MYGLK32 = 32,
    MYGLK64 = 64,
    MYGLK128 = 128,
    MYGLK256 = 256,
    MYGLK512 = 512,
    MYGLK1024 = 1024,
}MYGLKPowerOf2;

static MYGLKPowerOf2 MYGLKCalculatePowerOf2ForDimension(GLuint dimension);
static NSData *MYGLKDataWithResizedCGImageBytes(CGImageRef cgImage, size_t *widthPtr, size_t *heightPtr);

@interface MYGLKTextureInfo (MYGLKTextureLoader)

- (id)initWithName:(GLuint)aName
            target:(GLenum)aTarget
             width:(GLuint)aWidth
            height:(GLuint)aHeight;

@end

@implementation MYGLKTextureInfo

@synthesize name;
@synthesize target;
@synthesize width;
@synthesize height;

- (id)initWithName:(GLuint)aName
            target:(GLenum)aTarget
             width:(GLuint)aWidth
            height:(GLuint)aHeight
{
    if (self = [super init])
    {
        name = aName;
        target = aTarget;
        width = aWidth;
        height = aHeight;
    }
    return self;
}

@end

@implementation MYGLKTextureLoader

+(MYGLKTextureInfo *)textureWithCGImage:(CGImageRef)cgImage
                                options:(NSDictionary *)options
                                  error:(NSError *__autoreleasing *)outError
{
    size_t width;
    size_t height;
    NSData *imageDate = MYGLKDataWithResizedCGImageBytes(cgImage, &width, &height);
    
    GLuint textureBufferID;
    glGenTextures(1, &textureBufferID);
    glBindTexture(GL_TEXTURE_2D, textureBufferID);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLuint)width, (GLuint)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, [imageDate bytes]);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    
    MYGLKTextureInfo *result = [[MYGLKTextureInfo alloc] initWithName:textureBufferID
                                                               target:GL_TEXTURE_2D
                                                                width:(GLuint)width
                                                               height:(GLuint)height];
    
    return result;
}

static NSData *MYGLKDataWithResizedCGImageBytes(CGImageRef cgImage, size_t *widthPtr, size_t *heightPtr)
{
    NSCParameterAssert(NULL != cgImage);
    NSCParameterAssert(NULL != widthPtr);
    NSCParameterAssert(NULL != heightPtr);
    
    GLuint originalWidth = (GLuint)CGImageGetWidth(cgImage);
    GLuint originalHeight = (GLuint)CGImageGetWidth(cgImage);
    
    NSCAssert(originalWidth > 0, @"无效的width");
    NSCAssert(originalHeight > 0, @"无效的height");
    
    
    GLuint width = MYGLKCalculatePowerOf2ForDimension(originalWidth);
    GLuint height = MYGLKCalculatePowerOf2ForDimension(originalHeight);
    
    NSMutableData *imageData = [NSMutableData dataWithLength:height * width * 4];
    NSCAssert(imageData != nil, @"无效的imageData");
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef cgContext = CGBitmapContextCreate([imageData mutableBytes],
                                                   width,
                                                   height,
                                                   8,
                                                   4 * width,
                                                   colorSpace,
                                                   kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    CGContextTranslateCTM(cgContext, 0, height);
    CGContextScaleCTM(cgContext, 1.0, -1.0);
    CGContextDrawImage(cgContext, CGRectMake(0, 0, width, height), cgImage);
    CGContextRelease(cgContext);
    *widthPtr = width;
    *heightPtr = height;
    return imageData;
}

static MYGLKPowerOf2 MYGLKCalculatePowerOf2ForDimension(GLuint dimension)
{
    MYGLKPowerOf2  result = MYGLK1;
    
    if(dimension > (GLuint)MYGLK512)    {
        result = MYGLK1024;
    }else if(dimension > (GLuint)MYGLK256){
        result = MYGLK512;
    }else if(dimension > (GLuint)MYGLK128){
        result = MYGLK256;
    }else if(dimension > (GLuint)MYGLK64){
        result = MYGLK128;
    }else if(dimension > (GLuint)MYGLK32){
        result = MYGLK64;
    }else if(dimension > (GLuint)MYGLK16){
        result = MYGLK32;
    }else if(dimension > (GLuint)MYGLK8){
        result = MYGLK16;
    }else if(dimension > (GLuint)MYGLK4){
        result = MYGLK8;
    }else if(dimension > (GLuint)MYGLK2){
        result = MYGLK4;
    }else if(dimension > (GLuint)MYGLK1){
        result = MYGLK2;
    }
    
    return result;
}

@end
