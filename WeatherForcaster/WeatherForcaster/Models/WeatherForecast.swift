import Foundation

struct WeatherForecast {

    let location: String
    let items: [WeatherItem]
}

extension WeatherForecast {

    init?(
        withDTO dto: WeatherResponseDTO,
        iconURLFormatter: WeatherIconURLFormatter,
        locationNameFormatter: LocationNameFormatter,
        temperatureFormatter: TemperatureFormatter,
        locale: Locale
    ) {
        guard
            let city = dto.city,
            let location = locationNameFormatter.format(city: city.name, country: city.country)
        else { return nil }

        self.location = location
        self.items = dto.list.compactMap { weatherItemDTO in
            WeatherItem.init(
                withDTO: weatherItemDTO,
                iconURLFormatter: iconURLFormatter,
                temperatureFormatter: temperatureFormatter,
                locale: locale
            )
        }
    }
}
