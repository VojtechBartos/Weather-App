// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WEAForecast.swift instead.

import CoreData

enum WEAForecastAttributes: String {
    case date = "date"
    case day = "day"
    case humidity = "humidity"
    case icon = "icon"
    case info = "info"
    case pressure = "pressure"
    case rain = "rain"
    case temperature = "temperature"
    case windDegrees = "windDegrees"
    case windSpeed = "windSpeed"
}

enum WEAForecastRelationships: String {
    case city = "city"
}

@objc
class _WEAForecast: NSManagedObject {

    // MARK: - Class methods

    class func entityName () -> String {
        return "WEAForecast"
    }

    class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _WEAForecast.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged
    var date: NSDate?

    // func validateDate(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var day: String?

    // func validateDay(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var humidity: NSNumber?

    // func validateHumidity(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var icon: String?

    // func validateIcon(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var info: String?

    // func validateInfo(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var pressure: NSNumber?

    // func validatePressure(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var rain: NSNumber?

    // func validateRain(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var temperature: NSNumber?

    // func validateTemperature(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var windDegrees: NSNumber?

    // func validateWindDegrees(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var windSpeed: NSNumber?

    // func validateWindSpeed(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

    @NSManaged
    var city: WEACity?

    // func validateCity(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

}

