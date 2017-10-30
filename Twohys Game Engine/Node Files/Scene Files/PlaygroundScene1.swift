import MetalKit

class PlaygroundScene1: Scene{
    
    var object: Cube!
    var terrain: Terrain!
    override func buildScene(device: MTLDevice) {
        camera.position.z = -4
        object = Cube(device: device)
        object.position.y = 0.5
        
        terrain = Terrain(device: device, textureName: "grass.png")
        terrain.position.y = 0
        terrain.position.x = -50
        terrain.position.z = -100
        camera.rotation.x = -25
        camera.position.z = -10
        add(child: terrain)
        add(child: object)
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
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_W)){object.position.z -= 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_S)){object.position.z += 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_D)){object.position.x += 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_A)){object.position.x -= 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Z)){object.position.y += 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_X)){object.position.y -= 0.05}
    }
}

