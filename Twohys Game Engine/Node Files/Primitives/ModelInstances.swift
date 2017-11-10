import MetalKit

class ModelInstances: Node{
    
    var model: Model!
    
    var nodes: [Node] = []
    
    var instanceBuffer: MTLBuffer!
    var modelConstantInstances = [ModelConstants]()
    
    var _renderPipelineState: MTLRenderPipelineState!
    
    init(device: MTLDevice, model: Model, instanceCount: Int){
        super.init()
        self.model = model
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

extension ModelInstances: Renderable{
    func draw(renderCommandEncoder: MTLRenderCommandEncoder, modelMatrix: matrix_float4x4) {
        guard let instanceBuffer = self.instanceBuffer, nodes.count > 0 else { return }
        renderCommandEncoder.setRenderPipelineState(FlashPipelineStateProvider.getFlashPipelineState(flashPipelineStateType: FlashPipelineStateType.INSTANCES))
        
        var pointer = instanceBuffer.contents().bindMemory(to: ModelConstants.self, capacity: nodes.count)
        
        for node in nodes{
            pointer.pointee.modelMatrix = matrix_multiply(modelMatrix, node.modelMatrix)
            pointer.pointee.materialColor = node.materialColor
            pointer = pointer.advanced(by: 1)
        }
        renderCommandEncoder.setVertexBuffer(instanceBuffer, offset: 0, index: 1)
        
        guard let meshes = model.meshes as? [MTKMesh], meshes.count > 0 else { return }
        
        for mesh in meshes{
            let vertexBuffer = mesh.vertexBuffers[0]
            renderCommandEncoder.setVertexBuffer(vertexBuffer.buffer, offset: vertexBuffer.offset, index: 0)
            
            for submesh in mesh.submeshes{
                renderCommandEncoder.drawIndexedPrimitives(type: submesh.primitiveType,
                                                           indexCount: submesh.indexCount,
                                                           indexType: submesh.indexType,
                                                           indexBuffer: submesh.indexBuffer.buffer,
                                                           indexBufferOffset: submesh.indexBuffer.offset,
                                                           instanceCount: nodes.count)
            }
        }
        
    }
}

