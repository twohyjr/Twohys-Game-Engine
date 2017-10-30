import MetalKit

struct Vertex{
    var position: float3
    var color: float4
    let normal: float3
    let textureCoordinate: float2
}

struct ModelConstants{
    var modelViewMatrix: matrix_float4x4 = matrix_identity_float4x4
    var normalMatrix = matrix_identity_float3x3
}

struct SceneConstants{
    var projectionMatrix: matrix_float4x4 = matrix_identity_float4x4
}

struct Light{
    var color = float3(1)
    var ambientIntensity: Float = 0.0
    var direction = float3(0)
    var diffuseIntensity: Float = 0.2
    var brightness: Float = 1.0
}

