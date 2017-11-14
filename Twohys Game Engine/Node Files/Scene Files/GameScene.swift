import MetalKit

class GameScene: Scene{
    
    var sun: Model!
    var grass: Quad!
    var tree: Model!
    
    override func buildScene(device: MTLDevice) {
        super.buildScene(device: device)
        
        mainTerrain = Terrain(device: device, textureName: "grass.png", heightMapImage: "heightmap.jpg")
        mainTerrain.position.x = -Float(mainTerrain.GRID_SIZE) / Float(2.0)
        mainTerrain.position.z = -Float(mainTerrain.GRID_SIZE) / Float(2.0)
        mainTerrain.position.y = -1
        mainTerrain.materialColor = float4(0.40)
        
        grass = Quad(device: device, textureName: "tall-grass.png")
        grass.position.z = -1
        grass.position.x = -4
        grass.position.y = mainTerrain.GetHeightOfTerrain(worldX: grass.position.x, worldZ: grass.position.z) - 0.5
        grass.scale = float3(0.7)
        
        tree = Model(device: device, modelName: "lowpolytree", textureName: "")
        tree.materialColor = float4(0.2,0.63,0.13, 1)
        tree.position = float3(4, mainTerrain.GetHeightOfTerrain(worldX: tree.position.x, worldZ: tree.position.z) + 1, -1)
        
        sun = Model(device: device, modelName: "sun", textureName: "")
        sun.materialColor = float4(0.9, 0.85,0.2,1)
        sun.scale = float3(0.5)
        sun.position = float3(0,mainTerrain.GetHeightOfTerrain(worldX: grass.position.x, worldZ: grass.position.z) + 4,0)
        light.position = sun.position
        add(child: sun)
        
        fog.density = 0.015
        fog.gradient = 2.0
        
        add(child: tree)
        add(child: grass)
        add(child: mainTerrain)
    }

    var time: Float = 0
    override func updateModels(deltaTime: Float) {
        super.updateModels(deltaTime: deltaTime)
        tree.rotation.y += deltaTime
        time += deltaTime
    }
}


