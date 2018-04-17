import Foundation
import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class City {
    var name: String
    var country: String
    var description: String
    var smallPhotoName: String
    var bigPhotoName: String
    var latitude: Double
    var longitude: Double
    var weatherId: Int
    
    var tableViewCellWeatherObserver: AsyncWeatherLoad?
    var detailPageWeatherObserver: AsyncWeatherLoad?
    var mapPageWeatherObserver: AsyncWeatherLoad?
    
    private var _id: Int
    private var _smallPhoto: UIImage?
    private var _bigPhoto: UIImage?
    private var _temperatureInCelsius: Int?
    private var _windDirection: WindDirection?
    
    private static var _smallNoImagePhoto: UIImage = UIImage(named: "no-image-sm")!
    
    init(_ id: Int, _ name: String, _ country: String, _ description: String, _ smallPhotoName: String, _ bigPhotoName: String, _ latitude: Double, _ longitude: Double, _ weatherId: Int) {
        _id = id
        self.name = name
        self.country = country
        self.description = description
        self.smallPhotoName = smallPhotoName
        self.bigPhotoName = bigPhotoName
        self.latitude = latitude
        self.longitude = longitude
        self.weatherId = weatherId
    }
    
    func getId() -> Int {
        return _id
    }
    
    func getTemperatureInCelsius() -> Int? {
        return _temperatureInCelsius
    }
    
    func getWindDirection() -> WindDirection? {
        return _windDirection
    }
    
    func getSmallPhotoAsync(_ delegate: AsyncImageLoad) -> UIImage {
        if let image = _smallPhoto {
            return image
        } else {
            let url = UrlBuilder.getImageUrl(imageName: smallPhotoName)
            Alamofire.request(url).responseImage { response in
                if let image = response.result.value {
                    self._smallPhoto = image
                    delegate.loadImage(self._smallPhoto!)
                }
            }
            
            return City._smallNoImagePhoto
        }
    }
    
    func getBigPhotoAsync(_ delegate: AsyncImageLoad) -> UIImage {
        if let image = _bigPhoto {
            return image
        } else {
            let url = UrlBuilder.getImageUrl(imageName: bigPhotoName)
            Alamofire.request(url).responseImage { response in
                if let image = response.result.value {
                    self._bigPhoto = image
                    delegate.loadImage(self._bigPhoto!)
                }
            }
            
            return City._smallNoImagePhoto
        }
    }
    
    func loadWeather() {
        let url = UrlBuilder.getWeatherUrl(cityId: weatherId)
        Alamofire.request(url).responseJSON { response in
            let json = JSON(response.result.value)
            
            self._temperatureInCelsius = json["main"]["temp"].intValue
            self._windDirection = WindDirection.getDirection(degree: json["wind"]["deg"].intValue)
            
            if self.tableViewCellWeatherObserver != nil {
                self.tableViewCellWeatherObserver!.loadWeatherAfter(sender: self)
            }
            
            if self.detailPageWeatherObserver != nil {
                self.detailPageWeatherObserver!.loadWeatherAfter(sender: self)
            }
            
            if self.mapPageWeatherObserver != nil {
                self.mapPageWeatherObserver!.loadWeatherAfter(sender: self)
            }
        }
    }
}
