import MetalKit

class Renderer: NSObject{

    var commandQueue: MTLCommandQueue!
    var scene: Scene!
    
    init(device: MTLDevice){
        super.init()
        scene = BasicScene(device: device)
        buildCommandQueue(device)
    }
    
    private func buildCommandQueue(_ device: MTLDevice){
        commandQueue = device.makeCommandQueue()
    }
}

extension Renderer: MTKViewDelegate{
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {  }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable, let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        let commandBuffer = commandQueue.makeCommandBuffer()
        commandBuffer?.addCompletedHandler { (_) in self.scene.signalBufferProvider() }
        
        let deltaTime = 1 / Float(view.preferredFramesPerSecond)
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        scene.render(renderCommandEncoder: commandEncoder!, deltaTime: deltaTime)
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
