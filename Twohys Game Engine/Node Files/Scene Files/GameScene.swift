import MetalKit

class GameScene: Scene{
    
    var mainTerrain: Terrain!
    var player: Cube!
    
    override func buildScene(device: MTLDevice) {
        mainTerrain = Terrain(device: device, textureName: "grass.png")
       
        mainTerrain.position.x = -Float(mainTerrain.GRID_SIZE) / Float(2.0)
        mainTerrain.position.z = -Float(mainTerrain.GRID_SIZE) / Float(2.0)
        mainTerrain.position.y = -1
        
        fog.density = 0.05
        fog.gradient = 2
        
        player = Cube(device: device)
        player.position.z = -5
        
        add(child: player)
        add(child: mainTerrain)
    }

    override func checkKeyInput() {
//        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Left)){
//            player.currentTurnSpeed = player.TURN_SPEED
//        }else if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Right)){
//            player.currentTurnSpeed = -player.TURN_SPEED
//        }else{
//            player.currentTurnSpeed = 0
//        }
//
//        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Down)){
//            player.currentSpeed = -player.RUN_SPEED
//        }else if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Up)){
//            player.currentSpeed = player.RUN_SPEED
//        }else{
//            player.currentSpeed = 0
//        }
//
//        if(InputHandler.isKeyPressed(key: KEY_CODES.Spacebar)){
//            player.jump()
//        }

    }

    override func updateCamera(deltaTime: Float) {
//        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Left)){
//            camera.position.x += deltaTime
//        }
//        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Right)){
//            camera.position.x -= deltaTime
//        }
//        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Down)){
//            camera.position.y += deltaTime
//        }
//        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Up)){
//            camera.position.y -= deltaTime
//        }
        camera.position.x = player.position.x
        camera.position.z = player.position.z + 5
    }
    
    override func updateModels(deltaTime: Float) {
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_A)){
            player.position.x -= deltaTime
        }
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_D)){
            player.position.x += deltaTime
        }
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_W)){
            player.position.z -= deltaTime
        }
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_S)){
            player.position.z += deltaTime
        }
    }
}


