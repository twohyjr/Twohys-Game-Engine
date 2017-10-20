import MetalKit

class Node{
    public var bufferProvider: BufferProvider!
    
    var children: [Node] = []
    
    func add(child: Node){
        children.append(child)
    }
    
    func signalBufferProvider(){
        self.bufferProvider.avaliableResourcesSemaphore.signal()
        for child in children{
            child.bufferProvider.avaliableResourcesSemaphore.signal()
        }
    }
    
    func render(renderCommandEncoder: MTLRenderCommandEncoder){
        bufferProvider.avaliableResourcesSemaphore.wait()
        for child in children{
            child.render(renderCommandEncoder: renderCommandEncoder)
        }
        if let renderable =  self as? Renderable{
            renderable.draw(renderCommandEncoder: renderCommandEncoder)
        }
    }
    
}
