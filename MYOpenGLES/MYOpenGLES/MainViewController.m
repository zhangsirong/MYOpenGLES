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
@synthesize shouldUseLinearFilter;
@synthesize shouldAnimate;
@synthesize shouldRepeatTexture;
@synthesize sCoordinateOffset;


typedef struct {
    GLKVector3  positionCoords;
    GLKVector2  textureCoords;
}
SceneVertex;

static SceneVertex vertices[] =
{
    {{-0.5f, -0.5f, 0.0}, {0.0f,0.0f}},          // 左下角
    {{ 0.5f, -0.5f, 0.0}, {1.0f,0.0f}},          // 右下角
    {{-0.5f,  0.5f, 0.0}, {0.0f,1.0f}}           // 左上角
};

static const SceneVertex defaultVertices[] =
{
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}},
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}},
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}},
};

static GLKVector3 movementVectors[3] =
{
    {-0.02f,  -0.01f, 0.0f},
    {0.01f,  -0.005f, 0.0f},
    {-0.01f,   0.01f, 0.0f},
};


#pragma mark - ViewLifeCycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.preferredFramesPerSecond = 60;

    [self configSubViews];
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
    
    CGImageRef imageRef = [UIImage imageNamed:@"grid.png"].CGImage;
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:imageRef options:nil error:NULL];
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
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
    [self.baseEffect prepareToDraw];
    [(MYEAGLContext *)view.context clear:GL_COLOR_BUFFER_BIT];
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
                           numberOfCoordinates:3
                                  attribOffset:offsetof(SceneVertex, positionCoords)
                                  shouldEnable:YES];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0
                           numberOfCoordinates:2
                                  attribOffset:offsetof(SceneVertex, textureCoords)
                                  shouldEnable:YES];
    
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
                        startVertexIndex:0
                        numberOfVertices:3];
}


#pragma mark - 刷新每帧

-(void)update
{
    [self updateAnimatedVertexPositions];
    [self updateTextureParameters];
    [vertexBuffer reinitWithAttribStride:sizeof(SceneVertex)
                        numberOfVertices:sizeof(vertices)/sizeof(SceneVertex)
                                   bytes:vertices];
}

-(void)updateTextureParameters
{
    [self.baseEffect.texture2d0 glkSetParameter:GL_TEXTURE_WRAP_S value:self.shouldRepeatTexture ? GL_REPEAT : GL_CLAMP_TO_EDGE];
    [self.baseEffect.texture2d0 glkSetParameter:GL_TEXTURE_MAG_FILTER value:self.shouldUseLinearFilter ? GL_LINEAR : GL_NEAREST];
}

-(void)updateAnimatedVertexPositions
{
    if (shouldAnimate) {
        for (int i = 0; i < 3; i++) {
            vertices[i].positionCoords.x += movementVectors[i].x;
            if(vertices[i].positionCoords.x >= 1.0f || vertices[i].positionCoords.x <= -1.0f) {
                movementVectors[i].x = -movementVectors[i].x;
            }
            
            vertices[i].positionCoords.y += movementVectors[i].y;
            if(vertices[i].positionCoords.y >= 1.0f || vertices[i].positionCoords.y <= -1.0f) {
                movementVectors[i].y = -movementVectors[i].y;
            }
            
            vertices[i].positionCoords.z += movementVectors[i].z;
            if(vertices[i].positionCoords.z >= 1.0f || vertices[i].positionCoords.z <= -1.0f) {
                movementVectors[i].z = -movementVectors[i].z;
            }
        }
    }else{
        for (int i = 0; i < 3; i++) {
            vertices[i].positionCoords.x = defaultVertices[i].positionCoords.x;
            vertices[i].positionCoords.y = defaultVertices[i].positionCoords.y;
            vertices[i].positionCoords.z = defaultVertices[i].positionCoords.z;
        }
    }
    
    for(int i = 0; i < 3; i++){
        vertices[i].textureCoords.s = (defaultVertices[i].textureCoords.s + sCoordinateOffset);
    }
}


#pragma mark - Private

-(void)configSubViews
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    UISwitch *shouldUseLinearFilterSwitch =  [[UISwitch alloc] initWithFrame:CGRectMake(20, 20, 100, 50)];
    [shouldUseLinearFilterSwitch addTarget:self action:@selector(takeShouldUseLinearFilterFrom:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shouldUseLinearFilterSwitch];
    UILabel *linearFilterlabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 100, 50)];
    linearFilterlabel.text = @"LinearFilter";
    [self.view addSubview:linearFilterlabel];
    
    UISwitch *shouldAnimateSwitch =  [[UISwitch alloc] initWithFrame:CGRectMake(20, screenHeight * 0.5 - 60, 100, 50)];
    [shouldAnimateSwitch addTarget:self action:@selector(takeShouldAnimateFrom:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shouldAnimateSwitch];
    UILabel *animateLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, screenHeight * 0.5 - 60, 100, 50)];
    animateLabel.text = @"Animate";
    [self.view addSubview:animateLabel];
    
    UISwitch *shouldRepeatTextureSwitch =  [[UISwitch alloc] initWithFrame:CGRectMake(20, screenHeight - 50, 100, 50)];
    [shouldRepeatTextureSwitch addTarget:self action:@selector(takeShouldRepeatTextureFrom:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shouldRepeatTextureSwitch];
    UILabel *repeatTexturelabel = [[UILabel alloc] initWithFrame:CGRectMake(100, screenHeight - 50, 100, 50)];
    repeatTexturelabel.text = @"RepeatTexture";
    [self.view addSubview:repeatTexturelabel];
    
    UISlider *sCoordinateOffsetSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, screenHeight * 0.5, screenWidth - 40, 50)];
    sCoordinateOffsetSlider.minimumValue = -1.0f;
    sCoordinateOffsetSlider.maximumValue = 1.0f;
    sCoordinateOffsetSlider.value = 0.0f;
    [sCoordinateOffsetSlider addTarget:self action:@selector(takeSCoordinateOffsetFrom:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:sCoordinateOffsetSlider];
}


#pragma mark - Event

-(void)takeShouldUseLinearFilterFrom:(UISwitch *)sender
{
    self.shouldUseLinearFilter = [sender isOn];
}

-(void)takeShouldAnimateFrom:(UISwitch *)sender
{
    self.shouldAnimate = [sender isOn];
}

-(void)takeShouldRepeatTextureFrom:(UISwitch *)sender
{
    self.shouldRepeatTexture = [sender isOn];
}

-(void)takeSCoordinateOffsetFrom:(UISlider *)sender
{
    self.sCoordinateOffset = [sender value];
}


@end
