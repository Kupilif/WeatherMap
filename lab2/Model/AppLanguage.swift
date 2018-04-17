import Foundation

enum AppLanguage {
    case langEN, langRU
    
    private static let itemName = ["English", "Русский"]
    
    static func getDefault() -> AppLanguage {
        return .langEN
    }
    
    static func getItemsCount() -> Int {
        return itemName.count
    }
    
    static func getItem(index: Int) -> AppLanguage {
        switch index {
        case 0:
            return .langEN
        case 1:
            return .langRU
        default:
            return .langEN
        }
    }
    
    static func getItemName(index: Int) -> String {
        return itemName[index]
    }
}
