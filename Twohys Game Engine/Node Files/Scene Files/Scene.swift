import MetalKit

class Scene: Node{
    
    var sceneConstants = SceneConstants()
    var camera: Camera!
    var light = Light()
    var fog = Fog()
    var player: Player!
    var mainTerrain: Terrain!
    var useFlyingCamera: Bool = false
    var cameraSpeed: Float = 2.0

    init(device: MTLDevice){
        super.init()
        player = Player(device: device)
        camera = Camera(player: player)
        
        buildScene(device: device)
        
    }

    func buildScene(device: MTLDevice){ }
    
    func checkKeyInput(){ }
    
    func updatePlayer(deltaTime: Float){
        if(player !== nil){
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
            if(mainTerrain !== nil){
                player.update(deltaTime: deltaTime, terrain: mainTerrain)
            }
        }
    }
    
    func updateModels(deltaTime: Float){
        updatePlayer(deltaTime: deltaTime)
    }
    
    func updateCamera(deltaTime: Float){
        if(useFlyingCamera){
            if(InputHandler.isKeyPressed(key: KEY_CODES.Key_W)){
                camera.position.z -= deltaTime * cameraSpeed
            }
            if(InputHandler.isKeyPressed(key: KEY_CODES.Key_S)){
                camera.position.z += deltaTime * cameraSpeed
            }
            if(InputHandler.isKeyPressed(key: KEY_CODES.Key_A)){
                camera.position.x -= deltaTime * cameraSpeed
            }
            if(InputHandler.isKeyPressed(key: KEY_CODES.Key_D)){
                camera.position.x += deltaTime * cameraSpeed
            }
            if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Q)){
                camera.position.y -= deltaTime * cameraSpeed
            }
            if(InputHandler.isKeyPressed(key: KEY_CODES.Key_E)){
                camera.position.y += deltaTime * cameraSpeed
            }
            if(MouseHandler.isMouseButtonPressed(button: MOUSE_BUTTON_CODES.LEFT)){
                camera.yaw += MouseHandler.getDX() / 100
            }
            if(MouseHandler.isMouseButtonPressed(button: MOUSE_BUTTON_CODES.RIGHT)){
                camera.pitch += MouseHandler.getDY() / 100
            }
            if(MouseHandler.isMouseButtonPressed(button: MOUSE_BUTTON_CODES.RIGHT)){
                camera.pitch += MouseHandler.getDY() / 100
            }
        }
        camera.update(useFlyingCamera: useFlyingCamera)
    }
    
    func doRender(renderCommandEncoder: MTLRenderCommandEncoder){
        sceneConstants.projectionMatrix = camera.projectionMatrix
        sceneConstants.fogGradient = fog.gradient
        sceneConstants.fogDensity = fog.density
        sceneConstants.viewMatrix = camera.viewMatrix
        sceneConstants.inverseViewMatrix = camera.viewMatrix.inverse
        
        
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
