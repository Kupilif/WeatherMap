import Foundation
import UIKit

class SettingsTabViewController: UIViewController {
    @IBOutlet weak var updateSettingsButton: UIButton!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var languagePickerView: UIPickerView!
    @IBOutlet weak var fontSizeLabel: UILabel!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var fontColorLabel: UILabel!
    
    @IBAction func updateSettingsButtonTouch(_ sender: Any) {
        AppSettingsManager.getInstance().updateSettings()
    }
    
    @IBAction func fontSizeSliderValueChanged(_ sender: UISlider) {
        let value = CGFloat(Int(sender.value))
        fontSizeLabel.font = UIFont(name: fontSizeLabel.font.fontName, size: value)
        AppSettingsManager.getInstance().setNewFontSize(value)
    }
    
    @IBAction func redColorSliderValueChanged(_ sender: UISlider) {
        setNewColor()
    }
    
    @IBAction func greenColorSliderValueChanged(_ sender: UISlider) {
        setNewColor()
    }
    
    @IBAction func blueColorSliderValueChanged(_ sender: UISlider) {
        setNewColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppSettingsManager.getInstance().settingsViewControllerObserver = self
        updateLanguage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setNewColor() {
        let red = CGFloat(redSlider.value)
        let green = CGFloat(greenSlider.value)
        let blue = CGFloat(blueSlider.value)
        let newColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
        
        AppSettingsManager.getInstance().setNewFontColor(newColor)
        fontColorLabel.textColor = newColor
    }
    
    private func updateControlsAppearance() {
        let settingsManager = AppSettingsManager.getInstance()
        
        ViewUpdater.setLabelText(label: languageLabel, text: settingsManager.localizeString(key: "LABEL_APP_LANGUAGE_TITLE"))
        ViewUpdater.setLabelText(label: fontSizeLabel, text: settingsManager.localizeString(key: "LABEL_FONT_SIZE_TITLE"))
        ViewUpdater.setLabelText(label: fontColorLabel, text: settingsManager.localizeString(key: "LABEL_FONT_COLOR_TITLE"))
        ViewUpdater.setButtonText(button: updateSettingsButton, text: settingsManager.localizeString(key: "BUTTON_UPDATE_SETTINGS_CONTENT"))
    }
}

extension SettingsTabViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return AppLanguage.getItemsCount()
    }
}

extension SettingsTabViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return AppLanguage.getItemName(index: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        AppSettingsManager.getInstance().setNewLanguage(AppLanguage.getItem(index: row))
    }
}

extension SettingsTabViewController: SettingsObserver {
    func updateLanguage() {
        updateControlsAppearance()
    }
    
    func updateFont() {
        updateControlsAppearance()
    }
}
