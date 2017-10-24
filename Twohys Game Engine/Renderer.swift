import MetalKit

class Renderer: NSObject{
    
    var renderPipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var renderPipelineStateProvider: FlashPipelineStateProvider!
    
    var scene: Scene!
    
    var vertices: [Vertex]!
    var vertexBuffer: MTLBuffer!
    
    init(device: MTLDevice, mtkView: MTKView){
        super.init()
        commandQueue = device.makeCommandQueue()
        FlashPipelineStateProvider.setDeviceAndView(device: device, mtkView: mtkView)
        scene = Scene(device: device)
    }

}

extension Renderer: MTKViewDelegate{
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {  }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable, let passDescriptor = view.currentRenderPassDescriptor else { return }
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: passDescriptor)
        
        scene.render(renderCommandEncoder: commandEncoder!)
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
        
    }
    
}

