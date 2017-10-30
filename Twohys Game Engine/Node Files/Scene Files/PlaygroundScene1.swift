import MetalKit

class PlaygroundScene1: Scene{
    
    var object: Cube!
    override func buildScene(device: MTLDevice) {
        camera.position.z = -3
        object = Cube(device: device)
        object.scale = float3(0.5)
        
        light.color = float3(1,0,1)
        light.direction = float3(0,0,-1)
        light.ambientIntensity = 0.1
        light.diffuseIntensity = 0.5
        
        //REPRESENTS THE LIGHT POSITION
//        let circle = Circle(device: device, circleVertexCount: 128)
//        circle.scale = float3(0.1)
//        circle.position = light.direction
//        add(child: circle)
        
//      let terrain: Terrain = Terrain(device: device, textureName: "grass.png")
//      terrain.position.y = 0
//      terrain.position.x = -50
//      terrain.position.z = -100
//      add(child: terrain)
        
        camera.rotation.x = -50
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
        
        if(InputHandler.isKeyPressed(key: KEY_CODES.Angle_Bracket_Left)){object.rotation.y -= 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Angle_Bracket_Right)){object.rotation.y += 0.05}
        
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_K)){object.rotation.x -= 0.05}
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_L)){object.rotation.x += 0.05}
    }
}

