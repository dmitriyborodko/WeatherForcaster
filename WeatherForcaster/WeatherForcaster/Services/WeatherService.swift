import Foundation

protocol WeatherService {

    func fetchWeather(
        with cityName: String,
        completion: @escaping (Result<WeatherForecast, WeatherServiceError>) -> Void
    )

    func fetchStoredWeather(completion: @escaping (Result<WeatherForecast, WeatherServiceError>) -> Void)
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

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            self?.handleResponse(data: data, error: error, locale: selectedLocale, completion: completion)
        }.resume()
    }

    func fetchStoredWeather(completion: @escaping (Result<WeatherForecast, WeatherServiceError>) -> Void) {
        let selectedLocale = locale()
        guard
            let path = Bundle.main.path(forResource: "moscow", ofType: nil),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path))
        else {
            DispatchQueue.main.async {
                completion(.failure(.unknownFile))
            }
            return
        }

        handleResponse(data: data, error: nil, locale: selectedLocale, completion: completion)
    }

    private func handleResponse(
        data: Data?,
        error: Error?,
        locale: Locale,
        completion: @escaping (Result<WeatherForecast, WeatherServiceError>) -> Void
    ) {
        guard
            error == nil,
            let data = data,
            let dto = try? JSONDecoder().decode(WeatherResponseDTO.self, from: data),
            let weatherForecast = WeatherForecast(
                withDTO: dto,
                iconURLFormatter: self.weatherIconURLFormatter,
                locationNameFormatter: self.locationNameFormatter,
                temperatureFormatter: self.temperatureFormatter,
                locale: locale
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
    }
}

enum WeatherServiceError: Error {

    case unknown
    case apiError
    case unknownFile
}

private enum Constants {

    static let weatherURLConponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/forecast")!
    static let appKey: String = "2ffedf5f3cc7cea9cbcc23dcefed4782"
}
