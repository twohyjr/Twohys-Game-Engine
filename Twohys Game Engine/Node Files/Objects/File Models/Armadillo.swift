import MetalKit

class Armadillo: Model{
    
    let ModelName: String = "Dwarf_2_Low"
    
    init(device: MTLDevice, textureName: String) {
        super.init(device: device, modelName: ModelName, textureName: textureName)
        self.initialize()
    }
    
    init(device: MTLDevice) {
        super.init(device: device, modelName: ModelName, textureName: "")
        self.initialize()
    }
    
    func initialize(){
        self.shininess = 0.1
        self.specularIntensity = 0.1
        self.materialColor = float4(0.3, 0.5, 0.4, 1.0)
    }
    
}
