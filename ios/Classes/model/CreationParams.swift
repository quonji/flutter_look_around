import MapKit

@available(iOS 16.0, *)
struct CreationParams {
    var latitude: Double?
    var longitude: Double?
    var isNavigationEnabled: Bool
    var showsRoadLabels: Bool
    var badgePosition: MKLookAroundBadgePosition
    var POIPointOfInterestFilter: MKPointOfInterestFilter?

    init(arguments: [String: Any]) {
        self.latitude = arguments["latitude"] as? Double
        self.longitude = arguments["longitude"] as? Double
        self.isNavigationEnabled = arguments["isNavigationEnabled"] as? Bool ?? false
        self.showsRoadLabels = arguments["showsRoadLabels"] as? Bool ?? false
        if let POIPointOfInterestFilterMap = arguments["POIPointOfInterestFilter"] as? [String: Any] {
            self.POIPointOfInterestFilter = MKPointOfInterestFilter.fromMap(POIPointOfInterestFilterMap)
        }
        
        if let badgePositionString = arguments["badgePosition"] as? String {
            self.badgePosition = MKLookAroundBadgePosition.fromString(badgePositionString)
        } else {
            self.badgePosition = .bottomTrailing
        }
    }
}

@available(iOS 16.0, *)
extension MKLookAroundBadgePosition {
    static func fromString(_ string: String) -> MKLookAroundBadgePosition {
        switch string {
        case "topLeading":
            return .topLeading
        case "topTrailing":
            return .topTrailing
        case "bottomTrailing":
            return .bottomTrailing
        default:
            return .bottomTrailing
        }
    }
}

extension MKPointOfInterestFilter {
    static func fromMap(_ map: [String: Any]) -> MKPointOfInterestFilter {
        let includedCategoriesStrings = map["includedCategories"] as? [String] ?? []
        let excludedCategoriesStrings = map["excludedCategories"] as? [String] ?? []

        let includedCategories = includedCategoriesStrings.compactMap { MKPointOfInterestCategory.fromString($0) }
        let excludedCategories = excludedCategoriesStrings.compactMap { MKPointOfInterestCategory.fromString($0) }
        
        if let includingAll = map["includingAll"] as? Bool, includingAll {
            return .includingAll
        } else if let excludingAll = map["excludingAll"] as? Bool, excludingAll {
            return .excludingAll
        } else if includedCategories.isEmpty {
            return MKPointOfInterestFilter(excluding: excludedCategories)
        } else if excludedCategories.isEmpty {
            return MKPointOfInterestFilter(including: includedCategories)
        } else {
            return .includingAll
        }
    }
}

extension MKPointOfInterestCategory {
        static func fromString(_ string: String) -> MKPointOfInterestCategory? {
        switch string {
        case "museum":
            return .museum
        case "theater":
            return .theater
        case "library":
            return .library
        case "school":
            return .school
        case "university":
            return .university
        case "movieTheater":
            return .movieTheater
        case "nightlife":
            return .nightlife
        case "fireStation":
            return .fireStation
        case "hospital":
            return .hospital
        case "pharmacy":
            return .pharmacy
        case "police":
            return .police
        case "bakery":
            return .bakery
        case "brewery":
            return .brewery
        case "cafe":
            return .cafe
        case "foodMarket":
            return .foodMarket
        case "restaurant":
            return .restaurant
        case "winery":
            return .winery
        case "atm":
            return .atm
        case "bank":
            return .bank
        case "evCharger":
            return .evCharger
        case "fitnessCenter":
            return .fitnessCenter
        case "laundry":
            return .laundry
        case "postOffice":
            return .postOffice
        case "restroom":
            return .restroom
        case "store":
            return .store
        case "amusementPark":
            return .amusementPark
        case "aquarium":
            return .aquarium
        case "beach":
            return .beach
        case "campground":
            return .campground
        case "marina":
            return .marina
        case "nationalPark":
            return .nationalPark
        case "park":
            return .park
        case "zoo":
            return .zoo
        case "stadium":
            return .stadium
        case "airport":
            return .airport
        case "carRental":
            return .carRental
        case "gasStation":
            return .gasStation
        case "hotel":
            return .hotel
        case "parking":
            return .parking
        case "publicTransport":
            return .publicTransport
        default:
            return nil
        }
    }
}
