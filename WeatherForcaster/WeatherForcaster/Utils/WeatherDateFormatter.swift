import Foundation

protocol WeatherDateFormatter {

    func format(date: Date) -> (day: String, time: String)
}

struct DefaultWeatherDateFormatter: WeatherDateFormatter {

    private var dayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, E"
        return dateFormatter
    }()

    private var timeDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()

    func format(date: Date) -> (day: String, time: String) {
        return (day: dayDateFormatter.string(from: date), time: timeDateFormatter.string(from: date))
    }
}
