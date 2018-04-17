import Foundation
import Alamofire
import SwiftyJSON

class CityCollectionManager {
    private static var instance: CityCollectionManager = CityCollectionManager()
    
    static func getInstance() -> CityCollectionManager {
        return instance
    }
    
    private var masterPage: CollectionItemsKeeper?
    private var detailPage: DetailItemKeeper?
    private var mapPage: CollectionItemsKeeper?
    private var errorHandler: ErrorHandler?
    
    private var cities: [City] = []
    private var isDataLoaded: Bool = false
    private var isRequestPerforming = false
    
    private init() { }
    
    func getItemsCount() -> Int {
        return cities.count
    }
    
    func getItem(_ index: Int) -> City {
        return cities[index]
    }
    
    func getItemById(id: Int) -> City? {
        return cities.first(where: {$0.getId() == id})
    }
    
    func setMasterPageObserver(_ delegate: CollectionItemsKeeper) {
        masterPage = delegate
    }
    
    func setDetailPageObserver(_ delegate: DetailItemKeeper) {
        detailPage = delegate
    }
    
    func setMapPageObserver(_ delegate: CollectionItemsKeeper) {
        mapPage = delegate
    }
    
    func setErrorHandler(_ delegate: ErrorHandler) {
        errorHandler = delegate
    }
    
    func tryLoadData() {
        if (canLoadData() && !isDataLoaded && !isRequestPerforming) {
            startDataLoading()
        }
    }
    
    func loadWeather() {
        for city in cities {
            city.loadWeather()
        }
    }
    
    private func canLoadData() -> Bool {
        if mapPage != nil {
            return true
        }
        
        if masterPage == nil {
            return false
        }
        
        if detailPage == nil {
            return false
        }
        
        return true
    }
    
    private func startDataLoading() {
        let url = UrlBuilder.getJsonFileUrl()
        isRequestPerforming = true
        
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(response.result.value)
                var newCity: City
                var currentCityId = 0
                
                self.cities.removeAll()
                for (_, subJson):(String, JSON) in json {
                    newCity = City(
                        currentCityId,
                        subJson["name"].stringValue,
                        subJson["country"].stringValue,
                        subJson["description"].stringValue,
                        subJson["smallPhoto"].stringValue,
                        subJson["bigPhoto"].stringValue,
                        subJson["latitude"].doubleValue,
                        subJson["longitude"].doubleValue,
                        subJson["weatherid"].intValue
                    )
                    
                    currentCityId += 1
                    self.cities.append(newCity)
                }
                
                let itemsCount = self.getItemsCount()
                
                if (itemsCount > 0) {
                    self.isDataLoaded = true
                }
                
                if (itemsCount > 0 && self.detailPage != nil) {
                    self.detailPage?.setDetailItem(self.getItem(0), autoUpdate: true)
                }
                
                if (itemsCount > 0 && self.masterPage != nil) {
                    self.masterPage?.collectionUpdateAfter()
                }
                
                if (itemsCount > 0 && self.mapPage != nil) {
                    self.mapPage?.collectionUpdateAfter()
                }
            case .failure(let error):
                if self.errorHandler != nil {
                    let settingsManager = AppSettingsManager.getInstance()
                    self.errorHandler?.showError(title: settingsManager.localizeString(key: "NETWORK_ERROR_TITLE"), message: settingsManager.localizeString(key: "NETWORK_ERROR_MESSAGE"))
                }
            }
            self.isRequestPerforming = false
        }
    }
}
