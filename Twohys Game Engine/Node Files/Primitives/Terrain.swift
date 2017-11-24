import MetalKit



class Terrain: Node{
    var _renderPipelineState: MTLRenderPipelineState!
    var modelConstants = ModelConstants()
    
    var vertices: [Vertex] = []
    var vertexBuffer: MTLBuffer!
    
    var indices: [UInt32] = []
    var indexBuffer: MTLBuffer!
    
    var terrainTextures: [MTLTexture] = []

    public var gridSize: Int = 0
    private var vertexCount: Int = 0
    private var maxHeight: Float = 20.0
    private var bmp: NSBitmapImageRep!
    var heights = [[Float]]()
    
    init(device: MTLDevice, gridSize: Int, backgroundTexture: String = "", heightMapImage: String = "", textureNames: [String] = ["grassy.png","mud.png","mud.png","mud.png", "blendMap.png"]){
        super.init()

        self.gridSize = gridSize
        if(heightMapImage != ""){
            let url: URL = Bundle.main.url(forResource: heightMapImage, withExtension: nil)!
            let image = NSImage(contentsOf: url)
            bmp = image?.representations[0] as! NSBitmapImageRep
            vertexCount = Int((image?.size.width)!)
        }else{
            vertexCount = 256
        }
        heights = Array(repeating: Array(repeating: 0, count: vertexCount + 1), count: vertexCount + 1)

        buildVertices()
        buildBuffers(device: device)
        if let backgroundTexture = setTexture(device: device, imageName: backgroundTexture){
            self.terrainTextures.append(backgroundTexture)
            _renderPipelineState = FlashPipelineStateProvider.getFlashPipelineState(flashPipelineStateType: FlashPipelineStateType.TERRAIN)
            buildTerrainTextures(device: device, terrainNames: textureNames)
        }else{
            _renderPipelineState = FlashPipelineStateProvider.getFlashPipelineState(flashPipelineStateType: FlashPipelineStateType.RENDERABLE)
        }
    }
    
    func buildTerrainTextures(device: MTLDevice, terrainNames: [String]){
        terrainNames.forEach { name in
            appendTexture(device: device, name: name)
        }
    }
    
    func appendTexture(device: MTLDevice, name: String){
        if let texture = setTexture(device: device, imageName: name){
            self.terrainTextures.append(texture)
        }
    }
    
    func buildVertices() {
        let step = gridSize
        let stepValue = Float(step) / Float(vertexCount)
        for row in 0..<vertexCount{
            for column in 0..<vertexCount{
                
                let xOriginPoint = Float(Float(column) / Float(vertexCount)) * Float(step)
                let yOriginPoint = Float(Float(row) / Float(vertexCount)) * Float(step)
                
                let heightTopRight = getHeight(x: row, z: column + 1)
                let heightTopLeft = getHeight(x: row, z: column)
                let heightBottomLeft = getHeight(x: row + 1, z: column)
                let heightBottomRight = getHeight(x: row + 1, z: column + 1)

                heights[column + 1][row] = heightTopRight
                heights[column][row] = heightTopLeft
                heights[column][row + 1] = heightBottomLeft
                heights[column + 1][row + 1] = heightBottomRight
                
                //Vertex Positions
                let vTopRight = float3(xOriginPoint + stepValue, heightTopRight, yOriginPoint)
                let vTopLeft = float3(xOriginPoint, heightTopLeft, yOriginPoint)
                let vBottomLeft = float3(xOriginPoint, heightBottomLeft, yOriginPoint + stepValue)
                let vBottomRight = float3(xOriginPoint + stepValue, heightBottomRight, yOriginPoint + stepValue)
                
                //Texture Coordinates
                let tTopRight = float2(1, 0)
                let tTopLeft = float2(0, 0)
                let tBottomLeft = float2(0 ,1)
                let tBottomRight = float2(1, 1)
                
                //Vertex Color
                let color: float4 = float4(1)
                
                //Vertex Normals
                let normals: float3 = float3(0,1,0)
                
                
                //Append Triangle 1
                vertices.append(Vertex(position: vTopRight, color: color,  normal: normals, textureCoordinate: tTopRight))
                vertices.append(Vertex(position: vTopLeft, color: color,  normal: normals, textureCoordinate: tTopLeft))
                vertices.append(Vertex(position: vBottomLeft, color: color,  normal: normals, textureCoordinate: tBottomLeft))

                //Append Triangle 2
                vertices.append(Vertex(position: vTopRight, color: color,  normal: normals, textureCoordinate: tTopRight))
                vertices.append(Vertex(position: vBottomLeft, color: color,  normal: normals, textureCoordinate: tBottomLeft))
                vertices.append(Vertex(position: vBottomRight, color: color,  normal: normals, textureCoordinate: tBottomRight))

                
            }
        }
    }
    
