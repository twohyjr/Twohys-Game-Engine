import MetalKit

class Cube: Primitive{
    
    override func buildVertices(){
        let cubeColor = float4(0.7, 0.7, 0.7, 1)
        vertices = [
            //LEFT
            Vertex(position: float3(-1.0,-1.0,-1.0), color: cubeColor, normal: float3(-1.0, 0.0, 0.0), textureCoordinate: float2(0,1)),
            Vertex(position: float3(-1.0,-1.0, 1.0), color: cubeColor, normal: float3(-1.0, 0.0, 0.0), textureCoordinate: float2(0,1)),
            Vertex(position: float3(-1.0, 1.0, 1.0), color: cubeColor, normal: float3(-1.0, 0.0, 0.0), textureCoordinate: float2(0,1)),
            Vertex(position: float3(-1.0,-1.0,-1.0), color: cubeColor, normal: float3(-1.0, 0.0, 0.0), textureCoordinate: float2(0,1)),
            Vertex(position: float3(-1.0, 1.0, 1.0), color: cubeColor, normal: float3(-1.0, 0.0, 0.0), textureCoordinate: float2(0,1)),
            Vertex(position: float3(-1.0, 1.0,-1.0), color: cubeColor, normal: float3(-1.0, 0.0, 0.0), textureCoordinate: float2(0,1)),
            
            //RIGHT
            Vertex(position: float3(1.0, 1.0, 1.0), color: cubeColor, normal: float3(1.0, 0.0, 0.0), textureCoordinate: float2(0,1)),
            Vertex(position: float3(1.0,-1.0,-1.0), color: cubeColor, normal: float3(1.0, 0.0, 0.0), textureCoordinate: float2(0,1)),
            Vertex(position: float3(1.0, 1.0,-1.0), color: cubeColor, normal: float3(1.0, 0.0, 0.0), textureCoordinate: float2(0,1)),
            Vertex(position: float3(1.0,-1.0,-1.0), color: cubeColor, normal: float3(1.0, 0.0, 0.0), textureCoordinate: float2(0,1)),
            Vertex(position: float3(1.0, 1.0, 1.0), color: cubeColor, normal: float3(1.0, 0.0, 0.0), textureCoordinate: float2(0,1)),
            Vertex(position: float3(1.0,-1.0, 1.0), color: cubeColor, normal: float3(1.0, 0.0, 0.0), textureCoordinate: float2(0,1)),
            
            //TOP
            Vertex(position: float3(1.0, 1.0, 1.0), color: cubeColor, normal: float3(0.0, 1.0, 0.0), textureCoordinate: float2(0,1)),
            Vertex(position: float3(1.0, 1.0,-1.0), color: cubeColor, normal: float3(0.0, 1.0, 0.0), textureCoordinate: float2(0,1)),
            Vertex(position: float3(-1.0, 1.0,-1.0), color: cubeColor, normal: float3(0.0, 1.0, 0.0), textureCoordinate: float2(0,1)),
            Vertex(position: float3(1.0, 1.0, 1.0), color: cubeColor, normal: float3(0.0, 1.0, 0.0), textureCoordinate: float2(0,1)),
            Vertex(position: float3(-1.0, 1.0,-1.0), color: cubeColor, normal: float3(0.0, 1.0, 0.0), textureCoordinate: float2(0,1)),
            Vertex(position: float3(-1.0, 1.0, 1.0), color: cubeColor, normal: float3(0.0, 1.0, 0.0), textureCoordinate: float2(0,1)),
            
            //BOTTOM
            Vertex(position: float3(1.0,-1.0, 1.0), color: cubeColor, normal: float3(0.0,-1.0, 0.0), textureCoordinate: float2(0,1)),
            Vertex(position: float3(-1.0,-1.0,-1.0), color: cubeColor, normal: float3(0.0,-1.0, 0.0), textureCoordinate: float2(0,1)),
            Vertex(position: float3(1.0,-1.0,-1.0), color: cubeColor, normal: float3(0.0,-1.0, 0.0), textureCoordinate: float2(0,1)),
            Vertex(position: float3(1.0,-1.0, 1.0), color: cubeColor, normal: float3(0.0,-1.0, 0.0), textureCoordinate: float2(0,1)),
            Vertex(position: float3(-1.0,-1.0, 1.0), color: cubeColor, normal: float3(0.0,-1.0, 0.0), textureCoordinate: float2(0,1)),
            Vertex(position: float3(-1.0,-1.0,-1.0), color: cubeColor, normal: float3(0.0,-1.0, 0.0), textureCoordinate: float2(0,1)),
            
            //BACK
            Vertex(position: float3(1.0, 1.0,-1.0), color: cubeColor, normal: float3(0.0, 0.0, -1.0), textureCoordinate: float2(0,1)),
            Vertex(position: float3(-1.0,-1.0,-1.0), color: cubeColor, normal: float3(0.0, 0.0, -1.0), textureCoordinate: float2(0,1)),
            Vertex(position: float3(-1.0, 1.0,-1.0), color: cubeColor, normal: float3(0.0, 0.0, -1.0), textureCoordinate: float2(0,1)),
            Vertex(position: float3(1.0, 1.0,-1.0), color: cubeColor, normal: float3(0.0, 0.0, -1.0), textureCoordinate: float2(0,1)),
            Vertex(position: float3(1.0,-1.0,-1.0), color: cubeColor, normal: float3(0.0, 0.0, -1.0), textureCoordinate: float2(0,1)),
            Vertex(position: float3(-1.0,-1.0,-1.0), color: cubeColor, normal: float3(0.0, 0.0, -1.0), textureCoordinate: float2(0,1)),
            
            //FRONT
            Vertex(position: float3(-1.0, 1.0, 1.0), color: cubeColor, normal: float3(0.0, 0.0, 1.0), textureCoordinate: float2(0,1)),
            Vertex(position: float3(-1.0,-1.0, 1.0), color: cubeColor, normal: float3(0.0, 0.0, 1.0), textureCoordinate: float2(0,1)),
            Vertex(position: float3(1.0,-1.0, 1.0), color: cubeColor, normal: float3(0.0, 0.0, 1.0), textureCoordinate: float2(0,1)),
            Vertex(position: float3(1.0, 1.0, 1.0), color: cubeColor, normal: float3(0.0, 0.0, 1.0), textureCoordinate: float2(0,1)),
            Vertex(position: float3(-1.0, 1.0, 1.0), color: cubeColor, normal: float3(0.0, 0.0, 1.0), textureCoordinate: float2(0,1)),
            Vertex(position: float3(1.0,-1.0, 1.0), color: cubeColor, normal: float3(0.0, 0.0, 1.0), textureCoordinate: float2(0,1)),
        ]
    }
    
}

