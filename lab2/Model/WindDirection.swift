import Foundation

enum WindDirection {
    case North, NorthEast, East, SouthEast, South, SouthWest, West, NorthWest
    
    static func getDirection(degree: Int) -> WindDirection {
        switch degree {
        case 339...360:
            return .North
        case 0...23:
            return .North
        case 24...68:
            return .NorthEast
        case 69...113:
            return .East
        case 114...158:
            return .SouthEast
        case 159...203:
            return .South
        case 204...248:
            return .SouthWest
        case 249...293:
            return .West
        default:
            return .NorthWest
        }
    }
}
