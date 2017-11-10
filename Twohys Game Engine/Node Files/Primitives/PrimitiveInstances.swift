import MetalKit

class PrimitiveInstances: Node{
    
    var primitive: Primitive!
    
    var nodes: [Node] = []
    
    var instanceBuffer: MTLBuffer!
    var modelConstantInstances = [ModelConstants]()
    
    var _renderPipelineState: MTLRenderPipelineState!
    
    init(device: MTLDevice, primitive: Primitive, instanceCount: Int){
        super.init()
        self.primitive = primitive
        generate(instanceCount: instanceCount)
        createInstanceBuffer(device: device)
        _renderPipelineState = FlashPipelineStateProvider.getFlashPipelineState(flashPipelineStateType: FlashPipelineStateType.RENDERABLE)
        
    }
    func generate(instanceCount: Int){
        for _ in 0..<instanceCount{
            let node = Node()
            nodes.append(node)
            modelConstantInstances.append(ModelConstants())
        }
    }
    func createInstanceBuffer(device: MTLDevice){
        instanceBuffer = device.makeBuffer(length: MemoryLayout<ModelConstants>.stride  * nodes.count, options: [])
    }
}

extension PrimitiveInstances: Renderable{
    func draw(renderCommandEncoder: MTLRenderCommandEncoder, modelMatrix: matrix_float4x4) {
        guard let instanceBuffer = self.instanceBuffer, nodes.count > 0 else { return }
        renderCommandEncoder.setRenderPipelineState(FlashPipelineStateProvider.getFlashPipelineState(flashPipelineStateType: FlashPipelineStateType.INSTANCES))
        
        var pointer = instanceBuffer.contents().bindMemory(to: ModelConstants.self, capacity: nodes.count)
        for node in nodes{
            pointer.pointee.modelMatrix = matrix_multiply(modelMatrix, node.modelMatrix)
//            pointer.pointee.modelMatrix = modelMatrix
            pointer.pointee.normalMatrix = modelMatrix.upperLeftMatrix()
            pointer.pointee.shininess = node.shininess
            pointer.pointee.specularIntensity = node.specularIntensity
            pointer.pointee.materialColor = node.materialColor
            pointer = pointer.advanced(by: 1)
        }
        renderCommandEncoder.setVertexBuffer(instanceBuffer, offset: 0, index: 2)
        
        renderCommandEncoder.setVertexBuffer(primitive.vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: primitive.vertices.count, instanceCount: nodes.count)
        
        
    }
}

