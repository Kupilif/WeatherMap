import Foundation
import UIKit
import MapKit

class MapTabViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    private let MAP_SCALE: Double = 25000
    private let LATITUDE_MIN: Double = -90
    private let LATITUDE_MAX: Double = 90
    private let LONGITUDE_MIN: Double = -180
    private let LONGITUDE_MAX: Double = 180
    private let PRESSURE_DURATION: Double = 2.0
    
    private var cityAnnotations: [CityAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(zoomToNearestCity(sender:)))
        lpgr.minimumPressDuration = PRESSURE_DURATION
        mapView.addGestureRecognizer(lpgr)
        mapView.delegate = self
        CityCollectionManager.getInstance().setMapPageObserver(self)
        CityCollectionManager.getInstance().tryLoadData()
        showCitiesOnMap()
    }
    
    @objc private func zoomToNearestCity(sender: UILongPressGestureRecognizer) {
        let citiesCount = cityAnnotations.count
        
        if (citiesCount > 0 && sender.state == .began) {
            let location = sender.location(in: mapView)
            let coordinates = mapView.convert(location, toCoordinateFrom: mapView)
            let pressedLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
            
            var nearestAnnotation = cityAnnotations[0]
            var minDistance = pressedLocation.distance(from: CLLocation(latitude: nearestAnnotation.coordinate.latitude, longitude: nearestAnnotation.coordinate.longitude))
            
            for i in 1..<citiesCount {
                let currentAnnotation = cityAnnotations[i]
                let currentDistance = pressedLocation.distance(from: CLLocation(latitude: currentAnnotation.coordinate.latitude, longitude: currentAnnotation.coordinate.longitude))
                
                if (currentDistance < minDistance) {
                    minDistance = currentDistance
                    nearestAnnotation = currentAnnotation
                }
            }
            
            let zoomRegion = MKCoordinateRegionMakeWithDistance(nearestAnnotation.coordinate, MAP_SCALE, MAP_SCALE)
            mapView.setRegion(zoomRegion, animated: true)
        }
    }
    
    private func showCitiesOnMap() {
        let cityCollectionManager = CityCollectionManager.getInstance()
        let citiesCount = cityCollectionManager.getItemsCount()
        
        if (citiesCount > 0) {
            mapView.removeAnnotations(cityAnnotations)
            cityAnnotations.removeAll()
            
            var minLatitude = LATITUDE_MAX
            var maxLatitude = LATITUDE_MIN
            var minLongitude = LONGITUDE_MAX
            var maxLongitude = LONGITUDE_MIN
            
            for i in 0..<citiesCount {
                let currentCity = cityCollectionManager.getItem(i)
                let annotation = createAnnotationForCity(currentCity)
                
                cityAnnotations.append(annotation)
                currentCity.mapPageWeatherObserver = self
                
                minLatitude = Double.minimum(minLatitude, currentCity.latitude)
                maxLatitude = Double.maximum(maxLatitude, currentCity.latitude)
                minLongitude = Double.minimum(minLongitude, currentCity.longitude)
                maxLongitude = Double.maximum(maxLongitude, currentCity.longitude)
            }
            
            let point1 = CLLocation(latitude: maxLatitude, longitude: maxLongitude)
            let point2 = CLLocation(latitude: minLatitude, longitude: maxLongitude)
            let point3 = CLLocation(latitude: maxLatitude, longitude: maxLongitude)
            let point4 = CLLocation(latitude: maxLatitude, longitude: minLongitude)
            
            let latitudeDelta = point1.distance(from: point2)
            let longitudeDelta = point3.distance(from: point4)
            
            let zoomRegionCenter = CLLocationCoordinate2D(latitude: (maxLatitude + minLatitude) / 2, longitude: (maxLongitude +	 minLongitude) / 2)
            let zoomRegion = MKCoordinateRegionMakeWithDistance(zoomRegionCenter, latitudeDelta, longitudeDelta)
            
            mapView.addAnnotations(cityAnnotations)
            mapView.setRegion(zoomRegion, animated: true)
        }
    }
    
    private func createAnnotationForCity(_ city: City) ->CityAnnotation {
        let annotation = CityAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude)
        
        annotation.title = TemperatureFormatter.formatDegrees(city.getTemperatureInCelsius())
        annotation.coordinate = coordinate
        annotation.cityId = city.getId()
        
        return annotation
    }
}

extension MapTabViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return CityAnnotationBuilder.getInstance().getAnnotationView(mapView: mapView, annotation: annotation)
    }
}

extension MapTabViewController: CollectionItemsKeeper {
    func collectionUpdateAfter() {
        showCitiesOnMap()
    }
}

extension MapTabViewController: AsyncWeatherLoad {
    func loadWeatherAfter(sender: City) {
        var annotation = cityAnnotations[sender.getId()]
        
        mapView.removeAnnotation(annotation)
        annotation = createAnnotationForCity(sender)
        cityAnnotations[sender.getId()] = annotation
        mapView.addAnnotation(annotation)
    }
}
