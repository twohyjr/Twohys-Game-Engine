import MetalKit

class MapTexture{
    var texture: MTLTexture?
    var width: Int!
    var height: Int!
    init(device: MTLDevice, imageName: String){
        texture = setTexture(device: device, imageName: imageName)
        
        width = texture?.width
        height = texture?.height
    }
}

extension MapTexture: Texturable{

}
