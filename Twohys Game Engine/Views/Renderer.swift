import MetalKit

class Renderer: NSObject{
    
    var renderPipelineState: MTLRenderPipelineState!
    var computePipelineState: MTLComputePipelineState!
    
    
    var commandQueue: MTLCommandQueue!
    var renderPipelineStateProvider: FlashPipelineStateProvider!
    
    var depthStencilState: MTLDepthStencilState!
    
    var samplerState: MTLSamplerState!

    var scene: Scene!
    
    var vertices: [Vertex]!
    var vertexBuffer: MTLBuffer!
    
    var outComputeBuffer: MTLBuffer!
    
    private var frameStartTime: CFAbsoluteTime!
    private var frameNumber = 0
    
    var mapTexture: MapTexture!

    init(device: MTLDevice, mtkView: MTKView){
        super.init()
        
        commandQueue = device.makeCommandQueue()
        FlashPipelineStateProvider.setDeviceAndView(device: device, mtkView: mtkView)
        scene = ModelScene(device: device)
        scene.camera.aspectRatio = Float(mtkView.drawableSize.width) / Float(mtkView.drawableSize.height)
        buildDepthStencilState(device: device)
        buildSamplerState(device: device)
        frameStartTime = CFAbsoluteTimeGetCurrent()
        mapTexture = MapTexture(device: device, imageName: "bright.png")
        createComputeStuff(device: device)
        initialize()
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
    
    func createComputeStuff(device: MTLDevice){
        let library = device.makeDefaultLibrary()
        let program = library?.makeFunction(name: "shader")
    
        do{
            computePipelineState = try device.makeComputePipelineState(function: program!)
        }catch{
            print(error)
        }
        
        var resultData = float4(0)
        outComputeBuffer = device.makeBuffer(bytes: &resultData, length: MemoryLayout<float4>.size, options: MTLResourceOptions.optionCPUCacheModeWriteCombined)
    }
    
    func initialize(){
//        let commandBuffer = commandQueue.makeCommandBuffer()
//
//        let computeCommandEncoder = commandBuffer?.makeComputeCommandEncoder()
//        computeCommandEncoder?.setComputePipelineState(computePipelineState)
//        computeCommandEncoder?.setBuffer(outComputeBuffer, offset: 0, index: 0)
//
//        let w = computePipelineState.threadExecutionWidth
//        let h = computePipelineState.maxTotalThreadsPerThreadgroup / w
//        let threadsPerThreadgroup = MTLSizeMake(w, h, 1)
//
//        let threadsPerGrid = MTLSize(width: (mapTexture.texture?.width)!,
//                                     height: (mapTexture.texture?.height)!,
//                                     depth: 1)
//
//        computeCommandEncoder?.setTexture(mapTexture.texture, index: 0)
//        computeCommandEncoder?.setSamplerState(samplerState, index: 0)
//        computeCommandEncoder?.dispatchThreadgroups(threadsPerGrid,
//                                              threadsPerThreadgroup: threadsPerThreadgroup)
//        computeCommandEncoder?.endEncoding()
//        commandBuffer?.addCompletedHandler{ commandBuffer in
//            let data = NSData(bytes: self.outComputeBuffer.contents(), length: MemoryLayout<float4>.size)
//            var out: float4 = float4(0)
//            data.getBytes(&out, length: MemoryLayout<float4>.size)
//            print("data: \(out)")
//        }
//        commandBuffer?.commit()
        
        
        
    }
}

extension Renderer: MTKViewDelegate{
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        scene.camera.aspectRatio = Float(size.width) / Float(size.height)
    }
    
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
        
        let deltaTime: Float = (Float(1.0) / Float(view.preferredFramesPerSecond))
        scene.render(renderCommandEncoder: renderCommandEncoder!, deltaTime: deltaTime)

        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
    private func getCurrentTime()->Float{
        var frametime: Float
        frametime = Float((CFAbsoluteTimeGetCurrent() - frameStartTime) / 100)
        print(String(format: "%.1f fps", 1 / frametime))
        frameStartTime = CFAbsoluteTimeGetCurrent()
        frameNumber = 0
        return frametime
    }
    
}

