#include <metal_stdlib>
using namespace metal;

struct VertexIn{
    float3 position;
    float4 color;
};

struct VertexOut{
    float4 position [[ position ]];
    float4 color;
};

vertex VertexOut vertexShader(device VertexIn *vIn [[ buffer(0) ]],
                              uint vertexID [[ vertex_id ]]){
    
    VertexOut vOut;
    vOut.position = float4(vIn[vertexID].position,1);
    vOut.color = vIn[vertexID].color;
    
    return vOut;
}

fragment float4 fragmentShader(VertexOut vIn [[ stage_in ]]){
    return vIn.color;
}

