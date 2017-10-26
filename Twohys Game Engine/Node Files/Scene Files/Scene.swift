import MetalKit

class Scene: Node{
    
    var sceneConstants = SceneConstants()
    var camera = Camera()

    init(device: MTLDevice){
        super.init()
        
    }
    
    func render(renderCommandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        sceneConstants.projectionMatrix = camera.projectionMatrix
        renderCommandEncoder.setVertexBytes(&sceneConstants, length: MemoryLayout<SceneConstants>.stride, index: 1)
        for child in children{
            child.render(renderCommandEncoder: renderCommandEncoder, parentModelMatrix: camera.viewMatrix)
        }
    }
    
}
