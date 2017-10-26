import MetalKit

class PlaygroundScene1: Scene{
    
    var cube: Cube!
    override func buildScene(device: MTLDevice) {
        camera.position.z = -10
        cube = Cube(device: device)
        add(child: cube)
    }
    
    override func updateCamera(deltaTime: Float) {
        
    }
    
    override func updateModels(deltaTime: Float) {
        cube.rotation.x += deltaTime
        cube.rotation.y += deltaTime
    }
}

