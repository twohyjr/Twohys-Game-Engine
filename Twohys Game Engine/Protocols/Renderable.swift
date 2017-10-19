import MetalKit

protocol Renderable{
    
    var renderPipelineState: MTLRenderPipelineState! { get }
    var vertexDescriptor: MTLVertexDescriptor { get }
    
    var vertexFunctionName: String { get set }
    var fragmentFunctionName: String { get set }
    
    func draw(renderCommandEncoder: MTLRenderCommandEncoder)
}

extension Renderable{
    func buildRenderPipelineState(device: MTLDevice)->MTLRenderPipelineState{
        let library = device.makeDefaultLibrary()
        let vertedFunction = library?.makeFunction(name: vertexFunctionName)
        let fragmentFunction = library?.makeFunction(name: fragmentFunctionName)
        
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.vertexFunction = vertedFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        var renderPipelineState: MTLRenderPipelineState!
        do{
            renderPipelineState = try device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        }catch let error as NSError{
            print("Error creating renderPipelineState: \(error)")
        }
        return renderPipelineState
    }
}
