import MetalKit

class BasicScene: Scene{
    
    override init(device: MTLDevice){
        super.init(device: device)
        let triangle = Triangle(device: device)
        
        add(child: triangle)
    }
    
}
