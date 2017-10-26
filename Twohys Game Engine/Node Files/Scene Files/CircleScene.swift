import MetalKit

class CircleScene: Scene{
    
    var instance: Instance!
    override func buildScene(device: MTLDevice) {
        let circle = Circle(device: device, circleVertexCount: 300)
        instance = Instance(device: device, primitive: circle, instanceCount: 10000)
        
        camera.position.z = 20
        
        var index: Int = 1
        var currentXPos:Float = -100
        var currentYPos: Float = 100
        for n in instance.nodes{
            n.position.z = -30
            n.position.x = currentXPos
            n.position.y = currentYPos
            
            if(index % 100 == 0){
                currentYPos -= 2
                currentXPos = -100
            }else{
                currentXPos += 2
            }
            index += 1
        }
        add(child: instance)
    }
    
    override func updateCamera(deltaTime: Float) {
        if(camera.position.z >= -230){
            camera.position.z -= deltaTime * 5
        }else{
            camera.rotation.z += deltaTime / 2.0
        }
    }
    
    override func updateModels(deltaTime: Float) {
        for n in instance.nodes{
            n.rotation.z += deltaTime
        }
    }
}

