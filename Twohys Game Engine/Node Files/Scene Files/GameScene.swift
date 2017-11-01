import MetalKit

class GameScene: Scene{
    
    var mainTerrain: Terrain!
    var player: Cube!
    
    var RUN_SPEED: Float = 20
    var TURN_SPEED: Float = 5
    
    var currentSpeed: Float = 0
    var currentTurnSpeed: Float = 0
    
    override func buildScene(device: MTLDevice) {
        camera.fov =  100
        
        mainTerrain = Terrain(device: device, textureName: "grass.png")
        player = Cube(device: device)
        player.materialColor = float4(0.23, 0.87, 0.67, 1)
        
        player.position.z = -10
        
        mainTerrain.position.x = -Float(mainTerrain.GRID_SIZE) / Float(2.0)
        mainTerrain.position.z = -Float(mainTerrain.GRID_SIZE) / Float(2.0)
        mainTerrain.position.y = -2
        
        add(child: player)
        add(child: mainTerrain)
    }
    
    var isJumping: Bool = false
    var isFalling: Bool = false
    
    override func checkKeyInput() {
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_A)){
            self.currentTurnSpeed = TURN_SPEED
        }else if(InputHandler.isKeyPressed(key: KEY_CODES.Key_D)){
            self.currentTurnSpeed = -TURN_SPEED
        }else{
            self.currentTurnSpeed = 0
        }
        
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_S)){
            self.currentSpeed = -RUN_SPEED
        }else if(InputHandler.isKeyPressed(key: KEY_CODES.Key_W)){
            self.currentSpeed = RUN_SPEED
        }else{
            self.currentSpeed = 0
        }
        
        if(!isJumping && !isFalling){
            if(InputHandler.isKeyPressed(key: KEY_CODES.Spacebar)){
                isJumping = true
            }
        }

        
        if(isJumping){
            player.position.y += 0.2
        }else if(isFalling){
            player.position.y -= 0.2
        }
        
        if(player.position.y >= 3){
            isJumping = false
            isFalling = true
        }
        if(player.position.y <= 0){
            player.position.y = 0
            isFalling = false
        }
        
        
        
        if(currentSpeed <= -20){
            currentSpeed = -20
        }
    }

    override func updateCamera(deltaTime: Float) {
        
    }
    
    override func updateModels(deltaTime: Float) {
       player.rotation += float3(0, currentTurnSpeed * Float(1.0/60.0), 0)
        let distance = currentSpeed * Float(1.0/60.0)
        let dx = distance * sin(player.rotation.y)
        let dy = distance * cos(player.rotation.y)
        player.position.x -= dx
        player.position.z -= dy
    }
}


