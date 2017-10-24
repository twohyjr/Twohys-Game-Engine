import MetalKit

public enum FlashPipelineStateType {
    case RENDERABLE
}

class RenderPipelineStateProvider{
    
    private static var _pipelineStates: [FlashPipelineStateType:FlashPipelineState] = [:]
    private static var _device: MTLDevice!
    private static var _mtkView: MTKView!
    
    public static func setDeviceAndView(device: MTLDevice, mtkView: MTKView){
        self._device = device
        self._mtkView = mtkView
    }
    
    public static func getFlashPipelineState(flashPipelineStateType: FlashPipelineStateType)->MTLRenderPipelineState{
        if(_pipelineStates[flashPipelineStateType] == nil){
            switch flashPipelineStateType {
                case FlashPipelineStateType.RENDERABLE:
                    _pipelineStates.updateValue(RenderableFlashPipelineState(device: _device, mtkView: _mtkView), forKey: flashPipelineStateType)
            }
        }
        return (_pipelineStates[flashPipelineStateType]!.renderPipelineState)
    }
    
}
