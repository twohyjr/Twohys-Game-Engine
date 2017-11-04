import MetalKit

class Camera: Node{
    var fov: Float = 45
    var aspectRatio: Float = 1
    var nearZ: Float = 0.1
    var farZ: Float = 10000
    
    var pitch: Float = 0
    var yaw: Float = 0
    
    var distanceFromPlayer: Float = 50.0
    var angleAroundPlayer: Float = 0.0

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
    
    func move(){
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_W)){
            position.z -= 0.02
        }
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_D)){
            position.x += 0.02
        }
        if(InputHandler.isKeyPressed(key: KEY_CODES.Key_A)){
            position.x -= 0.02
        }
    }
    
}
