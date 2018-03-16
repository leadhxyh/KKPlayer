//
//  KKGLCoordBufferVR.m
//  KKPlayer
//
//  Created by finger on 17/01/2017.
//  Copyright © 2017 finger. All rights reserved.
//

#import "KKGLCoordBufferVR.h"

@implementation KKGLCoordBufferVR

static GLuint vertexBufferId = 0;
static GLuint indexBufferId = 0;
static GLuint textureBufferId = 0;
static GLfloat *vertexBufferData = NULL;
static GLushort *indexBufferData = NULL;
static GLfloat *textureBufferData = NULL;

static int const slicesCount = 200;
static int const parallelsCount = slicesCount / 2;

static int const indexCount = slicesCount * parallelsCount * 6;
static int const vertexCount = (slicesCount + 1) * (parallelsCount + 1);

- (void)dealloc{
    if(indexBufferData){
        free(indexBufferData);
        indexBufferData = NULL;
    }
    if(vertexBufferData){
        free(vertexBufferData);
        vertexBufferData = NULL;
    }
    if(textureBufferData){
        free(textureBufferData);
        textureBufferData = NULL;
    }
}

- (void)genBufferIdentify{
    glGenBuffers(1, &indexBufferId);
    glGenBuffers(1, &vertexBufferId);
    glGenBuffers(1, &textureBufferId);
}

- (void)setupCoordBuffer{
    self.indexCount = indexCount;
    self.vertexCount = vertexCount;
    self.indexBufferId = indexBufferId;
    self.vertexBufferId = vertexBufferId;
    self.textureBufferId = textureBufferId;
    
    float const step = (2.0f * M_PI) / (float)slicesCount;
    float const radius = 1.0f;
    
    if(indexBufferData){
        free(indexBufferData);
        indexBufferData = NULL;
    }
    indexBufferData = malloc(sizeof(GLushort) * indexCount);
    
    if(vertexBufferData){
        free(vertexBufferData);
        vertexBufferData = NULL;
    }
    vertexBufferData = malloc(sizeof(GLfloat) * 3 * vertexCount);
    
    if(textureBufferData){
        free(textureBufferData);
        textureBufferData = NULL;
    }
    textureBufferData = malloc(sizeof(GLfloat) * 2 * vertexCount);
    
    int runCount = 0;
    for (int i = 0; i < parallelsCount + 1; i++){
        for (int j = 0; j < slicesCount + 1; j++){
            int vertex = (i * (slicesCount + 1) + j) * 3;
            if (vertexBufferData){
                vertexBufferData[vertex + 0] = radius * sinf(step * (float)i) * cosf(step * (float)j);
                vertexBufferData[vertex + 1] = radius * cosf(step * (float)i);
                vertexBufferData[vertex + 2] = radius * sinf(step * (float)i) * sinf(step * (float)j);
            }
            if (textureBufferData){
                int textureIndex = (i * (slicesCount + 1) + j) * 2;
                textureBufferData[textureIndex + 0] = (float)j / (float)slicesCount;
                textureBufferData[textureIndex + 1] = ((float)i / (float)parallelsCount);
            }
            if (indexBufferData && i < parallelsCount && j < slicesCount){
                indexBufferData[runCount++] = i * (slicesCount + 1) + j;
                indexBufferData[runCount++] = (i + 1) * (slicesCount + 1) + j;
                indexBufferData[runCount++] = (i + 1) * (slicesCount + 1) + (j + 1);
                
                indexBufferData[runCount++] = i * (slicesCount + 1) + j;
                indexBufferData[runCount++] = (i + 1) * (slicesCount + 1) + (j + 1);
                indexBufferData[runCount++] = i * (slicesCount + 1) + (j + 1);
            }
        }
    }
}

- (void)bindPositionLocation:(GLint)positionLocation
        textureCoordLocation:(GLint)textureCoordLocation{
    [self bindPositionLocation:positionLocation
          textureCoordLocation:textureCoordLocation
             textureRotateType:KKTextureRotateType0];
}

- (void)bindPositionLocation:(GLint)positionLocation
        textureCoordLocation:(GLint)textureCoordLocation
           textureRotateType:(KKTextureRotateType)textureRotateType{
    //顶点索引Buffer
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, self.indexBufferId);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, self.indexCount * sizeof(GLushort), indexBufferData, GL_STATIC_DRAW);
    
    //顶点坐标Buffer
    glBindBuffer(GL_ARRAY_BUFFER, self.vertexBufferId);
    glBufferData(GL_ARRAY_BUFFER, self.vertexCount * 3 * sizeof(GLfloat), vertexBufferData, GL_STATIC_DRAW);
    glEnableVertexAttribArray(positionLocation);
    glVertexAttribPointer(positionLocation, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat), NULL);
    
    //纹理坐标Buffer
    glBindBuffer(GL_ARRAY_BUFFER, self.textureBufferId);
    glBufferData(GL_ARRAY_BUFFER, self.vertexCount * 2 * sizeof(GLfloat), textureBufferData, GL_DYNAMIC_DRAW);
    glEnableVertexAttribArray(textureCoordLocation);
    glVertexAttribPointer(textureCoordLocation, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*2, NULL);
}

@end
