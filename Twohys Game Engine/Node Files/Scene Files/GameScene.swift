import MetalKit

class GameScene: Scene{
    
    var sun: Model!
    var grass: Quad!
    var tree: Model!
    
    override func buildScene(device: MTLDevice) {
        super.buildScene(device: device)
        
        mainTerrain = Terrain(device: device, gridSize: 800, backgroundTexture: "grass.png", heightMapImage: "heightmap.jpg")
        mainTerrain.position.x = -Float(mainTerrain.gridSize) / Float(2.0)
        mainTerrain.position.z = -Float(mainTerrain.gridSize) / Float(2.0)
        mainTerrain.position.y = -1
        
        
        grass = Quad(device: device, textureName: "fern.png")
        grass.position.z = -1
        grass.position.x = -4
        grass.position.y = mainTerrain.GetHeightOfTerrain(worldX: grass.position.x, worldZ: grass.position.z) - 0.5
        grass.scale = float3(0.7)
        
        tree = Model(device: device, modelName: "lowPolyTree", textureName: "")
        tree.materialColor = float4(0.2,0.63,0.13, 1)
        tree.scale = float3(0.3)
        tree.position = float3(4, mainTerrain.GetHeightOfTerrain(worldX: tree.position.x, worldZ: tree.position.z) - 3, -1)
        
        sun = Model(device: device, modelName: "sun", textureName: "")
        sun.materialColor = float4(0.9, 0.85,0.2,1)
        sun.scale = float3(0.5)
        sun.position = float3(0,mainTerrain.GetHeightOfTerrain(worldX: grass.position.x, worldZ: grass.position.z) + 50,30)
        light.position = sun.position
        light.brightness = 1.5
        add(child: sun)
        
        player.specularIntensity = 1.0
        player.shininess = 10.0

        fog.density = 0.001
        fog.gradient = 2.0
        
        add(child: tree)
        add(child: grass)
        add(child: player)
        add(child: mainTerrain)
    }

    var time: Float = 0
    override func updateModels(deltaTime: Float) {
        super.updateModels(deltaTime: deltaTime)
        time += deltaTime
    }
}


