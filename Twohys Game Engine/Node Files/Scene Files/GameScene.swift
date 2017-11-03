import MetalKit

class GameScene: Scene{
    
    var mainTerrain: Terrain!
    var player: Armadillo!
    
    var RUN_SPEED: Float = 5
    var TURN_SPEED: Float = 3
    var GRAVITY: Float = -50
    var JUMP_POWER: Float = 10
    var TERRAIN_HEIGHT: Float = 0
    
    var currentSpeed: Float = 0
    var currentTurnSpeed: Float = 0
    var upwardSpeed: Float = 0
    
    var isInAir: Bool = false
    
    override func buildScene(device: MTLDevice) {
        camera.fov =  100
        camera.position.y = -1
        camera.rotation.x = 6.5
        
        mainTerrain = Terrain(device: device, textureName: "grass.png")
        player = Armadillo(device: device)
        player.scale = float3(0.5)
        player.position.z = -5
        
        fog.density = 0.035;
        fog.gradient = 2.0
        
        mainTerrain.position.x = -Float(mainTerrain.GRID_SIZE) / Float(2.0)
        mainTerrain.position.z = -Float(mainTerrain.GRID_SIZE) / Float(2.0)
        mainTerrain.position.y = -2
        
        add(child: player)
        add(child: mainTerrain)
    }

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
        
        if(InputHandler.isKeyPressed(key: KEY_CODES.Spacebar)){
            jump()
        }
    }

    override func updateCamera(deltaTime: Float) {
        
    }
    
    private func jump(){
        if(!isInAir){
            self.upwardSpeed = JUMP_POWER
            isInAir = true
        }
    }
    
    override func updateModels(deltaTime: Float) {
       player.rotation += float3(0, currentTurnSpeed * deltaTime, 0)
        let distance = currentSpeed * deltaTime
        let dx = distance * sin(player.rotation.y)
        let dy = distance * cos(player.rotation.y)
        player.position.x -= dx
        player.position.z -= dy
        upwardSpeed += GRAVITY * deltaTime
        player.position.y += upwardSpeed * deltaTime
        if(player.position.y < TERRAIN_HEIGHT){
            upwardSpeed = 0
            isInAir = false
            player.position.y = TERRAIN_HEIGHT
        }
    }
}


