import MetalKit

class Primitive{
    
    var renderPipelineState: MTLRenderPipelineDescriptor!
    
    var vertexDescriptor: MTLVertexDescriptor{
        let vertexDescriptor = MTLVertexDescriptor()
        
        //Position
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[0].offset = 0
        
        //Color
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.attributes[1].offset = MemoryLayout<float3>.size
        
        //Normal
        vertexDescriptor.attributes[2].format = .float3
        vertexDescriptor.attributes[2].bufferIndex = 0
        vertexDescriptor.attributes[2].offset = MemoryLayout<float3>.size + MemoryLayout<float4>.size
        
        //Texture Coordinate
        vertexDescriptor.attributes[3].format = .float2
        vertexDescriptor.attributes[3].bufferIndex = 0
        vertexDescriptor.attributes[3].offset = MemoryLayout<float3>.size + MemoryLayout<float4>.size + MemoryLayout<float3>.size
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        
        return vertexDescriptor
    }
    
    var vertexFunctionName: String!
    var fragmentFunctionName: String!
    
    var vertices: [Vertex] = []
    var indices: [UInt16] = []
    
    var vertexBuffer: MTLBuffer!
    var indexBuffer: MTLBuffer!
    
    init(device: MTLDevice){
        self.renderPipelineState = buildRenderPipelineState(device: device)
        buildVertices()
        buildIndices()
        buildBuffers()
    }
    
    func buildVertices(){ }
    
    func buildIndices(){ }
    
    func buildBuffers(){
        vertexBuffer = device.makeBuffer(bytes: vertices, length: MemoryLayout<Vertex>.stride * vertices.count, options: [])
        vertexBuffer.label = "Vertex Buffer"
        
        indexBuffer = device.makeBuffer(bytes: indices, length: MemoryLayout<UInt16>.size * indices.count, options: [])
        indexBuffer.label = "Index Buffer"
    }
    
}

extension Primitive: Renderable{
    
}
