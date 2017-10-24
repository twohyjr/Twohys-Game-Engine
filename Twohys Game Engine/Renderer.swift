import MetalKit

class Renderer: NSObject{
    
    var renderPipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    
    var vertices: [Vertex]!
    var vertexBuffer: MTLBuffer!
    
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

            //Normal
            vertexDescriptor.attributes[2].format = .float3
            vertexDescriptor.attributes[2].bufferIndex = 0
            vertexDescriptor.attributes[2].offset = MemoryLayout<float3>.size + MemoryLayout<float4>.size

            //Texture Coordinate
            vertexDescriptor.attributes[3].format = .float2
            vertexDescriptor.attributes[3].bufferIndex = 0
            vertexDescriptor.attributes[3].offset = MemoryLayout<float3>.size + MemoryLayout<float4>.size + MemoryLayout<float3>.size

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
        
        vertices.append(Vertex(position: float3( 0, 1, 0), color: float4(1, 0, 0, 1)))
        vertices.append(Vertex(position: float3(-1,-1, 0), color: float4(0, 1, 0, 1)))
        vertices.append(Vertex(position: float3( 1,-1, 0), color: float4(0, 0, 1, 1)))
        
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
        
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
        
    }
    
}

