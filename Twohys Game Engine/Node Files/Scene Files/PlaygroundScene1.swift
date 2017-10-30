import MetalKit

class PlaygroundScene1: Scene{
    
    var quad: Quad!
    var terrain: Terrain!
    override func buildScene(device: MTLDevice) {
        camera.position.z = -4
        quad = Quad(device: device, textureName: "bright.png")
        
        terrain = Terrain(device: device, textureName: "grass.png")
        terrain.position.y = -1
        terrain.position.x = -50
        terrain.position.z = -100
        camera.rotation.x = -25
        camera.position.z = -10
        add(child: terrain)
        add(child: quad)
    }
    
    override func updateCamera(deltaTime: Float) {
        //X&Y Axis
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Down)){camera.position.y -= 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Up)){camera.position.y += 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Right)){camera.position.x += 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Left)){camera.position.x -= 0.05}
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

