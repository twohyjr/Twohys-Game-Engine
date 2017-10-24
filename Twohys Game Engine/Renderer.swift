import MetalKit

class Renderer: NSObject{
    
    var renderPipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var renderPipelineStateProvider: RenderPipelineStateProvider!
    
    var vertices: [Vertex]!
    var vertexBuffer: MTLBuffer!
    
    init(device: MTLDevice, mtkView: MTKView){
        super.init()
        commandQueue = device.makeCommandQueue()
        RenderPipelineStateProvider.setDeviceAndView(device: device, mtkView: mtkView)
        buildBuffers(device: device)
    }
    
    func buildBuffers(device: MTLDevice){
        
        vertices = []
        
        let trianglesPerSection: Int = 64
        var lastPos: float2 = float2(0)
        let size: Float = 0.8
        
        for i in (0 ... trianglesPerSection).reversed() {
            let red = Float(CGFloat(Float(arc4random()) / Float(UINT32_MAX)))
            let green = Float(CGFloat(Float(arc4random()) / Float(UINT32_MAX)))
            let blue = Float(CGFloat(Float(arc4random()) / Float(UINT32_MAX)))
            
            let val: Float = i == 0 ? 0 :  Float((360.0 / Double(trianglesPerSection)) * Double(i))
            let pos = float2(size * cos(radians(fromDegrees:  val)), size * sin(radians(fromDegrees:  val)))
            vertices.append(Vertex(position: float3(0, 0, 0), color: float4(red, green, blue, 1), normal: float3(1,2,3), textureCoordinate: float2(0,1)))
            vertices.append(Vertex(position: float3(pos.x, pos.y, 0), color: float4(red, green, blue, 1), normal: float3(1,2,3), textureCoordinate: float2(0,1)))
            vertices.append(Vertex(position: float3(lastPos.x, lastPos.y, 0), color: float4(red, green, blue, 1), normal: float3(1,2,3), textureCoordinate: float2(0,1)))
            lastPos = pos
        }
        vertexBuffer = device.makeBuffer(bytes: vertices, length: MemoryLayout<Vertex>.stride * vertices.count, options: [])
    }
    
    
}

extension Renderer: MTKViewDelegate{
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {  }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable, let passDescriptor = view.currentRenderPassDescriptor else { return }
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: passDescriptor)
        commandEncoder?.setRenderPipelineState(RenderPipelineStateProvider.getFlashPipelineState(flashPipelineStateType: FlashPipelineStateType.RENDERABLE))
        
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
        
    }
    
}

