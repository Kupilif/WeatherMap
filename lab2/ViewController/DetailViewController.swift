import Foundation
import UIKit
import MapKit

class DetailViewController: UIViewController {
    private let MAP_SCALE: Double = 25000
    
    private var detailItem: City?
    private var mapAnnotation: CityAnnotation?
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        AppSettingsManager.getInstance().detailViewControllerObserver = self
        
        if detailItem == nil {
            CityCollectionManager.getInstance().setDetailPageObserver(self)
            CityCollectionManager.getInstance().tryLoadData()
            showEmptyPage()
        } else {
            showModelData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getDetailItem() -> City? {
        return detailItem
    }
    
    private func showEmptyPage() {
        let settingsManager = AppSettingsManager.getInstance()
        photoImageView.isHidden = true;
        cityLabel.isHidden = true;
        countryLabel.isHidden = true;
        descriptionLabel.isHidden = true;
        mapView.isHidden = true;
        
        ViewUpdater.setLabelText(label: temperatureLabel, text: settingsManager.localizeString(key: "EMPTY_DETAIL_PAGE_MESSAGE"))
        
        navigationItem.title = settingsManager.localizeString(key: "EMPTY_DETAIL_PAGE_TITLE")
    }
    
    private func showModelData() {
        photoImageView.isHidden = false;
        photoImageView.image = detailItem?.getBigPhotoAsync(self)
        cityLabel.isHidden = false;
        ViewUpdater.setLabelText(label: cityLabel, text: detailItem?.name)
        countryLabel.isHidden = false;
        ViewUpdater.setLabelText(label: countryLabel, text: detailItem?.country)
        descriptionLabel.isHidden = false;
        ViewUpdater.setLabelText(label: descriptionLabel, text: detailItem?.description)
        descriptionLabel.sizeToFit()
        ViewUpdater.setLabelText(label: temperatureLabel, text: TemperatureFormatter.formatDegrees(detailItem?.getTemperatureInCelsius()))
        mapView.isHidden = false;
        navigationItem.title = detailItem?.name
        setMapAnnotation()
    }
    
    private func setMapAnnotation() {
        if mapAnnotation != nil {
            mapView.removeAnnotation(mapAnnotation!)
        }
        
        let coordinate = CLLocationCoordinate2D(latitude: (detailItem?.latitude)!, longitude: (detailItem?.longitude)!)
        let annotation = CityAnnotation()
        annotation.title = TemperatureFormatter.formatDegrees(detailItem?.getTemperatureInCelsius())
        annotation.coordinate = coordinate
        annotation.cityId = (detailItem?.getId())!
        let zoomRegion = MKCoordinateRegionMakeWithDistance(coordinate, MAP_SCALE, MAP_SCALE)
        
        mapView.addAnnotation(annotation)
        mapView.setRegion(zoomRegion, animated: true)
    }
}

extension DetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return CityAnnotationBuilder.getInstance().getAnnotationView(mapView: mapView, annotation: annotation)
    }
}

extension DetailViewController: AsyncImageLoad {
    func loadImage(_ image: UIImage) {
        photoImageView.image = image
    }
}

extension DetailViewController: AsyncWeatherLoad {
    func loadWeatherAfter(sender: City) {
        temperatureLabel.text = TemperatureFormatter.formatDegrees(detailItem?.getTemperatureInCelsius())
        setMapAnnotation()
    }
}

extension DetailViewController: DetailItemKeeper {
    func setDetailItem(_ item: City, autoUpdate: Bool) {
        if detailItem != nil {
            detailItem?.detailPageWeatherObserver = nil
        }
        
        detailItem = item;
        detailItem?.detailPageWeatherObserver = self
        
        if autoUpdate {
            showModelData()
        }
    }
}

extension DetailViewController: SettingsObserver {
    func updateLanguage() {
        if detailItem == nil {
            showEmptyPage()
        }
    }
    
    func updateFont() {
        if detailItem == nil {
            showEmptyPage()
        } else {
            showModelData()
        }
    }
}
