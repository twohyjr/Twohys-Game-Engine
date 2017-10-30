import MetalKit

class Terrain: Primitive{
    
    let GRID_SIZE: Int = 1000
    let VERTEX_COUNT: Int = 500
    
    var generator = PerlinGenerator()
    
    override func buildVertices() {
    
        generator = PerlinGenerator()
        generator.octaves = 3 //1-7
        generator.zoom = 2.0 //0.3 - 6
        generator.persistence = 0.5 //0-1
        
        for z in 0..<VERTEX_COUNT{
            for x in 0..<VERTEX_COUNT{
                let vX: Float = Float(x) / Float(Float(VERTEX_COUNT) - Float(1)) * Float(GRID_SIZE)
                let vY: Float = getHeight(x: x, z: z) * 2
                let vZ: Float = Float(z) / Float(Float(VERTEX_COUNT) - Float(1)) * Float(GRID_SIZE)
                
                let tX: Float = fmod(Float(x), 2.0)
                let tZ: Float = fmod(Float(z), 2.0)
                
                let position: float3 = float3(vX, vY, vZ)
                
                let color: float4 = float4(1)
                
                let textureCoordinate: float2  = float2(tX, tZ)
                
                let normals: float3 = calculateNormal(x: x, z: z)
                
                vertices.append(Vertex(position: position, color: color,  normal: normals, textureCoordinate: textureCoordinate))
            }
        }
        
        for gz in 0..<VERTEX_COUNT-1{
            for gx in 0..<VERTEX_COUNT-1{
                let topLeft: UInt32 = UInt32(gz * VERTEX_COUNT + gx)
                let topRight: UInt32 = (topLeft + UInt32(1))
                let bottomLeft: UInt32 = UInt32(((gz + 1) * VERTEX_COUNT) + gx)
                let bottomRight: UInt32 = (bottomLeft + UInt32(1))
                indices.append(topLeft)
                indices.append(bottomLeft)
                indices.append(topRight)
                indices.append(topRight)
                indices.append(bottomLeft)
                indices.append(bottomRight)
            }
        }
    }
    
    func getHeight(x: Int, z: Int)->Float{
        return generator.perlinNoise(Float(x), y: Float(z), z: 0, t: 0)
    }
    
    func calculateNormal(x: Int, z: Int)->float3{
        let heightL = getHeight(x: x-1, z: z)
        let heightR = getHeight(x: x+1, z: z)
        let heightD = getHeight(x: x, z: z-1)
        let heightU = getHeight(x: x, z: z+1)
        var normal = float3(heightL - heightR, 2.0, heightD - heightU)
        normal = normalize(normal)
        return normal
    }
    
}
