#include <metal_stdlib>
using namespace metal;

struct VertexIn{
    float4 position [[ attribute(0) ]];
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

vertex VertexOut basic_vertex_function(VertexIn vIn [[ stage_in ]]){
    VertexOut vOut;
    vOut.position = vIn.position;
    vOut.color = vIn.color;
    vOut.normal = vIn.normal;
    return vOut;
}

fragment float4 basic_fragment_function(VertexOut vIn [[ stage_in ]]){
    return vIn.color;
}
