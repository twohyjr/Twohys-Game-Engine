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

var constants = Constants()

extension Renderer: MTKViewDelegate{
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {  }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable, let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        let deltaTime = 1 / Float(view.preferredFramesPerSecond)
        constants.moveBy += deltaTime
        
        commandEncoder?.setVertexBytes(&constants, length: MemoryLayout<Constants>.stride, index: 1)
        
        scene.render(renderCommandEncoder: commandEncoder!)
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
