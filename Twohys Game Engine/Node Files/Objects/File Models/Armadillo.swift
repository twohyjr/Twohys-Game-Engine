import MetalKit

class Armadillo: Model{
    
    let ModelName: String = "armadillo"
    
    init(device: MTLDevice, textureName: String) {
        super.init(device: device, modelName: ModelName, textureName: textureName)
        self.initialize()
    }
    
    init(device: MTLDevice) {
        super.init(device: device, modelName: ModelName, textureName: "")
        self.initialize()
    }
    
    func initialize(){
        self.shininess = 60
        self.specularIntensity = 10
        self.materialColor = float4(0.3, 0.5, 0.4, 1.0)
    }
    
}
