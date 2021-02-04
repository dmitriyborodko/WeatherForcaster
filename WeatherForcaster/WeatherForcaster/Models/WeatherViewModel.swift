import Foundation

struct WeatherViewModel {

    let locationName: String
    let sections: [WeatherSectionViewModel]
}

struct WeatherSectionViewModel {

    let title: String
    let items: [WeatherItemViewModel]
}

struct WeatherItemViewModel {

    let iconURL: URL
    let temperature: String
    let time: String
}

extension WeatherViewModel {

    private static func mapWeatheItems(items: [WeatherItem], formatter: WeatherDateFormatter) -> [WeatherSectionViewModel] {
        guard !items.isEmpty else { return [] }

        var sections = [WeatherSectionViewModel]()
        var currentItems = [WeatherItemViewModel]()
        var currentTitle: String?

        for item in items {
            let date = formatter.format(date: item.date)

            if let title = currentTitle, title != date.day {
                sections.append(WeatherSectionViewModel(title: title, items: currentItems))
                currentItems = []
            }

            currentTitle = date.day
            currentItems.append(
                WeatherItemViewModel(iconURL: item.iconURL, temperature: item.temperature, time: date.time)
            )
        }

        if let title = currentTitle, !currentItems.isEmpty {
            sections.append(WeatherSectionViewModel(title: title, items: currentItems))
        }

        return sections
    }

    init(weatherForecast: WeatherForecast, formatter: WeatherDateFormatter) {
        self.locationName = weatherForecast.location
        self.sections = Self.mapWeatheItems(items: weatherForecast.items, formatter: formatter)
    }
}
