import MetalKit

class Camera: Node{
    var fov: Float = 45
    var aspectRatio: Float = 1
    var nearZ: Float = 0.1
    var farZ: Float = 1000
    
    var distanceFromPlayer: Float = -9.0
    var angleAroundPlayer: Float = 0
    
    var pitch: Float = 0.5
    var yaw: Float = 0
    
    var player: Player!

    var projectionMatrix:matrix_float4x4{
        return matrix_float4x4(perspectiveDegreesFov: fov, aspectRatio: aspectRatio, nearZ: nearZ, farZ: farZ)
    }
    
    var viewMatrix:matrix_float4x4{
        var viewMatrix = matrix_identity_float4x4
        viewMatrix.rotate(angle: self.pitch, axis: float3(1,0,0))
        viewMatrix.rotate(angle: self.yaw, axis: float3(0,1,0))
        viewMatrix.translate(direction: -self.position)
        return viewMatrix
    }
    
    init(player: Player){
        super.init()
        self.player = player
    }
    
    func update(){
        calculateZoom()
        calculatePitch()
        calculateAngleAroundPlayer()
        
        let horizontalDistance = calculateHorizontalDistance()
        let verticalDistance = calculateVerticalDistance()
        calculateCameraPosition(horizontalDistance: horizontalDistance, verticalDistance: verticalDistance)
        yaw = -(player.rotation.y + angleAroundPlayer)
        
    }
    
    private func calculateCameraPosition(horizontalDistance: Float, verticalDistance: Float){
        let theta = player.rotation.y + angleAroundPlayer
        let offsetX = horizontalDistance * sin(theta)
        let offsetZ = horizontalDistance * cos(theta)
        position.x = player.position.x - offsetX
        position.z = player.position.z - offsetZ
        position.y = player.position.y - verticalDistance
    }
    
    private func calculateHorizontalDistance()->Float{
        return distanceFromPlayer * cos(pitch)
    }
    
    private func calculateVerticalDistance()->Float{
        print(distanceFromPlayer)
        return distanceFromPlayer * sin(pitch)
    }
    
    private func calculateZoom(){
        let zoomLevel = MouseHandler.getDWheel() * 0.1
        distanceFromPlayer -= zoomLevel
    }
    
    private func calculatePitch(){
        if(MouseHandler.isMouseButtonPressed(button: MOUSE_BUTTON_CODES.LEFT)){
            let pitchChange = MouseHandler.getDY() * 0.1
            pitch -= pitchChange
        }
    }
    
    private func calculateAngleAroundPlayer(){
        if(MouseHandler.isMouseButtonPressed(button: MOUSE_BUTTON_CODES.RIGHT)){
            let angleChange = MouseHandler.getDX() * 0.3
            angleAroundPlayer -= angleChange
        }
    }
}
