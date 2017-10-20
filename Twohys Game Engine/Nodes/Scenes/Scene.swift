import MetalKit

class Scene: Node{
    
    var sceneConstants = SceneConstants()
    
    init(device: MTLDevice){
        super.init()
        bufferProvider = BufferProvider(device: device, inflightBuffersCount: 3, sizeOfUniformsBuffer: MemoryLayout<SceneConstants>.size)
    }
    
    func updateScene(deltaTime: Float){
        sceneConstants.moveBy += deltaTime
    }
    
    func render(renderCommandEncoder: MTLRenderCommandEncoder, deltaTime: Float){
        bufferProvider.avaliableResourcesSemaphore.wait()
        updateScene(deltaTime: deltaTime)
     
        let sceneConstantBuffer: MTLBuffer = bufferProvider.nextUniformsBuffer(uniforms: &sceneConstants)
        
        renderCommandEncoder.pushDebugGroup("Setting Scene Constant Buffer")
        renderCommandEncoder.setVertexBuffer(sceneConstantBuffer, offset: 0, index: 2)
        renderCommandEncoder.popDebugGroup()
        for child in children{
            child.render(renderCommandEncoder: renderCommandEncoder)
        }
        
    }
    
}
