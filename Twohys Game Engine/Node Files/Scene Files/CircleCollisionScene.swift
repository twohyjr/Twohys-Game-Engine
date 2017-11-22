import MetalKit

class CircleCollisionScene: Scene{
    
    var circle1: Circle!
    var circle2: Circle!
    var circle3: Circle!
    
    override func buildScene(device: MTLDevice) {
        super.buildScene(device: device)
        useFlyingCamera = true
        cameraSpeed = 5.0
        
        camera.position = float3(-10.3334, 4.33333, 18.7667)
        
        
        mainTerrain = Terrain(device: device, gridSize: 2, backgroundTexture: "", heightMapImage: "")
//        mainTerrain.position.x = -Float(mainTerrain.gridSize) / Float(2.0)
//        mainTerrain.position.z = -Float(mainTerrain.gridSize) / Float(2.0)
//        mainTerrain.position.y = -1
        
        circle1 = Circle(device: device, circleVertexCount: 256, radius: 1.5)
        circle1.position.z = mainTerrain.position.z + (Float(mainTerrain.gridSize) / 2)
        circle1.materialColor = float4(0,0,0,1)
        
        circle2 = Circle(device: device, circleVertexCount: 256, radius: 1.0)
        circle2.position.z = mainTerrain.position.z + (Float(mainTerrain.gridSize) / 2)
        circle2.position.x = -5
        circle2.materialColor = float4(1,0,0,1)
        
        circle3 = Circle(device: device, circleVertexCount: 256, radius: 1.5)
        circle3.position.z = mainTerrain.position.z + (Float(mainTerrain.gridSize) / 2)
        circle3.position.x = -20
        circle3.materialColor = float4(0,0,0,1)

        add(child: circle1)
        add(child: circle2)
        add(child: circle3)
//        add(child: mainTerrain)
    }
    

    
    override func updateModels(deltaTime: Float) {
//        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Right)){
//            circle2.position.x += deltaTime * speed
//        }
//        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Left)){
//            circle2.position.x -= deltaTime * speed
//        }
//        print(circle2.radius + circle3.radius)
                checkCollision()
    }
}


