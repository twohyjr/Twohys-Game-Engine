import MetalKit

class Cube: Primitive{
    
    override func buildVertices(){
        let cubeColor = float4(0.7, 0.7, 0.7, 1)
        
        vertices = [
            Vertex(position: float3(-0.5, 0.5,-0.5), color: cubeColor, normal: float3(0,1,2), textureCoordinate: float2(0,1)),
            Vertex(position: float3(-0.5,-0.5,-0.5), color: cubeColor, normal: float3(0,1,2), textureCoordinate: float2(0,1)),
            Vertex(position: float3( 0.5,-0.5,-0.5), color: cubeColor, normal: float3(0,1,2), textureCoordinate: float2(0,1)),
            Vertex(position: float3( 0.5, 0.5,-0.5), color: cubeColor, normal: float3(0,1,2), textureCoordinate: float2(0,1)),

            Vertex(position: float3(-0.5, 0.5, 0.5), color: cubeColor, normal: float3(0,1,2), textureCoordinate: float2(0,1)),
            Vertex(position: float3(-0.5,-0.5, 0.5), color: cubeColor, normal: float3(0,1,2), textureCoordinate: float2(0,1)),
            Vertex(position: float3( 0.5,-0.5, 0.5), color: cubeColor, normal: float3(0,1,2), textureCoordinate: float2(0,1)),
            Vertex(position: float3( 0.5, 0.5, 0.5), color: cubeColor, normal: float3(0,1,2), textureCoordinate: float2(0,1)),

            Vertex(position: float3( 0.5, 0.5,-0.5), color: cubeColor, normal: float3(0,1,2), textureCoordinate: float2(0,1)),
            Vertex(position: float3( 0.5,-0.5,-0.5), color: cubeColor, normal: float3(0,1,2), textureCoordinate: float2(0,1)),
            Vertex(position: float3( 0.5,-0.5, 0.5), color: cubeColor, normal: float3(0,1,2), textureCoordinate: float2(0,1)),
            Vertex(position: float3( 0.5, 0.5, 0.5), color: cubeColor, normal: float3(0,1,2), textureCoordinate: float2(0,1)),

            Vertex(position: float3(-0.5, 0.5,-0.5), color: cubeColor, normal: float3(0,1,2), textureCoordinate: float2(0,1)),
            Vertex(position: float3(-0.5,-0.5,-0.5), color: cubeColor, normal: float3(0,1,2), textureCoordinate: float2(0,1)),
            Vertex(position: float3(-0.5,-0.5, 0.5), color: cubeColor, normal: float3(0,1,2), textureCoordinate: float2(0,1)),
            Vertex(position: float3(-0.5, 0.5, 0.5), color: cubeColor, normal: float3(0,1,2), textureCoordinate: float2(0,1)),

            Vertex(position: float3(-0.5, 0.5, 0.5), color: cubeColor, normal: float3(0,1,2), textureCoordinate: float2(0,1)),
            Vertex(position: float3(-0.5, 0.5,-0.5), color: cubeColor, normal: float3(0,1,2), textureCoordinate: float2(0,1)),
            Vertex(position: float3( 0.5, 0.5,-0.5), color: cubeColor, normal: float3(0,1,2), textureCoordinate: float2(0,1)),
            Vertex(position: float3( 0.5, 0.5, 0.5), color: cubeColor, normal: float3(0,1,2), textureCoordinate: float2(0,1)),

            Vertex(position: float3(-0.5,-0.5, 0.5), color: cubeColor, normal: float3(0,1,2), textureCoordinate: float2(0,1)),
            Vertex(position: float3(-0.5,-0.5,-0.5), color: cubeColor, normal: float3(0,1,2), textureCoordinate: float2(0,1)),
            Vertex(position: float3( 0.5,-0.5,-0.5), color: cubeColor, normal: float3(0,1,2), textureCoordinate: float2(0,1)),
            Vertex(position: float3( 0.5,-0.5, 0.5), color: cubeColor, normal: float3(0,1,2), textureCoordinate: float2(0,1))
        ]
        
        indices = [
            0,1,3,              3,1,2,
            4,5,7,              7,5,6,
            8,9,11,             11,9,10,
            12,13,15,           15,13,14,
            16,17,19,           19,17,18,
            20,21,23,           23,21,22
        ]

        
    }
    
}

