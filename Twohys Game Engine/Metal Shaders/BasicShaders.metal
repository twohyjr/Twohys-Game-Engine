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

struct Constants{
    float moveBy;
};

vertex VertexOut basic_vertex_function(const VertexIn vIn [[ stage_in ]],
                                       constant Constants &constants [[ buffer(1) ]]){
    VertexOut vOut;
    vOut.position = float4(vIn.position,1);
    vOut.position.x += cos(constants.moveBy);
    vOut.color = vIn.color;
    vOut.normal = vIn.normal;
    return vOut;
}

fragment float4 basic_fragment_function(VertexOut vIn [[ stage_in ]]){
    return vIn.color;
}
