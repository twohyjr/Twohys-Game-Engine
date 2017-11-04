import MetalKit

class GameScene: Scene{
    
    var mainTerrain: Terrain!
    
    override func buildScene(device: MTLDevice) {
        camera.fov =  100
        
        mainTerrain = Terrain(device: device, textureName: "grass.png")
       
        mainTerrain.position.x = -Float(mainTerrain.GRID_SIZE) / Float(2.0)
        mainTerrain.position.z = -Float(mainTerrain.GRID_SIZE) / Float(2.0)
        mainTerrain.position.y = -1
        
        player.position.z = -5
        
        fog.density = 0.0035
        fog.gradient = 2.0

        add(child: player)
        add(child: mainTerrain)
    }

    override func checkKeyInput() {
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
        camera.move()
    }

    override func updateCamera(deltaTime: Float) {
        
    }
    

    
    override func updateModels(deltaTime: Float) {
        player.update(deltaTime: deltaTime)
    }
}


