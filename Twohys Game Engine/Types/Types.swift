import MetalKit

struct Vertex{
    var position: float3
    var color: float4
    let normal: float3
    let textureCoordinate: float2
}

struct ModelConstants{
    var modelViewMatrix: matrix_float4x4 = matrix_identity_float4x4
}

struct SceneConstants{
    var projectionMatrix: matrix_float4x4 = matrix_identity_float4x4
}

