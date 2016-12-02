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

typedef struct {
    GLKVector3  position;
    GLKVector2  textureCoords;
}
SceneVertex;

typedef struct {
    SceneVertex vertices[3];
}SceneTriangle;

static SceneVertex vertexA = {{-0.5,  0.5, -0.5}, {0.0, 1.0}};
static SceneVertex vertexB = {{-0.5,  0.0, -0.5}, {0.0, 0.5}};
static SceneVertex vertexC = {{-0.5, -0.5, -0.5}, {0.0, 0.0}};
static SceneVertex vertexD = {{ 0.0,  0.5, -0.5}, {0.5, 1.0}};
static SceneVertex vertexE = {{ 0.0,  0.0,  0.0}, {0.5, 0.5}};
static SceneVertex vertexF = {{ 0.0, -0.5, -0.5}, {0.5, 0.0}};
static SceneVertex vertexG = {{ 0.5,  0.5, -0.5}, {1.0, 1.0}};
static SceneVertex vertexH = {{ 0.5,  0.0, -0.5}, {1.0, 0.5}};
static SceneVertex vertexI = {{ 0.5, -0.5, -0.5}, {1.0, 0.0}};

#define NUM_FACES (8)                               //8个面

static SceneTriangle SceneTriangleMake(const SceneVertex vertexA,
                                       const SceneVertex vertexB,
                                       const SceneVertex vertexC);


@interface MainViewController ()
{
    SceneTriangle triangles[NUM_FACES];
}

@end

@implementation MainViewController

@synthesize baseEffect;
@synthesize vertexBuffer;
@synthesize blandTextureInfo;
@synthesize interestingTextureInfo;
@synthesize shouldUseDetailLighting;

#pragma mark - ViewLifeCycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self configSubViews];
    GLKView *view = (GLKView *)self.view;
    view.context = [[MYEAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [MYEAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0, 1.0, 1.0, 1.0);
    
    {
        GLKMatrix4 modelViewMatrix = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(-60.0f), 1.0f, 0.0f, 0.0f);
        modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(-30.0f), 0.0f, 0.0f, 1.0f);
        modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, 0.0f, 0.0f, 0.25f);
        self.baseEffect.transform.modelviewMatrix = modelViewMatrix;
    }
    
    CGImageRef blandSimulatedLightingImageRef = [[UIImage imageNamed:@"Lighting256x256.png"] CGImage];
    blandTextureInfo = [GLKTextureLoader textureWithCGImage:blandSimulatedLightingImageRef
                                                    options:@{GLKTextureLoaderOriginBottomLeft : [NSNumber numberWithBool:YES]}
                                                      error:NULL];
    
    CGImageRef interestingSimulatedLightingImageRef = [[UIImage imageNamed:@"LightingDetail256x256.png"] CGImage];
    interestingTextureInfo = [GLKTextureLoader textureWithCGImage:interestingSimulatedLightingImageRef
                                                    options:@{GLKTextureLoaderOriginBottomLeft : [NSNumber numberWithBool:YES]}
                                                      error:NULL];
    
    ((MYEAGLContext *)view.context).clearColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);      //背景
    triangles[0] = SceneTriangleMake(vertexA, vertexB, vertexD);
    triangles[1] = SceneTriangleMake(vertexB, vertexC, vertexF);
    triangles[2] = SceneTriangleMake(vertexD, vertexB, vertexE);
    triangles[3] = SceneTriangleMake(vertexE, vertexB, vertexF);
    triangles[4] = SceneTriangleMake(vertexD, vertexE, vertexH);
    triangles[5] = SceneTriangleMake(vertexE, vertexF, vertexH);
    triangles[6] = SceneTriangleMake(vertexG, vertexD, vertexH);
    triangles[7] = SceneTriangleMake(vertexH, vertexF, vertexI);
    
    self.vertexBuffer = [[MYGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(SceneVertex)
                                                                  numberOfVertices:sizeof(triangles) / sizeof(SceneVertex)
                                                                             bytes:triangles
                                                                             usage:GL_DYNAMIC_DRAW];
    self.shouldUseDetailLighting = YES;
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    
    GLKView *view = (GLKView *)self.view;
    [MYEAGLContext setCurrentContext:view.context];
    self.vertexBuffer = nil;
    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
}

#pragma mark - GLKViewDelegate

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    if (self.shouldUseDetailLighting) {
        self.baseEffect.texture2d0.name = interestingTextureInfo.name;
        self.baseEffect.texture2d0.target = interestingTextureInfo.target;
    }else{
        self.baseEffect.texture2d0.name = blandTextureInfo.name;
        self.baseEffect.texture2d0.target = blandTextureInfo.target;
    }

    [self.baseEffect prepareToDraw];
    [(MYEAGLContext *)view.context clear:GL_COLOR_BUFFER_BIT];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
                           numberOfCoordinates:3
                                  attribOffset:offsetof(SceneVertex, position)
                                  shouldEnable:YES];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0
                           numberOfCoordinates:2
                                  attribOffset:offsetof(SceneVertex, textureCoords)
                                  shouldEnable:YES];
    
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
                        startVertexIndex:0
                        numberOfVertices:sizeof(triangles) / sizeof(SceneVertex)];
}


#pragma mark - Private

-(void)configSubViews
{
    UISwitch *useDetailLightingSwitch =  [[UISwitch alloc] initWithFrame:CGRectMake(20, 20, 100, 50)];
    [useDetailLightingSwitch addTarget:self action:@selector(takeShouldUseDetailLightingFrom:) forControlEvents:UIControlEventTouchUpInside];
    useDetailLightingSwitch.on = YES;
    [self.view addSubview:useDetailLightingSwitch];
    
    UILabel *useDetailLightingLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 200, 50)];
    useDetailLightingLabel.text = @"Use Detail Lighting";
    [self.view addSubview:useDetailLightingLabel];
}


#pragma mark - Event

-(void)takeShouldUseDetailLightingFrom:(UISwitch *)sender;
{
    self.shouldUseDetailLighting = sender.isOn;
}


@end

#pragma mark - Triangle manipulation

static SceneTriangle SceneTriangleMake(const SceneVertex vertexA,
                                       const SceneVertex vertexB,
                                       const SceneVertex vertexC)
{
    SceneTriangle result;
    result.vertices[0] = vertexA;
    result.vertices[1] = vertexB;
    result.vertices[2] = vertexC;
    
    return result;
}
