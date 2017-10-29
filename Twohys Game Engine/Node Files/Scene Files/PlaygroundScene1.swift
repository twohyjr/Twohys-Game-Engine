import MetalKit

class PlaygroundScene1: Scene{
    
    var quad: Quad!
    override func buildScene(device: MTLDevice) {
        camera.position.z = -4
        quad = Quad(device: device, textureName: "bright.png")
        add(child: quad)
    }
    
    override func updateCamera(deltaTime: Float) {
        
        //Model
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Down)){quad.position.z += 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Up)){quad.position.z -= 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Right)){quad.position.x += 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Left)){quad.position.x -= 0.05}
        
        //Camera
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_W)){camera.position.y += 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_S)){camera.position.y -= 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_D)){camera.position.x += 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_A)){camera.position.x -= 0.05}
    }
    
    override func updateModels(deltaTime: Float) {
        
    }
}

