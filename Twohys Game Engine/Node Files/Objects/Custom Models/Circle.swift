import MetalKit

class Circle: Primitive{
    
    private let _circleVertexCount: Int!
    public var radius: Float = 1.0
    
    init(device:MTLDevice, circleVertexCount: Int, radius: Float = 1){
        self._circleVertexCount = circleVertexCount
        self.radius = radius
        super.init(device: device)
    }
    
    override func buildVertices() {
        vertices = []
        let trianglesPerSection: Int = self._circleVertexCount
        var lastPos: float2 = float2(0)
        
        for i in (0 ... trianglesPerSection).reversed() {
            let red = Float(CGFloat(Float(arc4random()) / Float(UINT32_MAX)))
            let green = Float(CGFloat(Float(arc4random()) / Float(UINT32_MAX)))
            let blue = Float(CGFloat(Float(arc4random()) / Float(UINT32_MAX)))
            
            let val: Float = i == 0 ? 0 :  Float((360.0 / Double(trianglesPerSection)) * Double(i))
            var pos = float2(cos(radians(fromDegrees:  val)), sin(radians(fromDegrees:  val))) * radius
            
            vertices.append(Vertex(position: float3(0, 0, 0), color: float4(red, green, blue, 1), normal: float3(0,0,1), textureCoordinate: float2(0,1)))
            vertices.append(Vertex(position: float3(pos.x, pos.y, 0), color: float4(red, green, blue, 1), normal: float3(0,0,1), textureCoordinate: float2(0,1)))
            vertices.append(Vertex(position: float3(lastPos.x, lastPos.y, 0), color: float4(red, green, blue, 1), normal: float3(0,0,1), textureCoordinate: float2(0,1)))
            lastPos = pos
        }
        
    }
    
}
