import MetalKit

class Scene: Node{
    
    var sceneConstants = SceneConstants()
    
    init(device: MTLDevice){
        super.init()
        
        for _ in 0..<100{
            add(child: Circle(device: device, circleVertexCount: 2048))
        }
    }
    
    func render(renderCommandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        sceneConstants.projectionMatrix.rotate(angle: deltaTime, axis: float3(0,0,1))
        renderCommandEncoder.setVertexBytes(&sceneConstants, length: MemoryLayout<SceneConstants>.stride, index: 1)
        for child in children{
            child.render(renderCommandEncoder: renderCommandEncoder)
        }
    }
    
}
