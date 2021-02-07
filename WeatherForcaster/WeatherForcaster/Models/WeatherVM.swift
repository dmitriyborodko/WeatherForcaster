import Foundation

struct WeatherVM {

    struct Section: Hashable {
        let title: String
        let items: [Item]
    }

    struct Item: Hashable {
        let iconURL: URL
        let temperature: String
        let time: String
    }

    let locationName: String
    let sections: [Section]
}

extension WeatherVM {

    private static func mapWeatherItems(items: [WeatherItem], formatter: WeatherDateFormatter) -> [WeatherVM.Section] {
        guard !items.isEmpty else { return [] }

        var sections = [WeatherVM.Section]()
        var currentItems = [WeatherVM.Item]()
        var currentTitle: String?

        for item in items {
            let date = formatter.format(date: item.date)

            if let title = currentTitle, title != date.day {
                sections.append(WeatherVM.Section(title: title, items: currentItems))
                currentItems = []
            }

            currentTitle = date.day
            currentItems.append(
                WeatherVM.Item(iconURL: item.iconURL, temperature: item.temperature, time: date.time)
            )
        }

        if let title = currentTitle, !currentItems.isEmpty {
            sections.append(WeatherVM.Section(title: title, items: currentItems))
        }

        return sections
    }

    init(weatherForecast: WeatherForecast, formatter: WeatherDateFormatter) {
        self.locationName = weatherForecast.location
        self.sections = Self.mapWeatherItems(items: weatherForecast.items, formatter: formatter)
    }
}
