import MetalKit

protocol Renderable{
    var _renderPipelineState: MTLRenderPipelineState! { get set }
    func draw(renderCommandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4)
}
