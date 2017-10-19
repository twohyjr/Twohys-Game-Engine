import MetalKit

class Triangle: Primitive {
    
    override func buildVertices() {
        vertices = [
            Vertex(position: float3( 0, 1, 0), color: float4(1,0,0,1), normal: float3(1,2,3), textureCoordinate: float2(1,2)),
            Vertex(position: float3(-1,-1, 0), color: float4(0,1,0,1), normal: float3(4,5,6), textureCoordinate: float2(3,4)),
            Vertex(position: float3( 1,-1, 0), color: float4(0,0,1,1), normal: float3(7,8,9), textureCoordinate: float2(5,6))
        ]
    }
    
    override func buildIndices() {
        indices = [0,1,2]
    }
}
