import UIKit

enum WEAForecastTemperatureUnit : Int {
    case Celsius = 0
    case Fahrenheit = 1
}

enum WEAForecastLengthUnit: Int {
    case Meters = 0
    case Yards = 1
}

enum WEAImage: Int {
    case Small = 0
    case Big = 1
}

@objc(WEAForecast)
class WEAForecast: _WEAForecast {

    // MARK: - Getters
    
    var compass: String {
        get {
            let directions: [Int: String] = [
                0:   "N",
                45:  "NE",
                90:  "E",
                135: "SE",
                180: "S",
                225: "SW",
                270: "W",
                315: "NW",
                360: "N"
            ]
            let deg: Int = Int(round(self.windDegrees!.doubleValue / 45))
            if let direction = directions[deg * 45] {
                return direction
            }
            
            return "-"
        }
    }
    
    // MARK: - Image
    
    func imageIcon(type: WEAImage) -> UIImage {
        // TODO(vojta) need found out more icons
        var imageName: String = "Sun"
        if self.icon != nil {
            let matches = self.icon?.wea_matchesForRegex("(.*)\\d")
            if matches?.count > 0 {
                if matches?.first == "09" || matches?.first == "10" || matches?.first == "11" {
                    imageName = "CL"
                }
                else if matches?.first == "02" || matches?.first == "03" || matches?.first == "04" {
                    imageName = "CS"
                }
            }
        }
        
        if type == WEAImage.Big {
            imageName = String(format: "%@Big", imageName)
        }
        
        return UIImage(named: imageName)!
    }
    
    // MARK: - Unit converters
    
    func temperatureIn(unit: WEAForecastTemperatureUnit) -> NSNumber {
        var temperature: NSNumber = self.temperature!
    
        switch unit {
            case WEAForecastTemperatureUnit.Fahrenheit:
                temperature = NSNumber(double: (1.8 * (temperature.doubleValue - 273.15) + 32))
                break;

            case WEAForecastTemperatureUnit.Celsius:
                temperature = NSNumber(double: (temperature.doubleValue - 273.15))
                break;
            
            default:
                break
        }
    
        return temperature
    }
    
    func windSpeedIn(unit: WEAForecastLengthUnit) -> NSNumber {
        var speed: NSNumber = self.windSpeed!
        if unit == WEAForecastLengthUnit.Yards {
            speed = NSNumber(double: (speed.doubleValue * 1.093613))
        }
        
        return speed
    }
    
    // MARK: - Setup
    
    func setEntityDate(response: AnyObject?) {
        let timestamp: NSNumber? = response?.valueForKeyPath("dt") as? NSNumber
        let timeInterval: NSTimeInterval = timestamp as! NSTimeInterval
        self.date = NSDate(timeIntervalSince1970: timeInterval)
        
        self.day = self.date?.wea_dayOfWeek()
        self.humidity = response?.valueForKeyPath("humidity") as? NSNumber
        self.temperature = response?.valueForKeyPath("temp.day") as? NSNumber
        self.pressure = response?.valueForKeyPath("pressure") as? NSNumber
        self.windSpeed = response?.valueForKeyPath("speed") as? NSNumber
        self.windDegrees = response?.valueForKeyPath("deg") as? NSNumber
        
        if let weather: [AnyObject] = response?.valueForKeyPath("weather") as? [AnyObject] {
            self.info = weather.first?.valueForKey("main") as? String
            self.icon = weather.first?.valueForKey("icon") as? String
        }
        
        if let rain: NSNumber = response?.valueForKey("rain") as? NSNumber {
            self.rain = rain
        }
    }
    
    func setEntityDateSimple(response: AnyObject?) {
        let timestamp: NSNumber? = response?.valueForKeyPath("dt") as? NSNumber
        let timeInterval: NSTimeInterval = timestamp as! NSTimeInterval
        self.date = NSDate(timeIntervalSince1970: timeInterval)
        
        self.day = self.date?.wea_dayOfWeek()
        self.humidity = response?.valueForKeyPath("main.humidity") as? NSNumber
        self.temperature = response?.valueForKeyPath("main.temp") as? NSNumber
        self.pressure = response?.valueForKeyPath("main.pressure") as? NSNumber
        self.windSpeed = response?.valueForKeyPath("wind.speed") as? NSNumber
        
        if let weather: [AnyObject] = response?.valueForKeyPath("weather") as? [AnyObject] {
            self.info = weather.first?.valueForKey("main") as? String
            self.icon = weather.first?.valueForKey("icon") as? String
        }
    }
    
}
