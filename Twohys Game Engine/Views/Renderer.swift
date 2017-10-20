import MetalKit

class Renderer: NSObject{

    var commandQueue: MTLCommandQueue!
    var bufferProvider: BufferProvider!
    var scene: Scene!
    
    init(device: MTLDevice){
        super.init()
        scene = BasicScene(device: device)
        buildCommandQueue(device)
        bufferProvider = BufferProvider(device: device, inflightBuffersCount: 3, sizeOfUniformsBuffer: MemoryLayout<Constants>.size)
    }
    
    private func buildCommandQueue(_ device: MTLDevice){
        commandQueue = device.makeCommandQueue()
    }
}

var constants = Constants()

extension Renderer: MTKViewDelegate{
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {  }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable, let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        
        bufferProvider.avaliableResourcesSemaphore.wait()
        let deltaTime = 1 / Float(view.preferredFramesPerSecond)
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        commandBuffer?.addCompletedHandler { (_) in self.bufferProvider.avaliableResourcesSemaphore.signal() }
        
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)        
        constants.moveBy += deltaTime
        
        let uniformBuffer:MTLBuffer = bufferProvider.nextUniformsBuffer(uniforms: &constants)
        commandEncoder?.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
        
        scene.render(renderCommandEncoder: commandEncoder!)
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
