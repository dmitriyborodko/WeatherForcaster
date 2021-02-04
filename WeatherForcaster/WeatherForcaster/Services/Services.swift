import Foundation

class Services {

    static let weatherIconURLFormatter: WeatherIconURLFormatter = DefaultWeatherIconURLFormatter()
    static let locationNameFormatter: LocationNameFormatter = DefaultLocationNameFormatter()
    static let temperatureFormatter: TemperatureFormatter = DefaultTemperatureFormatter()
    static let weatherDateFormatter: WeatherDateFormatter = DefaultWeatherDateFormatter()

    static let weatherService: WeatherService = DefaultWeatherService(
        weatherIconURLFormatter: weatherIconURLFormatter,
        temperatureFormatter: temperatureFormatter,
        locationNameFormatter: locationNameFormatter,
        locale: { Locale.current }
    )

    static let imageService: ImageService = DefaultImageService()
}
