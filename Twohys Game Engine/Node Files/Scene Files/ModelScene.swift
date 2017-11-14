import MetalKit

class ModelScene: Scene{
    
    
    override func buildScene(device: MTLDevice) {
        super.buildScene(device: device)
        light.position = float3(0,0,1)
        
        player = Player(device: device)
        player.shininess = 0.01
        player.specularIntensity = 0.01
    
        camera.distanceFromPlayer = -4
        
        add(child: player)
        
    }
    
    override func updateModels(deltaTime: Float) {
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Right)){
            player.rotation.y += deltaTime
        }
        
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Left)){
            player.rotation.y -= deltaTime
        }
    }
}


