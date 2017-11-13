import MetalKit

class Player: Armadillo{
    
    var RUN_SPEED: Float = 5
    var TURN_SPEED: Float = 3
    var GRAVITY: Float = -50
    var JUMP_POWER: Float = 10
    var TERRAIN_HEIGHT: Float = 0
    
    var currentSpeed: Float = 0
    var currentTurnSpeed: Float = 0
    var upwardSpeed: Float = 0

    var isInAir: Bool = false
    
    override init(device: MTLDevice) {
        super.init(device: device)
        
    }
    
    public func jump(){
        if(!isInAir){
            self.upwardSpeed = JUMP_POWER
            isInAir = true
        }
    }
    
    public func update(deltaTime: Float, terrain: Terrain){
        rotation += float3(0, currentTurnSpeed * deltaTime, 0)
        let distance = currentSpeed * deltaTime
        let dx = distance * sin(rotation.y)
        let dy = distance * cos(rotation.y)
        position.x -= dx
        position.z -= dy
        upwardSpeed += GRAVITY * deltaTime
        position.y += upwardSpeed * deltaTime
        let terrainHeight = terrain.GetHeightOfTerrain(worldX: self.position.x, worldZ: self.position.z)
        if(position.y <= terrainHeight){
            upwardSpeed = 0
            isInAir = false
            position.y = terrainHeight
        }
    }
    
}
