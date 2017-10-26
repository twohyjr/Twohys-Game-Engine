import MetalKit

class PlaygroundScene1: Scene{
    
    var quad: Quad!
    override func buildScene(device: MTLDevice) {
        camera.position.z = -4
        quad = Quad(device: device)
        add(child: quad)
    }
    
    override func updateCamera(deltaTime: Float) {
        
    }
    
    override func updateModels(deltaTime: Float) {
        quad.rotation.x += deltaTime
        quad.rotation.y += deltaTime
    }
}

