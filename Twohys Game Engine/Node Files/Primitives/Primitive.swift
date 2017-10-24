import MetalKit

class Primitive: Node{
    var _renderPipelineState: MTLRenderPipelineState!
    
    var vertices: [Vertex]!
    var vertexBuffer: MTLBuffer!
    
    init(device: MTLDevice){
        super.init()
        buildVertices()
        buildBuffers(device: device)
        _renderPipelineState = FlashPipelineStateProvider.getFlashPipelineState(flashPipelineStateType: FlashPipelineStateType.RENDERABLE)
    }
    
    func buildVertices(){ }
    
    func buildBuffers(device: MTLDevice){
        vertexBuffer = device.makeBuffer(bytes: vertices, length: MemoryLayout<Vertex>.stride * vertices.count, options: [MTLResourceOptions.storageModeManaged])
    }
}

extension Primitive: Renderable{
    func draw(renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setRenderPipelineState(FlashPipelineStateProvider.getFlashPipelineState(flashPipelineStateType: FlashPipelineStateType.RENDERABLE))
        renderCommandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
    }
}
