import MetalKit

class PlaygroundScene1: Scene{
    
    var object: Circle!
    override func buildScene(device: MTLDevice) {
        light.brightness = 0.5
        light.color = float3(0.67,1,1)
        light.ambientIntensity = 1
        light.diffuseIntensity = 1.0
        
        camera.position = float3(0,1,0)
        
        let circle = Circle(device: device, circleVertexCount: 4)
        circle.scale = float3(0.6)
        circle.position.x = -1
        circle.specularIntensity = 1
        circle.shininess = 20
        
        
        object = Circle(device: device, circleVertexCount: 256)
        object.position.z = -5
//        object.rotation.y = 3.0
//        object.position.y = -0.5
        object.specularIntensity = 3
        object.shininess = 100
        object.scale = float3(2)
        add(child: object)
        add(child: circle)
    }
    
    override func updateCamera(deltaTime: Float) {
        

    }
    
    override func updateModels(deltaTime: Float) {
        
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_A)){camera.rotation.x += 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_D)){camera.rotation.x -= 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_W)){object.position.z -= 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_S)){object.position.z += 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Z)){object.position.y += 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_X)){object.position.y -= 0.05}
        
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Up)){object.rotation.x -= 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Down)){object.rotation.x += 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Left)){object.rotation.y -= 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Right)){object.rotation.y += 0.05}
    }
}

