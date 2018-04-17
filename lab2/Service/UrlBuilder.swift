import Foundation

class UrlBuilder {
    private static let WEATHER_API_KEY: String = "1835776f43559c5fefafaeacb03ea900"
    private static let JSON_FILE_URL_TEMPLATE: String = "https://bsuir-materials.000webhostapp.com/ios/cities.json?sault=%@"
    private static let IMAGE_URL_TEMPLATE: String = "https://bsuir-materials.000webhostapp.com/ios/img/%@.png?sault=%@"
    private static let WEATHER_URL_TEMPLATE: String = "https://api.openweathermap.org/data/2.5/weather?id=%@&units=metric&appid=%@&sault=%@"
    
    static func getJsonFileUrl() -> String {
        return String(format: JSON_FILE_URL_TEMPLATE, getRandomSault())
    }
    
    static func getImageUrl(imageName: String) -> String {
        return String(format: IMAGE_URL_TEMPLATE, imageName, getRandomSault())
    }
    
    static func getWeatherUrl(cityId: Int) -> String {
        return String(format: WEATHER_URL_TEMPLATE, cityId.description, WEATHER_API_KEY, getRandomSault())
    }
    
    private static func getRandomSault() -> String {
        var result = ""
        
        for _ in 1...5 {
            result += arc4random().description
        }
        
        return result
    }
}
