import MetalKit

class Scene: Node{
    
    var sceneConstants = SceneConstants()
    var player: Player!
    var camera: Camera!
    var light = Light()
    var fog = Fog()

    init(device: MTLDevice){
        super.init()
        player = Player(device: device)
        camera = Camera()
        
        buildScene(device: device)
        
        add(child: player)
    }

    func buildScene(device: MTLDevice){ }
    
    func checkKeyInput(){ }
    
    func updateModels(deltaTime: Float){ }
    
    func updateCamera(deltaTime: Float){
        sceneConstants.projectionMatrix = camera.projectionMatrix
    }
    
    func doRender(renderCommandEncoder: MTLRenderCommandEncoder){
        sceneConstants.projectionMatrix = camera.projectionMatrix
        sceneConstants.viewMatrix = camera.viewMatrix;
        sceneConstants.fogGradient = fog.gradient
        sceneConstants.fogDensity = fog.density
        
        renderCommandEncoder.setVertexBytes(&sceneConstants, length: MemoryLayout<SceneConstants>.stride, index: 1)
        renderCommandEncoder.setFragmentBytes(&light, length: MemoryLayout<Light>.stride, index: 1)
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
