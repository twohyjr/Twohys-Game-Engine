import MetalKit

class PlaygroundScene1: Scene{
    
    var object: Terrain!
    override func buildScene(device: MTLDevice) {
        camera.position.z = -20
        camera.position.y = 5
        camera.position.x = 30
        
        light.color = float3(1)
        light.direction = float3(0,0,-1)
        light.ambientIntensity = 0.1
        light.diffuseIntensity = 1.0
        light.brightness = 2.0
        
        //REPRESENTS THE LIGHT POSITION
//        let circle = Circle(device: device, circleVertexCount: 128)
//        circle.scale = float3(0.1)
//        circle.position = light.direction
//        add(child: circle)
        
      object = Terrain(device: device, textureName: "grass.png")
      object.position.y = 0
      object.position.x = -50
      object.position.z = -100
      add(child: object)
        
        camera.rotation.x = -50
//        add(child: object)
    }
    
    override func updateCamera(deltaTime: Float) {
        //X&Y Axis

    }
    
    override func updateModels(deltaTime: Float) {
        
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_A)){object.position.x -= 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_D)){object.position.x += 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_S)){object.position.z += 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_W)){object.position.z -= 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Z)){object.position.y += 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_X)){object.position.y -= 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Up)){object.rotation.x += 0.005}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_Arrow_Down)){object.rotation.x -= 0.005}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Angle_Bracket_Left)){camera.rotation.y += 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Angle_Bracket_Right)){camera.rotation.y -= 0.05}

    }
}

