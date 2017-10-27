import MetalKit

class Primitive: Node{
    var _renderPipelineState: MTLRenderPipelineState!
    var modelConstants = ModelConstants()
    
    var vertices: [Vertex] = []
    var vertexBuffer: MTLBuffer!
    
    var indices: [UInt16] = []
    var indexBuffer: MTLBuffer!
    
    var texture: MTLTexture?
    
    init(device: MTLDevice){
        super.init()
        buildVertices()
        buildBuffers(device: device)
        _renderPipelineState = FlashPipelineStateProvider.getFlashPipelineState(flashPipelineStateType: FlashPipelineStateType.RENDERABLE)
    }
    
    init(device: MTLDevice, textureName: String){
        super.init()
        buildVertices()
        buildBuffers(device: device)
        if let texture = setTexture(device: device, imageName: textureName){
            self.texture = texture
            _renderPipelineState = FlashPipelineStateProvider.getFlashPipelineState(flashPipelineStateType: FlashPipelineStateType.TEXTUREABLE)

        }else{
            _renderPipelineState = FlashPipelineStateProvider.getFlashPipelineState(flashPipelineStateType: FlashPipelineStateType.RENDERABLE)            
        }
    }
    
    func buildVertices(){ }
    
    func buildBuffers(device: MTLDevice){
        vertexBuffer = device.makeBuffer(bytes: vertices, length: MemoryLayout<Vertex>.stride * vertices.count, options: [MTLResourceOptions.storageModeManaged])
        if(indices.count > 0){
            indexBuffer = device.makeBuffer(bytes: indices, length: MemoryLayout<UInt16>.size * indices.count, options: [])
        }
    }
}

extension Primitive: Renderable{
    func draw(renderCommandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4) {
        modelConstants.modelViewMatrix = modelViewMatrix
        renderCommandEncoder.setRenderPipelineState(_renderPipelineState)
        
        renderCommandEncoder.setVertexBytes(&modelConstants, length: MemoryLayout<ModelConstants>.stride, index: 2)
        renderCommandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder.setFragmentTexture(texture, index: 0)
        if(indices.count > 0){
            renderCommandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: indices.count, indexType: .uint16, indexBuffer: indexBuffer, indexBufferOffset: 0)
        }else{
            renderCommandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        }
    }
}

extension Primitive: Texturable{ }
