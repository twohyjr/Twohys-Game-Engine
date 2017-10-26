import MetalKit

class Scene: Node{
    
    var sceneConstants = SceneConstants()
    var camera = Camera()

    init(device: MTLDevice){
        super.init()
        bufferProvider = BufferProvider(device: device, inflightBuffersCount: 3, sizeOfUniformsBuffer: MemoryLayout<SceneConstants>.stride)
    }
    
    func signal(){
        bufferProvider.avaliableResourcesSemaphore.signal()
        for child in children{
            child.bufferProvider.avaliableResourcesSemaphore.signal()
        }
    }
    
    func render(renderCommandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        
        sceneConstants.projectionMatrix = camera.projectionMatrix
        var constants = bufferProvider.nextUniformsBuffer(uniforms: &sceneConstants)
        renderCommandEncoder.setVertexBytes(&constants, length: MemoryLayout<SceneConstants>.stride, index: 1)
        for child in children{
            child.render(renderCommandEncoder: renderCommandEncoder, parentModelMatrix: camera.viewMatrix)
        }
    }
    
}
