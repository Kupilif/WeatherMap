import Foundation
import UIKit

class TabBarViewController: UITabBarController {
    private var tbItemsTitleKeys: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTabBarItemsTitleKeys()
        CityCollectionManager.getInstance().setErrorHandler(self)
        AppSettingsManager.getInstance().tabBarViewControllerObserver = self
        AppSettingsManager.getInstance().loadLocalization()
        updateLanguage()
    }
    
    private func getTabBarItemsTitleKeys() {
        tbItemsTitleKeys = []
        
        for tbItem in tabBar.items! {
            tbItemsTitleKeys?.append(tbItem.title!)
        }
    }
}

extension TabBarViewController: ErrorHandler {
    func showError(title: String, message: String) {
        var alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var defaultAction = UIAlertAction(title: AppSettingsManager.getInstance().localizeString(key: "BUTTON_OK_CONTENT"), style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension TabBarViewController: SettingsObserver {
    func updateLanguage() {
        if let tbItems = tabBar.items {
            if (tbItems.count == tbItemsTitleKeys?.count) {
                let settingsManager = AppSettingsManager.getInstance()
                
                for i in 0..<tbItems.count {
                    tbItems[i].title = settingsManager.localizeString(key: tbItemsTitleKeys![i])
                }
            }
        }
    }
    
    func updateFont() {
    }
}
