import MetalKit

class Scene: Node{
    
    var sceneConstants = SceneConstants()
    var circle: Circle!
    init(device: MTLDevice){
        circle = Circle(device: device, circleVertexCount: 256)
        super.init()
        
        circle.rotation.y = -25
        
        add(child: circle)
    }
    
    func render(renderCommandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        renderCommandEncoder.setVertexBytes(&sceneConstants, length: MemoryLayout<SceneConstants>.stride, index: 1)
        for child in children{
            child.render(renderCommandEncoder: renderCommandEncoder, parentModelMatrix: matrix_identity_float4x4)
        }
    }
    
}
