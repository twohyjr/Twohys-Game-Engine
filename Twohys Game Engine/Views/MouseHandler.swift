import MetalKit

enum MOUSE_BUTTON_CODES: Int {
    case LEFT = 0
    case RIGHT = 1
    case CENTER = 2
}

class MouseHandler{
    private static var MOUSE_BUTTON_COUNT = 12
    private static var mouseButtonList = [Bool].init(repeating: false, count: MOUSE_BUTTON_COUNT)
    
    private static var mousePosition = float2(0)
    
    private static var scrollWheelPosition: Float = 0
    private static var lastWheelPosition: Float = 0.0


    public static func setMouseButtonPressed(button: Int, isOn: Bool){
        mouseButtonList[button] = isOn
    }
    
    public static func isMouseButtonPressed(button: MOUSE_BUTTON_CODES)->Bool{
        return mouseButtonList[Int(button.rawValue)] == true
    }
    
    public static func setMousePosition(position: float2){
        self.mousePosition = position
    }
    public static func getMouseXYPosition()->float2{
        return mousePosition
    }
    
    public static func getMouseScrollPosition()->Float{
        let position = scrollWheelPosition
        scrollWheelPosition = 0
        return position
    }
    
    public static func scrollMouse(deltaX: Float, deltaY: Float){
        scrollWheelPosition += deltaY
    }
    
    
}

