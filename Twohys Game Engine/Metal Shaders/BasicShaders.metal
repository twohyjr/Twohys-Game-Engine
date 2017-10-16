#include <metal_stdlib>
using namespace metal;

struct VertexIn{
    float3 position;
    float4 color;
    float3 normal;
    float2 textureCoordinate;
};

struct VertexOut{
    float4 position [[ position ]];
    float4 color;
    float3 normal;
    float2 textureCoordinate;
};

vertex VertexOut basic_vertex_function(device VertexIn *vIn [[ buffer(0) ]],
                                    uint vid [[ vertex_id ]]){
    VertexOut vOut;
    vOut.position = float4(vIn[vid].position, 1);
    vOut.color = vIn[vid].color;
    vOut.normal = vIn[vid].normal;
    return vOut;
}

fragment float4 basic_fragment_function(VertexOut vIn [[ stage_in ]]){
    return vIn.color;
}
