import MetalKit

class Terrain: Primitive{
    
    let GRID_SIZE: Int = 800
    var VERTEX_COUNT: Int = 0
    let MAX_HEIGHT: Float = 20.0
    let MAX_PIXEL_COLOR = 255 * 255 * 255
    let bmp: NSBitmapImageRep!
    
    var heights = [[Float]]()
    
    init(device: MTLDevice, textureName: String, heightMapImage: String){
        
        
        let url: URL = Bundle.main.url(forResource: heightMapImage, withExtension: nil)!
        let image = NSImage(contentsOf: url)
        bmp = image?.representations[0] as! NSBitmapImageRep
        VERTEX_COUNT = Int((image?.size.width)!)

        heights = Array(repeating: Array(repeating: 0, count: VERTEX_COUNT), count: VERTEX_COUNT)
        
        
        
        super.init(device: device, textureName: textureName)
    }
    
    override func buildVertices() {
        print(VERTEX_COUNT)
        for z in 0..<VERTEX_COUNT{
            for x in 0..<VERTEX_COUNT{
                let vX: Float = Float(x) / Float(Float(VERTEX_COUNT) - Float(1)) * Float(GRID_SIZE)
                let vZ: Float = Float(z) / Float(Float(VERTEX_COUNT) - Float(1)) * Float(GRID_SIZE)
                let height = getHeight(x: x, z: z)
                heights[x][z] = height
                let vY: Float = height
                
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
    
    public func GetHeightOfTerrain(worldX: Float, worldZ: Float)->Float{
        let terrainX: Float = worldX - self.position.x
        let terrainZ: Float = worldZ - self.position.z
        let gridSquareSize: Float = Float(GRID_SIZE) / Float(heights.count - 1)
        let gridX: Int = Int(floor(terrainX / gridSquareSize))
        let gridZ: Int = Int(floor(terrainZ / gridSquareSize))
        if(gridX >= heights.count - 1 || gridZ >= heights.count - 1 || gridX < 0 || gridZ < 0){
            return 0
        }
        
        let xCoord = (terrainX.truncatingRemainder(dividingBy: gridSquareSize)) / gridSquareSize
        let zCoord = (terrainZ.truncatingRemainder(dividingBy: gridSquareSize)) / gridSquareSize
        
        var result: Float = 0.0
        if(xCoord <= (1 - zCoord)){
            result = Maths.barryCentric(float3(0, heights[gridX][gridZ], 0), float3(1,
                    heights[gridX + 1][gridZ], 0), float3(0,
                    heights[gridX][gridZ + 1], 1), float2(xCoord, zCoord))
        }else{
            result = Maths.barryCentric(float3(1, heights[gridX + 1][gridZ], 0), float3(1,
                    heights[gridX + 1][gridZ + 1], 1), float3(0,
                    heights[gridX][gridZ + 1], 1), float2(xCoord, zCoord))
        }
        
        return result
    }
    
    private func getHeight(x: Int, z: Int)->Float{
        let imageHeight = bmp.pixelsHigh
        if(x < 0 || x >= imageHeight || z < 0 || z >= imageHeight){
            return 0.0
        }
        var pixel: Int = 0
        bmp.getPixel(&pixel, atX: x, y: z)
        var height: Float = Float(pixel)
        height += Float(255)
        height /= Float(255 / 2)
        height *= MAX_HEIGHT

        return height
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
