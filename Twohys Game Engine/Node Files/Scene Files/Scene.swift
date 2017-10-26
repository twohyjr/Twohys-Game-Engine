import MetalKit

class Scene: Node{
    
    var sceneConstants = SceneConstants()
    var camera = Camera()

    init(device: MTLDevice){
        super.init()
        buildScene(device: device)
    }

    func buildScene(device: MTLDevice){ }
    
    func checkKeyInput(){ }
    
    func updateModels(deltaTime: Float){ }
    
    func updateCamera(deltaTime: Float){
        sceneConstants.projectionMatrix = camera.projectionMatrix
    }
    
    func doRender(renderCommandEncoder: MTLRenderCommandEncoder){
        sceneConstants.projectionMatrix = camera.projectionMatrix
        renderCommandEncoder.setVertexBytes(&sceneConstants, length: MemoryLayout<SceneConstants>.stride, index: 1)
        for child in children{
            child.render(renderCommandEncoder: renderCommandEncoder, parentModelMatrix: camera.viewMatrix)
        }
    }
    
    func render(renderCommandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        checkKeyInput()
        
        updateModels(deltaTime: deltaTime)
        
        updateCamera(deltaTime: deltaTime)
        
        doRender(renderCommandEncoder: renderCommandEncoder)
    }
    
}
