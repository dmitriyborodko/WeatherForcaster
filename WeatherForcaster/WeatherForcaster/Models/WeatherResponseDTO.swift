import Foundation

struct WeatherResponseDTO: Decodable {

    let city: CityDTO?
    let list: [WeatherItemDTO]
}

struct WeatherItemDTO: Decodable {

    let weather: [WeatherDTO]?
    let main: WeatherMainDTO?
    let dt: Double?
}

struct WeatherDTO: Decodable {

    let icon: String?
}

struct WeatherMainDTO: Decodable {

    let temp: Double?
}

struct CityDTO: Decodable {

    let name: String?
    let country: String?
}
