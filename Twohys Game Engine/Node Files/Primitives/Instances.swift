import MetalKit

class Instance: Node{

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
        bufferProvider = BufferProvider(device: device, inflightBuffersCount: 3, sizeOfUniformsBuffer: MemoryLayout<ModelConstants>.stride * nodes.count)
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

extension Instance: Renderable{
    func draw(renderCommandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4) {
        renderCommandEncoder.setRenderPipelineState(FlashPipelineStateProvider.getFlashPipelineState(flashPipelineStateType: FlashPipelineStateType.INSTANCES))
        let buffer = bufferProvider.nextUniformsBuffer(uniforms: &nodes)
        var pointer = buffer.contents().bindMemory(to: ModelConstants.self, capacity: nodes.count)
        for node in nodes{
            pointer.pointee.modelViewMatrix = matrix_multiply(modelViewMatrix, node.modelMatrix)
            pointer = pointer.advanced(by: 1)
        }
        renderCommandEncoder.setVertexBuffer(buffer, offset: 0, index: 2)
        
        renderCommandEncoder.setVertexBuffer(primitive.vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: primitive.vertices.count, instanceCount: nodes.count)


    }
}
