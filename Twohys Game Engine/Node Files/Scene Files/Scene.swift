import MetalKit

class Scene: Node{
    
    var sceneConstants = SceneConstants()
    var camera = Camera()
    let instance: Instance!
    init(device: MTLDevice){
        let circle = Circle(device: device, circleVertexCount: 300)
        instance = Instance(device: device, primitive: circle, instanceCount: 10000)
        super.init()
        camera.position.z = 20
        
//        for _ in 0...100{
//            let circle = Circle(device: device, circleVertexCount: 5000)
//            circle.position.z = -5
//            add(child: circle)
//        }
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
    
    func render(renderCommandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        for n in instance.nodes{
            n.rotation.z += deltaTime
        }
        if(camera.position.z >= -230){
            camera.position.z -= deltaTime * 5
        }else{
            camera.rotation.z += deltaTime / 2.0
        }
        
        
        sceneConstants.projectionMatrix = camera.projectionMatrix
        renderCommandEncoder.setVertexBytes(&sceneConstants, length: MemoryLayout<SceneConstants>.stride, index: 1)
        for child in children{
            child.render(renderCommandEncoder: renderCommandEncoder, parentModelMatrix: camera.viewMatrix)
        }
    }
    
}
