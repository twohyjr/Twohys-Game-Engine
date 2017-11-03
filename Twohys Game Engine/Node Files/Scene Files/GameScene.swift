import MetalKit

class GameScene: Scene{
    
    var mainTerrain: Terrain!
    var player: Player!
    
    override func buildScene(device: MTLDevice) {
        camera.fov =  100
        camera.position.y = -1
        camera.rotation.x = 6.5
        
        mainTerrain = Terrain(device: device, textureName: "grass.png")
        player = Player(device: device)
        player.scale = float3(0.5)
        player.position.z = -5
        
        fog.density = 0.0035
        fog.gradient = 2.0
        
        mainTerrain.position.x = -Float(mainTerrain.GRID_SIZE) / Float(2.0)
        mainTerrain.position.z = -Float(mainTerrain.GRID_SIZE) / Float(2.0)
        mainTerrain.position.y = -2

        add(child: player)
        add(child: mainTerrain)
    }

    override func checkKeyInput() {
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_A)){
            player.currentTurnSpeed = player.TURN_SPEED
        }else if(InputHandler.isKeyPressed(key: KEY_CODES.Key_D)){
            player.currentTurnSpeed = -player.TURN_SPEED
        }else{
            player.currentTurnSpeed = 0
        }
        
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_S)){
            player.currentSpeed = -player.RUN_SPEED
        }else if(InputHandler.isKeyPressed(key: KEY_CODES.Key_W)){
            player.currentSpeed = player.RUN_SPEED
        }else{
            player.currentSpeed = 0
        }
        
        if(InputHandler.isKeyPressed(key: KEY_CODES.Spacebar)){
            player.jump()
        }
    }

    override func updateCamera(deltaTime: Float) {
        
    }
    

    
    override func updateModels(deltaTime: Float) {
        player.update(deltaTime: deltaTime)
    }
}


