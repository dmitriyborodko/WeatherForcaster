import Foundation

struct WeatherItem {

    let iconURL: URL
    let temperature: String
    let date: Date
}

extension WeatherItem {

    init?(
        withDTO dto: WeatherItemDTO,
        iconURLFormatter: WeatherIconURLFormatter,
        temperatureFormatter: TemperatureFormatter,
        locale: Locale
    ) {
        guard
            let iconURL = dto.weather?.first?.icon.flatMap(iconURLFormatter.format),
            let temperature = dto.main?.temp.flatMap({ temperatureFormatter.formatTemperature($0, locale: locale) }),
            let date = dto.dt.flatMap(Date.init(timeIntervalSince1970:))
        else { return nil }

        self.iconURL = iconURL
        self.temperature = temperature
        self.date = date
    }
}
