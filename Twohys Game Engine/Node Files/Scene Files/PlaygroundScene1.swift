import MetalKit

class PlaygroundScene1: Scene{
    
    var object: Armadillo!
    override func buildScene(device: MTLDevice) {
        light.brightness = 0.5
        light.color = float3(1)
        light.ambientIntensity = 1
        light.diffuseIntensity = 2.0
        
        
        object = Armadillo(device: device)
        object.position.z = -5
        object.rotation.y = 3.0
        object.position.y = -0.5
        add(child: object)
    }
    
    override func updateCamera(deltaTime: Float) {
        

    }
    
    override func updateModels(deltaTime: Float) {
        
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_A)){object.position.x -= 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_W)){object.position.z -= 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_S)){object.position.z += 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_D)){object.position.x += 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Z)){object.position.y += 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_X)){object.position.y -= 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Up)){object.rotation.x -= 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Down)){object.rotation.x += 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Left)){object.rotation.y -= 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Right)){object.rotation.y += 0.05}
    }
}

