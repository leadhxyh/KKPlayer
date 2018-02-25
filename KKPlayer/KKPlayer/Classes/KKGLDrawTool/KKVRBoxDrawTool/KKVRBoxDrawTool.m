//
//  KKVRBoxDrawTool.m
//  KKPlayer
//
//  Created by finger on 26/12/2016.
//  Copyright © 2016 finger. All rights reserved.
//

#import "KKVRBoxDrawTool.h"
#import "KKGLCoordBufferVRBox.h"
#import "KKGLTextureVRBox.h"
#import "KKGLProgramVrBox.h"

@interface KKVRBoxDrawTool ()
@property(nonatomic,strong)KKGLProgramVrBox *program;
@property(nonatomic,strong)KKGLTextureVRBox *texture;
@property(nonatomic,strong)KKGLCoordBufferVRBox *leftEye;
@property(nonatomic,strong)KKGLCoordBufferVRBox *rightEye;
@end

@implementation KKVRBoxDrawTool

+ (instancetype)vrBoxDrawTool{
    return [[self alloc] initWithViewportSize:CGSizeZero];
}

- (instancetype)initWithViewportSize:(CGSize)viewportSize{
    if (self = [super init]) {
        self.viewportSize = viewportSize;
    }
    return self;
}

#pragma maek -- 绘制

- (void)beforDraw{
    glBindFramebuffer(GL_FRAMEBUFFER, self->_texture.frameBufferId);
}

- (void)drawBox{
    glViewport(0, 0, self.viewportSize.width, self.viewportSize.height);
    
    glDisable(GL_CULL_FACE);
    glDisable(GL_SCISSOR_TEST);
    
    glClearColor(0, 0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glEnable(GL_SCISSOR_TEST);
    
    glScissor(0, 0, self.viewportSize.width / 2, self.viewportSize.height);
    [self draw:self.leftEye];
    
    glScissor(self.viewportSize.width / 2, 0, self.viewportSize.width / 2, self.viewportSize.height);
    [self draw:self.rightEye];
    
    glDisable(GL_SCISSOR_TEST);
}

- (void)draw:(KKGLCoordBufferVRBox *)eye{
    
    [self.program useProgram];
    
    glBindBuffer(GL_ARRAY_BUFFER, eye.vertexBufferId);
    
    glVertexAttribPointer(self.program.locationPosition, 2, GL_FLOAT, GL_FALSE, 9 * sizeof(float), (void *)(0 * sizeof(float)));
    glEnableVertexAttribArray(self.program.locationPosition);
    
    glVertexAttribPointer(self.program.locationVignette, 1, GL_FLOAT, GL_FALSE, 9 * sizeof(float), (void *)(2 * sizeof(float)));
    glEnableVertexAttribArray(self.program.locationVignette);
    
    glVertexAttribPointer(self.program.locationBlueTextureCoord, 2, GL_FLOAT, GL_FALSE, 9 * sizeof(float), (void *)(7 * sizeof(float)));
    glEnableVertexAttribArray(self.program.locationBlueTextureCoord);
    
    glVertexAttribPointer(self.program.locationRedTextureCoord, 2, GL_FLOAT, GL_FALSE, 9 * sizeof(float), (void *)(3 * sizeof(float)));
    glEnableVertexAttribArray(self.program.locationRedTextureCoord);
    
    glVertexAttribPointer(self.program.locationGreenTextureCoord, 2, GL_FLOAT, GL_FALSE, 9 * sizeof(float), (void *)(5 * sizeof(float)));
    glEnableVertexAttribArray(self.program.locationGreenTextureCoord);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, self.texture.textureId);
    
    glUniform1i(self.program.locationSampler, 0);//对应GL_TEXTURE0
    glUniform1f(self.program.locationTextureCoordScale, 1);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, eye.indexBufferId);
    glDrawElements(GL_TRIANGLE_STRIP, eye.indexCount, GL_UNSIGNED_SHORT, 0);
}

#pragma mark -- @property setter

- (void)setViewportSize:(CGSize)viewportSize{
    if (!CGSizeEqualToSize(_viewportSize, viewportSize)) {
        _viewportSize = viewportSize;
        [self.texture resetTextureBufferSize:viewportSize];
    }
}

#pragma mark -- @property getter

- (KKGLProgramVrBox *)program{
    if(!_program){
        _program = [KKGLProgramVrBox program];
    }
    return _program;
}

- (KKGLTextureVRBox *)texture{
    if(!_texture){
        _texture = [KKGLTextureVRBox new];
    }
    return _texture;
}

- (KKGLCoordBufferVRBox *)leftEye{
    if (!_leftEye) {
        _leftEye = [[KKGLCoordBufferVRBox alloc]initWithBoxType:KKVRBoxTypeLeft];
    }
    return _leftEye;
}
 
- (KKGLCoordBufferVRBox *)rightEye{
    if (!_rightEye) {
        _rightEye = [[KKGLCoordBufferVRBox alloc]initWithBoxType:KKVRBoxTypeRight];
    }
    return _rightEye;
}

@end
