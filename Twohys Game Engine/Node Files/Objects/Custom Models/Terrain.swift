import MetalKit

class Terrain: Primitive{
    
    let GRID_SIZE: Int = 255
    let VERTEX_COUNT: Int = 255
    let MAX_HEIGHT: Float = 8.0
    let bmp: NSBitmapImageRep!
    
    init(device: MTLDevice, textureName: String, heightMapImage: String){
        
        let url: URL = Bundle.main.url(forResource: heightMapImage, withExtension: nil)!
        let image = NSImage(contentsOf: url)
        bmp = image?.representations[0] as! NSBitmapImageRep
        
        
        
        super.init(device: device, textureName: textureName)
    }
    
    override func buildVertices() {
        for z in 0..<VERTEX_COUNT{
            for x in 0..<VERTEX_COUNT{
                let vX: Float = Float(x) / Float(Float(VERTEX_COUNT) - Float(1)) * Float(GRID_SIZE)
                let vY: Float = getHeight(x: x, z: z)
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
//        let color = bmp.colorAt(x: x, y: z)
        let imageHeight = bmp.pixelsHigh
        if(x < 0 || x >= imageHeight || z < 0 || z >= imageHeight){
            return 0.0
        }
//        var height = (color?.redComponent)! * (color?.greenComponent)! * (color?.blueComponent)!
        var pixel: Int = 0
        bmp.getPixel(&pixel, atX: x, y: z)
        var height: Float = Float(pixel)
        
        height /= 255
        height *= Float(MAX_HEIGHT)
        print(height)
        
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
