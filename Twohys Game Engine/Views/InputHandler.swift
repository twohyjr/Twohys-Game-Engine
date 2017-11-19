import MetalKit

enum KEY_CODES: Int {
    case Key_K = 40
    case Key_L = 37
    case Key_Z = 6
    case Key_X = 7
    case Key_W = 13
    case Key_S = 1
    case Key_A = 0
    case Key_D = 2
    case Key_Q = 12
    case Key_E = 14
    case Key_1 = 18
    case Key_2 = 19
    case Key_3 = 20
    case Key_4 = 21
    case Angle_Bracket_Left = 43
    case Angle_Bracket_Right = 47
    case Spacebar = 49

    case Key_Arrow_Up = 126
    case Key_Arrow_Down = 125
    case Key_Arrow_Left = 123
    case Key_Arrow_Right = 124
}

class InputHandler{
    
    private static var KEY_COUNT = 256
    
    private static var keyList = [Bool].init(repeating: false, count: KEY_COUNT)
    
    public static func setKeyPressed(key: UInt16, isOn: Bool){
        keyList[Int(key)] = isOn
    }

    public static func isKeyPressed(key: KEY_CODES)->Bool{
        return keyList[Int(key.rawValue)] == true
    }

}
