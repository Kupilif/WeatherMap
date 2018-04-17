import Foundation
import UIKit

class AppSettingsManager {
    private static var instance: AppSettingsManager = AppSettingsManager()
    
    static func getInstance() -> AppSettingsManager {
        return instance
    }
    
    var tabBarViewControllerObserver: SettingsObserver?
    var masterViewControllerObserver: SettingsObserver?
    var detailViewControllerObserver: SettingsObserver?
    var settingsViewControllerObserver: SettingsObserver?
    
    private var localizationRU: NSDictionary?
    private var localizationEN: NSDictionary?
    
    private var newLanguage: AppLanguage?
    private var newFontColor: UIColor?
    private var newFontSize: CGFloat?
    
    private init() {}
    
    func setNewLanguage(_ language: AppLanguage) {
        newLanguage = language
    }
    
    func setNewFontColor(_ color: UIColor) {
        newFontColor = color
    }
    
    func setNewFontSize(_ size: CGFloat) {
        newFontSize = size
    }
    
    func updateSettings() {
        let observers = getSettingsObservers()
        var needFontUpdate = false
        
        if let value = newLanguage {
            AppSettings.language = value
            newLanguage = nil
            
            for observer in observers {
                observer.updateLanguage()
            }
        }
        
        if let value = newFontSize {
            AppSettings.fontSize = value
            newFontSize = nil
            needFontUpdate = true
        }
        
        if let value = newFontColor {
            AppSettings.fontColor = value
            newFontColor = nil
            needFontUpdate = true
        }
        
        if needFontUpdate {
            for observer in observers {
                observer.updateFont()
            }
        }
    }
    
    func loadLocalization() {
        let locRuPath = Bundle.main.url(forResource: "Localizable", withExtension: "strings", subdirectory: nil, localization: "ru")
        let locEnPath = Bundle.main.url(forResource: "Localizable", withExtension: "strings", subdirectory: nil, localization: "en")
        localizationRU = NSDictionary(contentsOf: locRuPath!)!
        localizationEN = NSDictionary(contentsOf: locEnPath!)!
    }
    
    func localizeString(key: String) -> String {
        if let localization = getLocalizationStrings() {
            if let result = localization.object(forKey: key) as? String {
                return result
            } else {
                return key
            }
        } else {
            return key
        }
    }
    
    private func getSettingsObservers() -> [SettingsObserver] {
        var result: [SettingsObserver] = []
        
        if let observer = tabBarViewControllerObserver {
            result.append(observer)
        }
        
        if let observer = masterViewControllerObserver {
            result.append(observer)
        }
        
        if let observer = detailViewControllerObserver {
            result.append(observer)
        }
        
        if let observer = settingsViewControllerObserver {
            result.append(observer)
        }
        
        return result
    }
    
    private func getLocalizationStrings() -> NSDictionary? {
        switch AppSettings.language {
        case .langEN:
            return localizationEN
        case .langRU:
            return localizationRU
        default:
            return localizationEN
        }
    }
}
