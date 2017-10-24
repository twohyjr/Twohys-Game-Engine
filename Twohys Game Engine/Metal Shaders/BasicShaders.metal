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
    vOut.position = float4(vIn.position,1);
    vOut.color = vIn.color;
    
    return vOut;
}

fragment float4 fragmentShader(VertexOut vIn [[ stage_in ]]){
    return vIn.color;
}

