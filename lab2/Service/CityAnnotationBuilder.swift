import Foundation
import MapKit

class CityAnnotationBuilder {
    private static let instance: CityAnnotationBuilder = CityAnnotationBuilder()
    
    static func getInstance() -> CityAnnotationBuilder {
        return instance
    }
    
    private var directionImages = [WindDirection: UIImage]()
    private var reloadImage: UIImage
    
    init() {
        directionImages[.North] = UIImage(named: "n")
        directionImages[.NorthEast] = UIImage(named: "ne")
        directionImages[.East] = UIImage(named: "e")
        directionImages[.SouthEast] = UIImage(named: "se")
        directionImages[.South] = UIImage(named: "s")
        directionImages[.SouthWest] = UIImage(named: "sw")
        directionImages[.West] = UIImage(named: "w")
        directionImages[.NorthWest] = UIImage(named: "nw")
        reloadImage = UIImage(named: "reload")!
    }
    
    func getAnnotationView(mapView: MKMapView, annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        
        if let cityAnnotation = annotation as? CityAnnotation {
            if let city = CityCollectionManager.getInstance().getItemById(id: cityAnnotation.cityId) {
                if let direction = city.getWindDirection() {
                    annotationView?.image = directionImages[direction]
                } else {
                    annotationView?.image = reloadImage
                }
            }
        }
        
        annotationView?.canShowCallout = true
        return annotationView
    }
}

