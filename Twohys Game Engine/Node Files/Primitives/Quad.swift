import MetalKit

class Quad: Primitive {
    override func buildVertices(){
        
        vertices = [
            Vertex(position: float3( 1, 1, 0), color: float4(0.25), normal: float3(0,1,2), textureCoordinate: float2(1,1)),
            Vertex(position: float3(-1, 1, 0), color: float4(0.25), normal: float3(0,1,2), textureCoordinate: float2(0,1)),
            Vertex(position: float3(-1,-1, 0), color: float4(0.25), normal: float3(0,1,2), textureCoordinate: float2(0,0)),
            Vertex(position: float3( 1,-1, 0), color: float4(0.25), normal: float3(0,1,2), textureCoordinate: float2(1,0))
        ]
        
        indices = [
            0,1,2,
            0,2,3
        ]

    }
}
