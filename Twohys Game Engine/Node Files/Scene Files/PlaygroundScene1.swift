import MetalKit

class PlaygroundScene1: Scene{
    
    var speed: Float = 16.0
    
    var circle1: Circle!
    var circle2: Circle!
    var circle3: Circle!
    
    override func buildScene(device: MTLDevice) {
        super.buildScene(device: device)
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
    
    private func getDistance(x1: Float, y1: Float, x2: Float, y2: Float)->Float{
        let xDistance = x2 - x1
        let yDistance = y2 - y1
        
        return sqrt(pow(xDistance, 2) + pow(yDistance, 2))
    }
    
    override func updateModels(deltaTime: Float) {
//        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Right)){
//            circle2.position.x += deltaTime * speed
//        }
//        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Left)){
//            circle2.position.x -= deltaTime * speed
//        }
        circle2.position.x += deltaTime * speed
        
        let distance1 = getDistance(x1: circle1.position.x, y1: circle1.position.y, x2: circle2.position.x, y2: circle2.position.y)
        let distance2 = getDistance(x1: circle3.position.x, y1: circle3.position.y, x2: circle2.position.x, y2: circle2.position.y)
        
        if(distance1 <= (circle1.radius + circle2.radius) || distance2 <= (circle2.radius + circle3.radius)){
            speed = -speed
        }
//        print(circle2.radius + circle3.radius)
    }
    
    
    
    override func updateCamera(deltaTime: Float) {
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_W)){
            camera.position.z -= deltaTime * speed
        }
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_S)){
            camera.position.z += deltaTime * speed
        }
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_A)){
            camera.position.x -= deltaTime * speed
        }
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_D)){
            camera.position.x += deltaTime * speed
        }
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Q)){
            camera.position.y -= deltaTime * speed
        }
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_E)){
            camera.position.y += deltaTime * speed
        }
        if(MouseHandler.isMouseButtonPressed(button: MOUSE_BUTTON_CODES.LEFT)){
            camera.yaw += MouseHandler.getDX() / 100
        }
        if(MouseHandler.isMouseButtonPressed(button: MOUSE_BUTTON_CODES.RIGHT)){
            camera.pitch += MouseHandler.getDY() / 100
        }
        if(MouseHandler.isMouseButtonPressed(button: MOUSE_BUTTON_CODES.RIGHT)){
            camera.pitch += MouseHandler.getDY() / 100
        }
    }
}


