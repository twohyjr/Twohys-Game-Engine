import MetalKit

class Scene: Node{
    
    init(device: MTLDevice){
        super.init()
        
        for _ in 0..<100{
            add(child: Circle(device: device, circleVertexCount: 128))
        }
        
        
    }
    
    override func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        for child in children{
            child.render(renderCommandEncoder: renderCommandEncoder)
        }
    }
    
}
