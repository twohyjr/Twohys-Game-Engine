import MetalKit

class GameScene: Scene{
    
    var mainTerrain: Terrain!
    
    override func buildScene(device: MTLDevice) {
        mainTerrain = Terrain(device: device, textureName: "grass.png")
        mainTerrain.position.x = -Float(mainTerrain.GRID_SIZE) / Float(2.0)
        mainTerrain.position.z = -Float(mainTerrain.GRID_SIZE) / Float(2.0)
        mainTerrain.position.y = -1
        
        var grass = Quad(device: device, textureName: "tall-grass.png")
        grass.position.z = -1
        
        fog.density = 0.05
        fog.gradient = 2
        
        add(child: grass)
        add(child: mainTerrain)
    }
}


