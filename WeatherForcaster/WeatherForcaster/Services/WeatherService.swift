import Foundation

protocol WeatherService {

    func fetchWeather(
        with cityName: String,
        completion: @escaping (Result<WeatherForecast, WeatherServiceError>) -> Void
    )
}

class DefaultWeatherService: WeatherService {

    let weatherIconURLFormatter: WeatherIconURLFormatter
    let locationNameFormatter: LocationNameFormatter
    let temperatureFormatter: TemperatureFormatter
    let locale: () -> Locale

    init(
        weatherIconURLFormatter: WeatherIconURLFormatter,
        temperatureFormatter: TemperatureFormatter,
        locationNameFormatter: LocationNameFormatter,
        locale: @escaping () -> Locale
    ) {
        self.weatherIconURLFormatter = weatherIconURLFormatter
        self.temperatureFormatter = temperatureFormatter
        self.locationNameFormatter = locationNameFormatter
        self.locale = locale
    }

    func fetchWeather(
        with cityName: String,
        completion: @escaping (Result<WeatherForecast, WeatherServiceError>) -> Void
    ) {
        let selectedLocale = locale()
        var urlComponents = Constants.weatherURLConponents
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: cityName),
            URLQueryItem(name: "appid", value: Constants.appKey),
            URLQueryItem(name: "units", value: selectedLocale.measurementSystem.rawValue)
        ]

        guard let url = urlComponents.url else {
            completion(.failure(WeatherServiceError.unknown))
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard
                let self = self,
                error == nil,
                let data = data,
                let dto = try? JSONDecoder().decode(WeatherResponseDTO.self, from: data),
                let weatherForecast = WeatherForecast(
                    withDTO: dto,
                    iconURLFormatter: self.weatherIconURLFormatter,
                    locationNameFormatter: self.locationNameFormatter,
                    temperatureFormatter: self.temperatureFormatter,
                    locale: selectedLocale
                )
            else {
                DispatchQueue.main.async {
                    completion(.failure(.apiError))
                }
                return
            }

            DispatchQueue.main.async {
                completion(.success(weatherForecast))
            }
        }.resume()
    }
}

enum WeatherServiceError: Error {

    case unknown
    case apiError
}

private enum Constants {

    static let weatherURLConponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/forecast")!
    static let appKey: String = "2ffedf5f3cc7cea9cbcc23dcefed4782"
}

private extension Locale {

    enum MeasurementSystemType: String {
        case imperial = "imperial"
        case metric = "metric"
    }

    var measurementSystem: MeasurementSystemType {
        return usesMetricSystem ? .metric : .imperial
    }
}
