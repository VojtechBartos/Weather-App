# Weather App

## Installation

Dependencies:
 - [CocoaPods](https://cocoapods.org/)
 - Xcode 6.3 at least
 - [Google Place API key](https://developers.google.com/places/)
 
Steps:

1. `git clone git@github.com:VojtechBartos/Weather-App.git`
2. `cd Weather-App`
3. `pod install`
4. `python Scripts/generate_credentials.py --directory ./WeatherApp` will generate `WeatherApp\Credentials.plist` file
5. open Xcode and open `Credentials.plist` and replace `API_KEY` with your Google Place API key
6. Build project
