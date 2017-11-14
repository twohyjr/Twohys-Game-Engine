import MetalKit

class Scene: Node{
    
    var sceneConstants = SceneConstants()
    var camera: Camera!
    var light = Light()
    var fog = Fog()
    var player: Player!
    var mainTerrain: Terrain!

    init(device: MTLDevice){
        super.init()
        
        if(player !== nil){
            
            camera = Camera(player: player)
        }else{
            camera = Camera()
        }
        
        buildScene(device: device)
        
        if(player !== nil){
            add(child: player)
        }
        if(mainTerrain !== nil){
            add(child: mainTerrain)
        }
    }

    func buildScene(device: MTLDevice){ }
    
    func checkKeyInput(){ }
    
    func updatePlayer(deltaTime: Float){
         if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Left)){
             player.currentTurnSpeed = player.TURN_SPEED
         }else if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Right)){
             player.currentTurnSpeed = -player.TURN_SPEED
         }else{
             player.currentTurnSpeed = 0
         }
        
         if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Down)){
             player.currentSpeed = -player.RUN_SPEED
         }else if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Up)){
             player.currentSpeed = player.RUN_SPEED
         }else{
             player.currentSpeed = 0
         }
        
         if(InputHandler.isKeyPressed(key: KEY_CODES.Spacebar)){
             player.jump()
         }
        player.update(deltaTime: deltaTime, terrain: mainTerrain)
    }
    
    func updateModels(deltaTime: Float){
        updatePlayer(deltaTime: deltaTime)
    }
    
    func updateCamera(deltaTime: Float){
        if(mainTerrain !== nil){
            camera.update(terrain: mainTerrain)            
        }
    }
    
    func doRender(renderCommandEncoder: MTLRenderCommandEncoder){
        sceneConstants.projectionMatrix = camera.projectionMatrix
        sceneConstants.fogGradient = fog.gradient
        sceneConstants.fogDensity = fog.density
        sceneConstants.viewMatrix = camera.viewMatrix
        
        
        renderCommandEncoder.setVertexBytes(&sceneConstants, length: MemoryLayout<SceneConstants>.stride, index: 1)
        renderCommandEncoder.setFragmentBytes(&light, length: MemoryLayout<Light>.stride, index: 1)
        
        for child in children{
            child.render(renderCommandEncoder: renderCommandEncoder, parentModelMatrix: camera.viewMatrix)
        }
    }
    
    func render(renderCommandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        checkKeyInput()
        
        if(player !== nil){
            updateModels(deltaTime: deltaTime)
        }
        
        updateCamera(deltaTime: deltaTime)
        
        doRender(renderCommandEncoder: renderCommandEncoder)
    }
    
}
