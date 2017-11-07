import MetalKit

class Camera: Node{
    var fov: Float = 45
    var aspectRatio: Float = 1
    var nearZ: Float = 0.1
    var farZ: Float = 1000
    
    var pitch: Float = 0
    var yaw: Float = 0

    var projectionMatrix:matrix_float4x4{
        return matrix_float4x4(perspectiveDegreesFov: fov, aspectRatio: aspectRatio, nearZ: nearZ, farZ: farZ)
    }
    
    var viewMatrix:matrix_float4x4{
        var viewMatrix = matrix_identity_float4x4
        viewMatrix.rotate(angle: self.pitch, axis: float3(1,0,0))
        viewMatrix.rotate(angle: self.yaw, axis: float3(0,1,0))
        let negativeCameraPos = -self.position
        viewMatrix.translate(direction: negativeCameraPos)
        return viewMatrix
    }
    
    func update(){ }
}
