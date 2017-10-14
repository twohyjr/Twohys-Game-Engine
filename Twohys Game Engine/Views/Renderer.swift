import MetalKit

class Renderer: NSObject{
    
    var renderPipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    
    var vertices: [Vertex]!
    
    var vertexBuffer: MTLBuffer!
    
    init(device: MTLDevice){
        super.init()
        buildCommandQueue(device)
        buildRenderPipelineState(device)
        buildBuffers(device)
    }
    
    private func buildCommandQueue(_ device: MTLDevice){
        commandQueue = device.makeCommandQueue()
    }
    
    private func buildRenderPipelineState(_ device: MTLDevice){
        let library = device.makeDefaultLibrary()
        let vertedFunction = library?.makeFunction(name: "basic_vertex_function")
        let fragmentFunction = library?.makeFunction(name: "basic_fragment_function")
        
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.vertexFunction = vertedFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        
        do{
            renderPipelineState = try device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        }catch let error as NSError{
            print("Error creating renderPipelineState: \(error)")
        }
    }
    
    private func buildBuffers(_ device: MTLDevice){
        vertices = [
            Vertex(position: float3( 0, 1, 0), color: float4(1,0,0,1)),
            Vertex(position: float3(-1,-1, 0), color: float4(0,1,0,1)),
            Vertex(position: float3( 1,-1, 0), color: float4(0,0,1,1))
        ]
        
        vertexBuffer = device.makeBuffer(bytes: vertices, length: MemoryLayout<Vertex>.stride * vertices.count, options: [])
    }
}

extension Renderer: MTKViewDelegate{
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        //TODO: Update view when screen is resized
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable, let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        commandEncoder?.setRenderPipelineState(renderPipelineState)
        
        commandEncoder?.pushDebugGroup("Set Vertex Buffer")
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder?.popDebugGroup()
        
        commandEncoder?.pushDebugGroup("Draw Primitives")
        commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        commandEncoder?.popDebugGroup()
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
