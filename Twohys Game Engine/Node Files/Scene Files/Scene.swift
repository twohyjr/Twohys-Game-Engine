import MetalKit

class Scene: Node{
    
    var sceneConstants = SceneConstants()
    var camera = Camera()
    
    var circle: Circle!
    init(device: MTLDevice){
        circle = Circle(device: device, circleVertexCount: 256)
        super.init()
    
        circle.position.z = -5
        add(child: circle)
    }
    
    func render(renderCommandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        circle.rotation.y += deltaTime
        circle.rotation.z += deltaTime
        circle.rotation.x += deltaTime
        sceneConstants.projectionMatrix = camera.projectionMatrix
        renderCommandEncoder.setVertexBytes(&sceneConstants, length: MemoryLayout<SceneConstants>.stride, index: 1)
        for child in children{
            child.render(renderCommandEncoder: renderCommandEncoder, parentModelMatrix: camera.viewMatrix)
        }
    }
    
}
