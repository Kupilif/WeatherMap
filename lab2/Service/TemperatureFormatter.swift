import Foundation

class TemperatureFormatter {
    private static let TEMPERATURE_DEGREES_TEMPLATE: String = "%@ °C"
    
    static func formatDegrees(_ degrees: Int?) -> String {
        if degrees != nil {
            return String(format: TEMPERATURE_DEGREES_TEMPLATE, degrees!.description)
        } else {
            return ""
        }
    }
}
