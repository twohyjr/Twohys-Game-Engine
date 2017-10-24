import MetalKit

class Scene: Node{
    
    init(device: MTLDevice){
        super.init()
        
        add(child: Circle(device: device, circleVertexCount: 256))
        
    }
    
    override func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        for child in children{
            child.render(renderCommandEncoder: renderCommandEncoder)
        }
    }
    
}
