import MagicalRecord

@objc(WEACity)
class WEACity: _WEACity {
    
    // MARK: - Setup
    
    func setEntityData(response: AnyObject?) {
        // basic city info
        self.name = response?.valueForKeyPath("city.name") as? String
        self.country = response?.valueForKeyPath("city.country") as? String
        self.longtitude = response?.valueForKeyPath("city.coord.lon") as? NSNumber
        self.latitude = response?.valueForKeyPath("city.coord.lat") as? NSNumber
        
        // forecast
        var forecast: [WEAForecast] = []
        if let list: AnyObject = response?.valueForKeyPath("list") {
            for response in list as! [AnyObject] {
                var day: WEAForecast = WEAForecast.MR_createEntity() as! WEAForecast
                day.setEntityDate(response)
                day.city = self
                forecast.append(day)
            }
        }
        self.forecast = NSSet(array: forecast)
    }
    
    // MARK: - Helpers
    
    func orderedForecast() -> [WEAForecast] {
        let predicate: NSPredicate = NSPredicate(format: "city = %@", self)
        return WEAForecast.MR_findAllSortedBy("date", ascending: true, withPredicate: predicate) as! [WEAForecast]
    }
    
    func isCurrent() -> Bool {
        var current: Bool = false
        if self.current != nil {
            current = self.current!.boolValue
        }
        return current
    }
    
    // MARK: - Class helper methods
    
    class func getOrCreate(weatherCityId: NSNumber) -> WEACity {
        var city: WEACity? = WEACity.MR_findFirstByAttribute("weatherCityId", withValue: weatherCityId) as? WEACity
        if city == nil {
            city = WEACity.MR_createEntity() as? WEACity
            city!.weatherCityId = weatherCityId
        }
        return city!
    }
    
    class func getOrCreateCurrent(weatherCityId: NSNumber) -> WEACity {
        var city: WEACity? = WEACity.getCurrent()
        if city != nil && city?.weatherCityId != weatherCityId {
            city?.MR_deleteEntity()
            city = nil
        }
        
        if city == nil {
            city = WEACity.getOrCreate(weatherCityId)
        }
        
        return city!
    }
    
    class func getOrCreateByGooglePlace(response: AnyObject) -> WEACity {
        var placeId: String = response["place_id"] as! String
        var cityName: String?
        if let terms: [NSDictionary] = response["terms"] as? [NSDictionary] {
            cityName = terms.first?["value"] as? String
        }
        
        let predicate: NSPredicate = NSPredicate(format: "googlePlaceId = %@ OR name = %@", placeId, cityName!)
        var city: WEACity? = WEACity.MR_findFirstWithPredicate(predicate) as? WEACity
        if city == nil {
            city = WEACity.MR_createEntity() as? WEACity
        }
        
        city!.name = cityName
        city!.address = response["description"] as? String
        city!.googlePlaceId = placeId
        
        return city!
    }

    class func getCurrent() -> WEACity? {
        return WEACity.MR_findFirstByAttribute("current", withValue: true) as? WEACity
    }
    
    class func getAll() -> [WEACity] {
        return WEACity.MR_findAllSortedBy("current", ascending: false) as! [WEACity]
    }
    
    class func updateCitiesTodayForecast(response: NSDictionary?) -> [WEACity] {
        var cities: [WEACity] = []
        if let todayForecast: [NSDictionary] = response?.valueForKey("list") as? [NSDictionary] {
            for item in todayForecast {
                let cityId: NSNumber = item.valueForKey("id") as! NSNumber
                let city: WEACity? = WEACity.MR_findFirstByAttribute("weatherCityId", withValue: cityId) as? WEACity
                if city == nil {
                    continue
                }
                if city?.current?.boolValue == true {
                    cities.append(city!)
                    continue
                }
                
                var forecast: WEAForecast = WEAForecast.MR_createEntity() as! WEAForecast
                forecast.setEntityDateSimple(item)
                city?.forecast = NSSet(array: [forecast])
                city?.weatherCityId = cityId
                city?.managedObjectContext?.save(nil)
                cities.append(city!)
            }
        }
        
        return cities
    }
}
