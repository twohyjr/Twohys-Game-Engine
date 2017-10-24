import MetalKit

class Node{
    
    var children: [Node] = []
    
    func add(child: Node){
        children.append(child)
    }
    
    func render(renderCommandEncoder: MTLRenderCommandEncoder){
        //Render all of the sub nodes for this object
        for child in children{
            child.render(renderCommandEncoder: renderCommandEncoder)
        }
        if let renderable = self as? Renderable{
            renderable.draw(renderCommandEncoder: renderCommandEncoder)
        }
    }
    
}
