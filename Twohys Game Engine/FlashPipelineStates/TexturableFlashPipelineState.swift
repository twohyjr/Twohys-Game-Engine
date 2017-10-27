import MetalKit

class TexturableFlashPipelineState: FlashPipelineState{
    var renderPipelineState: MTLRenderPipelineState!
    var _device: MTLDevice!
    var _mtkView: MTKView!
    var _vertexFunctionName: String = "vertexShader"
    var _fragmentFunctionName: String = "texturedFragmentShader"
    
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
        vertexDescriptor.attributes[3].offset = MemoryLayout<float3>.stride + MemoryLayout<float4>.stride + MemoryLayout<float3>.stride
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        
        return vertexDescriptor
    }
    
    init(device: MTLDevice, mtkView: MTKView){
        self._device = device
        self._mtkView = mtkView
        self.renderPipelineState = self.buildFlashPipelineState(vertexDescriptor: vertexDescriptor)
    }
}

