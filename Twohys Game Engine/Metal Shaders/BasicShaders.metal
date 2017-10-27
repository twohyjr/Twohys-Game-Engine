#include <metal_stdlib>
using namespace metal;

struct VertexIn{
    float3 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
    float3 normal [[ attribute(2) ]];
    float2 textureCoordinate [[ attribute(3) ]];
};

struct VertexOut{
    float4 position [[ position ]];
    float4 color;
    float3 normal;
    float2 textureCoordinate;
};

struct ModelConstants{
    float4x4 modelViewMatrix;
};

struct SceneConstants{
    float4x4 projectionMatrix;
};

vertex VertexOut vertexShader(const VertexIn vIn [[ stage_in ]],
                              constant SceneConstants &sceneConstants [[ buffer(1) ]],
                              constant ModelConstants &modelConstants [[ buffer(2) ]]){
    
    VertexOut vOut;
    float4 worldPosition = modelConstants.modelViewMatrix * float4(vIn.position,1);
    vOut.position = sceneConstants.projectionMatrix *  worldPosition;
    vOut.color = vIn.color;
    vOut.textureCoordinate = vIn.textureCoordinate;
    
    return vOut;
}

vertex VertexOut instanceVertexShader(const VertexIn vIn [[ stage_in ]],
                                      constant SceneConstants &sceneConstants [[ buffer(1) ]],
                                      constant ModelConstants *modelConstants [[ buffer(2) ]],
                                      uint instanceID [[ instance_id ]]){
    
    VertexOut vOut;
    ModelConstants constants = modelConstants[instanceID];
    vOut.position = sceneConstants.projectionMatrix *  constants.modelViewMatrix * float4(vIn.position,1);
    vOut.color = vIn.color;
    vOut.textureCoordinate = vIn.textureCoordinate;
    return vOut;
}

fragment float4 fragmentShader(VertexOut vIn [[ stage_in ]]){
    return vIn.color;
}

fragment half4 texturedFragmentShader(VertexOut vIn [[ stage_in ]],
                                          sampler sampler2d [[ sampler(0) ]],
                                          texture2d<float> texture [[ texture(0) ]]){
    float4 color = texture.sample(sampler2d, vIn.textureCoordinate);
    return half4(color.x, color.y, color.z, 1);
}

