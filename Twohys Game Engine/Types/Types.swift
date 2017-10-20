import MetalKit

struct Vertex{
    var position: float3
    var color: float4
    var normal: float3
    var textureCoordinate: float2
}

struct SceneConstants{
    var moveBy: Float = 0
}

struct ModelConstants{
    var moveBy: Float = 0
}
