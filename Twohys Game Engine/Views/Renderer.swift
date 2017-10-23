import MetalKit

class Renderer: NSObject{
    
    var renderPipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    
    var vertices: [Vertex]!
    var vertexBuffer: MTLBuffer!
    
    var modelConstants = ModelConstants()
    
    init(device: MTLDevice, mtkView: MTKView){
        super.init()
        commandQueue = device.makeCommandQueue()
        buildRenderPipelineState(device: device, view: mtkView)
        buildBuffers(device: device)
    }
    
    func buildRenderPipelineState(device: MTLDevice, view: MTKView){
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertexShader")
        let fragmentFunction = library?.makeFunction(name: "fragmentShader")
        
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat
        
        var vertexDescriptor: MTLVertexDescriptor{
            let vertexDescriptor = MTLVertexDescriptor()

            //Position
            vertexDescriptor.attributes[0].format = .float3
            vertexDescriptor.attributes[0].bufferIndex = 0
            vertexDescriptor.attributes[0].offset = 0

            //Color
            vertexDescriptor.attributes[1].format = .float4
            vertexDescriptor.attributes[1].bufferIndex = 0
            vertexDescriptor.attributes[1].offset = MemoryLayout<float3>.size

//            //Normal
//            vertexDescriptor.attributes[2].format = .float3
//            vertexDescriptor.attributes[2].bufferIndex = 0
//            vertexDescriptor.attributes[2].offset = MemoryLayout<float3>.size + MemoryLayout<float4>.size
//
//            //Texture Coordinate
//            vertexDescriptor.attributes[3].format = .float2
//            vertexDescriptor.attributes[3].bufferIndex = 0
//            vertexDescriptor.attributes[3].offset = MemoryLayout<float3>.size + MemoryLayout<float4>.size + MemoryLayout<float3>.size
//
            vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride

            return vertexDescriptor
        }

        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        do{
            renderPipelineState = try device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        }catch{
            print("\(error)")
        }
        
    }
    
    func buildBuffers(device: MTLDevice){
        
        vertices = []
        
        let trianglesPerSection: Int = 256
        var lastPos: float2 = float2(0)
        let size: Float = 0.8
        
        for i in (0 ... trianglesPerSection).reversed() {
            let red = Float(CGFloat(Float(arc4random()) / Float(UINT32_MAX)))
            let green = Float(CGFloat(Float(arc4random()) / Float(UINT32_MAX)))
            let blue = Float(CGFloat(Float(arc4random()) / Float(UINT32_MAX)))
            
            let val: Float = i == 0 ? 0 :  Float((360.0 / Double(trianglesPerSection)) * Double(i))
            let pos = float2(size * cos(radians(fromDegrees:  val)), size * sin(radians(fromDegrees:  val)))
            vertices.append(Vertex(position: float3(0, 0, 0), color: float4(red, green, blue, 1)))
            vertices.append(Vertex(position: float3(pos.x, pos.y, 0), color: float4(red, green, blue, 1)))
            vertices.append(Vertex(position: float3(lastPos.x, lastPos.y, 0), color: float4(red, green, blue, 1)))
            lastPos = pos
        }
        vertexBuffer = device.makeBuffer(bytes: vertices, length: MemoryLayout<Vertex>.size * vertices.count, options: [])
    }
    
    
}

extension Renderer: MTKViewDelegate{
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {  }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable, let passDescriptor = view.currentRenderPassDescriptor else { return }
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: passDescriptor)
        commandEncoder?.setRenderPipelineState(renderPipelineState)
        
        //        commandEncoder?.setTriangleFillMode(.lines)
        
        let deltaTime = 1 / Float(view.preferredFramesPerSecond)
        modelConstants.modelMatrix.rotate(angle: deltaTime, axis: float3(0,0,1))
        modelConstants.modelMatrix.rotate(angle: deltaTime, axis: float3(1,0,0))
        commandEncoder?.setVertexBytes(&modelConstants, length: MemoryLayout<ModelConstants>.size, index: 1)
        
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
        
    }
    
}

