import MetalKit

class CircleCollisionScene: Scene{

    override func buildScene(device: MTLDevice) {
        super.buildScene(device: device)
        useFlyingCamera = true
        cameraSpeed = 35
        
        mainTerrain = Terrain(device: device, gridSize: 800, backgroundTexture: "grass.png", heightMapImage: "heightmap.jpg")
        mainTerrain.position.x = -Float(mainTerrain.gridSize) / Float(2.0)
        mainTerrain.position.z = -Float(mainTerrain.gridSize) / Float(2.0)
        mainTerrain.position.y = -1
        
        camera.position = float3(0.0, 58.7328, 0.899995)
        camera.pitch = 3.61
        camera.yaw = 0.0
        
        light.position = float3(0,100,0)
        light.brightness = 1.5
        
        add(child: mainTerrain)
    }
    


}


