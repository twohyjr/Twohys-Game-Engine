import MetalKit

class ModelScene: Scene{
    
    
    override func buildScene(device: MTLDevice) {
        super.buildScene(device: device)
        light.position = float3(0,1,1)
        
        player = Player(device: device)
        player.shininess = 0.01
        player.specularIntensity = 0.01
    
        camera.distanceFromPlayer = -4
        
        add(child: player)
        
    }
}


