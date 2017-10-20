import MetalKit

class BufferProvider: NSObject {

    internal let inflightBuffersCount: Int
    internal var uniformsBuffers: [MTLBuffer]
    internal var avaliableBufferIndex: Int = 0
    public var avaliableResourcesSemaphore: DispatchSemaphore
    
    init(device:MTLDevice, inflightBuffersCount: Int, sizeOfUniformsBuffer: Int) {
        avaliableResourcesSemaphore = DispatchSemaphore(value: inflightBuffersCount)
        self.inflightBuffersCount = inflightBuffersCount
        uniformsBuffers = [MTLBuffer]()
        
        for _ in 0...inflightBuffersCount-1 {
            let uniformsBuffer = device.makeBuffer(length: sizeOfUniformsBuffer, options: [])
            uniformsBuffers.append(uniformsBuffer!)
        }
    }
    
    public func nextUniformsBuffer<T>(uniforms: inout T) -> MTLBuffer {
        let buffer = uniformsBuffers[avaliableBufferIndex]

        let bufferPointer = buffer.contents()
        
        bufferPointer.copyBytes(from: &uniforms, count: MemoryLayout<T>.size)
        
        avaliableBufferIndex = (avaliableBufferIndex + 1) % 3
        
        return buffer
    }
    
}

