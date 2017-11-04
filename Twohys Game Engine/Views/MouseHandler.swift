import MetalKit

enum MOUSE_BUTTON_CODES: Int {
    case LEFT = 0
    case RIGHT = 1
    case CENTER = 2
}

class MouseHandler{
    private static var MOUSE_BUTTON_COUNT = 12
    private static var mouseButtonList = [Bool].init(repeating: false, count: MOUSE_BUTTON_COUNT)
    
    
    private static var overallMousePosition = float2(0)
    
    
    private static var scrollWheelPosition: Float = 0
    private static var lastWheelPosition: Float = 0.0
    
    private static var scrollWheelChange: Float = 0.0
    private static var mousePositionChange: float2 = float2(0)


    public static func setMouseButtonPressed(button: Int, isOn: Bool){
        mouseButtonList[button] = isOn
    }
    
    public static func isMouseButtonPressed(button: MOUSE_BUTTON_CODES)->Bool{
        return mouseButtonList[Int(button.rawValue)] == true
    }
    
    public static func setOverallMousePosition(position: float2){
        self.overallMousePosition = position
    }
    
    ///Sets the delta distance the mouse had moved
    public static func setMousePositionChange(position: float2){
        mousePositionChange -= position
    }
    
    public static func scrollMouse(deltaY: Float){
        scrollWheelPosition += deltaY
        scrollWheelChange += deltaY
    }
    
    public static func getMouseXYPosition()->float2{
        return overallMousePosition
    }
    
    ///Returns the movement of the wheel since last time getDWheel() was called
    public static func getDWheel()->Float{
        let position = scrollWheelChange
        scrollWheelChange = 0
        return position
    }
    
    ///Movement on the y axis since last time getDY() was called.
    public static func getDY()->Float{
        let positionY = mousePositionChange.y
        mousePositionChange.y = 0
        return positionY
    }
    
    ///Movement on the x axis since last time getDX() was called.
    public static func getDX()->Float{
        let positionY = mousePositionChange.x
        mousePositionChange.x = 0
        return positionY
    }
    
    
    
}

