import MetalKit

class Renderer: NSObject{
    
    var renderPipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var renderPipelineStateProvider: FlashPipelineStateProvider!
    
    var depthStencilState: MTLDepthStencilState!
    
    var samplerState: MTLSamplerState!

    var scene: Scene!
    
    var vertices: [Vertex]!
    var vertexBuffer: MTLBuffer!
    
    init(device: MTLDevice, mtkView: MTKView){
        super.init()
        commandQueue = device.makeCommandQueue()
        FlashPipelineStateProvider.setDeviceAndView(device: device, mtkView: mtkView)
        scene = PlaygroundScene1(device: device)
        buildDepthStencilState(device: device)
        buildSamplerState(device: device)
    }
    
    func buildDepthStencilState(device: MTLDevice){
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.isDepthWriteEnabled = true
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilDescriptor.label = "Twohy's Depth Stencil Descriptor"
        depthStencilState = device.makeDepthStencilState(descriptor: depthStencilDescriptor)
    }
    
    func buildSamplerState(device: MTLDevice){
        let samplerDescriptor = MTLSamplerDescriptor()
        samplerDescriptor.minFilter = .linear
        samplerDescriptor.magFilter = .linear
        samplerDescriptor.label = "Twohy's Sampler"
        samplerState = device.makeSamplerState(descriptor: samplerDescriptor)
    }

}

extension Renderer: MTKViewDelegate{
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {  }
    
    func updateTrackingArea(view: MTKView){
        let area = NSTrackingArea(rect: view.bounds, options: [NSTrackingArea.Options.activeAlways, NSTrackingArea.Options.mouseMoved, NSTrackingArea.Options.enabledDuringMouseDrag], owner: view, userInfo: nil)
        view.addTrackingArea(area)
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable, let passDescriptor = view.currentRenderPassDescriptor else { return }

        let commandBuffer = commandQueue.makeCommandBuffer()
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: passDescriptor)
        renderCommandEncoder?.setDepthStencilState(depthStencilState)
        renderCommandEncoder?.setFragmentSamplerState(samplerState, index: 0)
//        renderCommandEncoder?.setTriangleFillMode(.lines)
        //renderCommandEncoder?.setCullMode(.front)
        
        let deltaTime: Float = 1 / Float(view.preferredFramesPerSecond)
        scene.render(renderCommandEncoder: renderCommandEncoder!, deltaTime: deltaTime)
        
        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
        
    }
    
}

