import UIKit
import GoogleMaps
import CoreLocation

class UserHomeViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var homeMapView: UIView!
    var advertiseDetails: [AdvertiseDetail] = []
    
    let locationManager = CLLocationManager()
    let googleMapView = GMSMapView()
    var selectedMarker: GMSMarker?
    var customInfoWindow: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        googleMapView.delegate = self
        setupMap()
        getCurrentLocation()
        Task { @MainActor in
            advertiseDetails.removeAll(keepingCapacity:false)
            await fetchCompaniesFromDatabase()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupMap()

    }
    
    func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 41.015137, longitude: 28.979530, zoom: 8.0)
        googleMapView.camera = camera
        googleMapView.frame = self.homeMapView.bounds
        googleMapView.isMyLocationEnabled = true
        self.homeMapView.addSubview(googleMapView)
    }
    
    func getCurrentLocation() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 10.0)
            googleMapView.animate(to: camera)
        }
    }
    
    func addCompanyMarker(advertiseDetail: AdvertiseDetail, withOffset offset: (latitude: Double, longitude: Double)) {
        guard let latitude = advertiseDetail.companyDetail?.company?.locationLat, let longitude = advertiseDetail.companyDetail?.company?.locationLong else { return }
        
        let position = CLLocationCoordinate2D(latitude: latitude + offset.latitude, longitude: longitude + offset.longitude)
        let marker = GMSMarker(position: position)
        marker.title = advertiseDetail.companyDetail?.company?.name
        marker.snippet = advertiseDetail.advertise?.title
        marker.userData = advertiseDetail
        marker.map = googleMapView
    }
    
    func fetchCompaniesFromDatabase() async {
        do {
            advertiseDetails = try await AdvertiseService().GetAllAdvertiseDetail()
            advertiseDetails = advertiseDetails.filter({ $0.jobDetail?.sector?.sectorID == GlobalVeriables.currentUser?.jobDetail?.sector?.sectorID})
            await MainActor.run {
                googleMapView.clear()
                displayCompaniesOnMap()
            }
        } catch {
            print("Error fetching companies: \(error)")
        }
    }
    
    func displayCompaniesOnMap() {
        var coordinateCount = [LocationCoordinate2DWrapper: Int]()
        
        for advertiseDetail in advertiseDetails {
            guard let latitude = advertiseDetail.companyDetail?.company?.locationLat, let longitude = advertiseDetail.companyDetail?.company?.locationLong else { continue }
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let wrappedCoordinate = LocationCoordinate2DWrapper(coordinate: coordinate)
            
            if let count = coordinateCount[wrappedCoordinate] {
                coordinateCount[wrappedCoordinate] = count + 1
            } else {
                coordinateCount[wrappedCoordinate] = 1
            }
            
            let offsetMultiplier = Double(coordinateCount[wrappedCoordinate]!)
            let offset = (latitude: (offsetMultiplier * 0.0011), longitude: (offsetMultiplier * 0.0011))
            addCompanyMarker(advertiseDetail: advertiseDetail, withOffset: offset)
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        selectedMarker = marker
        
        if let customInfoWindow = customInfoWindow {
            customInfoWindow.removeFromSuperview()
        }
        
        customInfoWindow = createCustomInfoWindow(for: marker)
        if let customInfoWindow = customInfoWindow {
            self.view.addSubview(customInfoWindow)
            customInfoWindow.center = self.view.center
        }
        
        return true // Return true to indicate we've handled the tap
    }
    
    func createCustomInfoWindow(for marker: GMSMarker) -> UIView {
        let infoWindow = UIView()
        infoWindow.frame = CGRect(x: 0, y: 0, width: 200, height: 150)
        infoWindow.backgroundColor = UIColor.white
        infoWindow.layer.cornerRadius = 8
        infoWindow.layer.masksToBounds = true
        
        // Title label
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 8, y: 8, width: infoWindow.frame.width - 16, height: 20)
        titleLabel.text = marker.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        infoWindow.addSubview(titleLabel)
        
        // Snippet label
        let snippetLabel = UILabel()
        snippetLabel.frame = CGRect(x: 8, y: 36, width: infoWindow.frame.width - 16, height: 40)
        snippetLabel.text = marker.snippet
        snippetLabel.font = UIFont.systemFont(ofSize: 14)
        snippetLabel.numberOfLines = 0
        infoWindow.addSubview(snippetLabel)
        
        // Action button
        let actionButton = UIButton(type: .system)
        actionButton.frame = CGRect(x: 8, y: 76, width: infoWindow.frame.width - 16, height: 50)
        actionButton.setTitle("İlan Detayları", for: .normal)
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        actionButton.addTarget(self, action: #selector(infoWindowButtonTapped(_:)), for: .touchUpInside)
        infoWindow.addSubview(actionButton)
        
        return infoWindow
    }
    
    @objc func infoWindowButtonTapped(_ sender: UIButton) {
        if let selectedMarker = selectedMarker, let advertiseDetail = selectedMarker.userData as? AdvertiseDetail {
            if let userAdvertisesVC = storyboard?.instantiateViewController(withIdentifier: "UserApplyApplicationViewController") as? UserApplyApplicationViewController {
                userAdvertisesVC.advertiseDetail = advertiseDetail
                navigationController?.setNavigationBarHidden(true, animated: false)
                navigationController?.pushViewController(userAdvertisesVC, animated: true)
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if let customInfoWindow = customInfoWindow {
            customInfoWindow.removeFromSuperview()
            self.customInfoWindow = nil
        }
    }
}// CLLocationCoordinate2D için Hashable sarmalayıcı yapı
struct LocationCoordinate2DWrapper: Hashable {
    let coordinate: CLLocationCoordinate2D
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(coordinate.latitude)
        hasher.combine(coordinate.longitude)
    }
    
    static func == (lhs: LocationCoordinate2DWrapper, rhs: LocationCoordinate2DWrapper) -> Bool {
        return lhs.coordinate.latitude == rhs.coordinate.latitude && lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}
