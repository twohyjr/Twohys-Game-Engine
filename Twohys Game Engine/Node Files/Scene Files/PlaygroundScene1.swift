import MetalKit

class PlaygroundScene1: Scene{
    
    var quad: Quad!
    override func buildScene(device: MTLDevice) {
        camera.position.z = -4
        quad = Quad(device: device, textureName: "bright.png")
        add(child: quad)
    }
    
    override func updateCamera(deltaTime: Float) {
        //X&Y Axis
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Down)){camera.position.y -= 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Up)){camera.position.y += 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Right)){camera.position.x += 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Left)){camera.position.x -= 0.05}
        
        //Rotation
        if(InputHandler.getMousePosition().x >= 600.0){
            camera.rotation.y += 0.01
        }else if (InputHandler.getMousePosition().x >= 1.0 && InputHandler.getMousePosition().x <= 100.0){
            camera.rotation.y -= 0.01
        }
    }
    
    override func updateModels(deltaTime: Float) {
        //Model
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_W)){quad.position.z -= 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_S)){quad.position.z += 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_D)){quad.position.x += 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_A)){quad.position.x -= 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Z)){quad.position.y += 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_X)){quad.position.y -= 0.05}
    }
}