    func buildBuffers(device: MTLDevice){
        vertexBuffer = device.makeBuffer(bytes: vertices, length: MemoryLayout<Vertex>.stride * vertices.count, options: [MTLResourceOptions.storageModeManaged])
        if(indices.count > 0){
            indexBuffer = device.makeBuffer(bytes: indices, length: MemoryLayout<UInt32>.size * indices.count, options: [])
        }
    }
    
    public func GetHeightOfTerrain(worldX: Float, worldZ: Float)->Float{
        if(bmp == nil){
            return 0
        }
        let terrainX: Float = worldX - self.position.x
        let terrainZ: Float = worldZ - self.position.z
        let gridSquareSize: Float = Float(gridSize) / Float(heights.count - 1)
        let gridX: Int = Int(floor(terrainX / gridSquareSize))
        let gridZ: Int = Int(floor(terrainZ / gridSquareSize))
        if(gridX >= heights.count - 1 || gridZ >= heights.count - 1 || gridX < 0 || gridZ < 0){
            return 0
        }
        
        let xCoord = (terrainX.truncatingRemainder(dividingBy: gridSquareSize)) / gridSquareSize
        let zCoord = (terrainZ.truncatingRemainder(dividingBy: gridSquareSize)) / gridSquareSize
        
        var result: Float = 0.0
        if(xCoord <= (1 - zCoord)){
            result = Maths.barryCentric(float3(0, heights[gridX][gridZ], 0),
                                        float3(1,heights[gridX + 1][gridZ], 0),
                                        float3(0, heights[gridX][gridZ + 1], 1), float2(xCoord, zCoord))
        }else{
            result = Maths.barryCentric(float3(1, heights[gridX + 1][gridZ], 0), float3(1,
                    heights[gridX + 1][gridZ + 1], 1), float3(0,
                    heights[gridX][gridZ + 1], 1), float2(xCoord, zCoord))
        }
        
        return result
    }
    
    private func getHeight(x: Int, z: Int)->Float{
        if(bmp == nil){
            return 0
        }
        let imageHeight = bmp.pixelsHigh
        var trueX = x
        var trueZ = z
        if(trueX >= imageHeight){
            trueX = imageHeight - 1
        }
        if(trueZ >= imageHeight){
            trueZ = imageHeight - 1
        }
        
        var pixel: Int = 0
        bmp.getPixel(&pixel, atX: trueX, y: trueZ)
        var height: Float = Float(pixel)
        height += Float(255)
        height /= Float(255 / 2)
        height *= maxHeight

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

extension Terrain: Renderable{
    func draw(renderCommandEncoder: MTLRenderCommandEncoder, modelMatrix: matrix_float4x4) {
        
        modelConstants.modelMatrix = modelMatrix
        modelConstants.normalMatrix = modelMatrix.upperLeftMatrix()
        modelConstants.shininess = self.shininess
        modelConstants.specularIntensity = self.specularIntensity
        modelConstants.materialColor = self.materialColor
        
        renderCommandEncoder.setRenderPipelineState(_renderPipelineState)
        
        renderCommandEncoder.setVertexBytes(&modelConstants, length: MemoryLayout<ModelConstants>.stride, index: 2)
        renderCommandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        if(terrainTextures.count > 0){
            renderCommandEncoder.setFragmentTexture(terrainTextures[0], index: 0)
            renderCommandEncoder.setFragmentTexture(terrainTextures[1], index: 1)
            renderCommandEncoder.setFragmentTexture(terrainTextures[2], index: 2)
            renderCommandEncoder.setFragmentTexture(terrainTextures[3], index: 3)
            renderCommandEncoder.setFragmentTexture(terrainTextures[4], index: 4)            
        }
                
        if(indices.count > 0){
            renderCommandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: indices.count, indexType: .uint32, indexBuffer: indexBuffer, indexBufferOffset: 0)
        }else{
            renderCommandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        }
    }
}

extension Terrain: Texturable{
    
}
