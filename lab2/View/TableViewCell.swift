import Foundation
import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    private var item: City?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureWith(_ model: City) {
        imageViewPhoto.image = model.getSmallPhotoAsync(self)
        ViewUpdater.setLabelText(label: labelCity, text: model.name)
        ViewUpdater.setLabelText(label: labelTemperature, text: TemperatureFormatter.formatDegrees(model.getTemperatureInCelsius()))
        ViewUpdater.setLabelText(label: labelDescription, text: model.description)
        
        if item != nil {
            item?.tableViewCellWeatherObserver = nil
        }
        
        item = model
        item?.tableViewCellWeatherObserver = self
    }
}

extension TableViewCell: AsyncImageLoad {
    func loadImage(_ image: UIImage) {
        imageViewPhoto.image = image
    }
}

extension TableViewCell: AsyncWeatherLoad {
    func loadWeatherAfter(sender: City) {
        ViewUpdater.setLabelText(label: labelTemperature, text: TemperatureFormatter.formatDegrees(sender.getTemperatureInCelsius()))
    }
}
