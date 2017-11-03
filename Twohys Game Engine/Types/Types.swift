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
    var shininess: Float = 1.0
    var specularIntensity: Float = 1.0
    var materialColor: float4 = float4(0.56,0.56,0.56,1.0)
}

struct SceneConstants{
    var projectionMatrix: matrix_float4x4 = matrix_identity_float4x4
    var viewMatrix: matrix_float4x4 = matrix_identity_float4x4
    var skyColor: float3 = MainView.SKY_COLOR
    var fogDensity: Float = 0.0
    var fogGradient: Float = 0.0
}

struct Light{
    var color = float3(1)
    var ambientIntensity: Float = 1.0
    var direction = float3(0,0,-1)
    var diffuseIntensity: Float = 1.0
    var brightness: Float = 1.0
}

struct Fog{
    var density: Float = 0.0
    var gradient: Float = 0.0
}
