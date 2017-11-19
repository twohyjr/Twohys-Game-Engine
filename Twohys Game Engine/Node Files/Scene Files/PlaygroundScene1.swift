import MetalKit

class PlaygroundScene1: Scene{
    
    let speed: Float = 2.0
    
    override func buildScene(device: MTLDevice) {
        super.buildScene(device: device)
        camera.position.z = 3
        
        mainTerrain = Terrain(device: device, gridSize: 2, backgroundTexture: "", heightMapImage: "")
        mainTerrain.position.x = -Float(mainTerrain.gridSize) / Float(2.0)
        mainTerrain.position.z = -Float(mainTerrain.gridSize) / Float(2.0)
        mainTerrain.position.y = -1
        
        add(child: mainTerrain)
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


