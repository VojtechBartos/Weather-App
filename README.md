# Weather App

Project on which i have tested Swift language.

## Installation

Dependencies:
 - [CocoaPods](https://cocoapods.org/)
 - Xcode 6.3 at least
 - [Google Place API key](https://developers.google.com/places/)
 
Steps:

```bash
# clone repository
git clone git@github.com:VojtechBartos/Weather-App.git
cd Weather-App/

# cocoapods install
pod install

# generate file for keeping credentials
python Scripts/generate_credentials.py --directory ./WeatherApp

# open project workspace
open WeatherApp.xcworkspace
```

Open `Credentials.plist` and replace `API_KEY` with your Google Place API key and build project

## Todo's

1. CI
  - Travis - does not support Xcode 6.3
  - Cirle - iOS in beta, invitation only
