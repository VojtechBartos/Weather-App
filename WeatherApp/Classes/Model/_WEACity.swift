// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WEACity.swift instead.

import CoreData

enum WEACityAttributes: String {
    case address = "address"
    case country = "country"
    case current = "current"
    case googlePlaceId = "googlePlaceId"
    case latitude = "latitude"
    case longtitude = "longtitude"
    case name = "name"
    case weatherCityId = "weatherCityId"
}

enum WEACityRelationships: String {
    case forecast = "forecast"
}

@objc
class _WEACity: NSManagedObject {

    // MARK: - Class methods

    class func entityName () -> String {
        return "WEACity"
    }

    class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _WEACity.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged
    var address: String?

    // func validateAddress(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var country: String?

    // func validateCountry(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var current: NSNumber?

    // func validateCurrent(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var googlePlaceId: String?

    // func validateGooglePlaceId(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var latitude: NSNumber?

    // func validateLatitude(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var longtitude: NSNumber?

    // func validateLongtitude(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var name: String?

    // func validateName(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var weatherCityId: NSNumber?

    // func validateWeatherCityId(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

    @NSManaged
    var forecast: NSSet

}

extension _WEACity {

    func addForecast(objects: NSSet) {
        let mutable = self.forecast.mutableCopy() as! NSMutableSet
        mutable.unionSet(objects as Set<NSObject>)
        self.forecast = mutable.copy() as! NSSet
    }

    func removeForecast(objects: NSSet) {
        let mutable = self.forecast.mutableCopy() as! NSMutableSet
        mutable.minusSet(objects as Set<NSObject>)
        self.forecast = mutable.copy() as! NSSet
    }

    func addForecastObject(value: WEAForecast!) {
        let mutable = self.forecast.mutableCopy() as! NSMutableSet
        mutable.addObject(value)
        self.forecast = mutable.copy() as! NSSet
    }

    func removeForecastObject(value: WEAForecast!) {
        let mutable = self.forecast.mutableCopy() as! NSMutableSet
        mutable.removeObject(value)
        self.forecast = mutable.copy() as! NSSet
    }

}
