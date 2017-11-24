import MetalKit

class CircleCollisionScene: Scene{

    override func buildScene(device: MTLDevice) {
        super.buildScene(device: device)
        useFlyingCamera = true
        
        mainTerrain = Terrain(device: device, gridSize: 7, backgroundTexture: "", heightMapImage: "")
        mainTerrain.position.x = -Float(mainTerrain.gridSize) / Float(2.0)
        mainTerrain.position.z = -Float(mainTerrain.gridSize) / Float(2.0)
        mainTerrain.position.y = -1
    
        add(child: mainTerrain)
    }
    


}


