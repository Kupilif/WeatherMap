import Foundation
import UIKit

class ViewUpdater {
    static func setLabelText(label: UILabel, text: String?) {
        label.font = UIFont(name: label.font.fontName, size: AppSettings.fontSize)
        label.textColor = AppSettings.fontColor
        label.text = text
    }
    
    static func setButtonText(button: UIButton, text: String?) {
        button.setTitleColor(AppSettings.fontColor, for: UIControlState.normal)
        button.setTitle(text, for: UIControlState.normal)
        button.titleLabel?.font = UIFont(name: (button.titleLabel?.font.fontName)!, size: AppSettings.fontSize)
    }
}
