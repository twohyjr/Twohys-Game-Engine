import MetalKit

protocol FlashPipelineState {
    var renderPipelineState: MTLRenderPipelineState! { get }
    var _device: MTLDevice! { get }
    var _mtkView: MTKView! { get }
    var _vertexFunctionName: String { get set }
    var _fragmentFunctionName: String { get set }
}

extension FlashPipelineState{
    func buildFlashPipelineState(vertexDescriptor: MTLVertexDescriptor)->MTLRenderPipelineState{
        let library = _device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: _vertexFunctionName)
        let fragmentFunction = library?.makeFunction(name: _fragmentFunctionName)
        
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = _mtkView.colorPixelFormat
        renderPipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        var renderPipelineState: MTLRenderPipelineState? = nil
        do{
            renderPipelineState = try _device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        }catch{
            print("\(error)")
        }
        return renderPipelineState!
    }
}
