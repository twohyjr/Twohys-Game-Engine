import MetalKit

//struct Vertex{
//    var position: float3
//    var color: float4
//    let normal: float3 = float3(1)
//    let textureCoordinate: float2 = float2(1)
//}

struct Vertex{
    var position: float3
    var color: float4
}

struct ModelConstants{
    var modelMatrix: matrix_float4x4 = matrix_identity_float4x4
}

