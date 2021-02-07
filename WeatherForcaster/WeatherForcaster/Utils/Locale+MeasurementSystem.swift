import Foundation

extension Locale {

    enum MeasurementSystemType: String {
        case imperial = "imperial"
        case metric = "metric"
    }

    var measurementSystem: MeasurementSystemType {
        return usesMetricSystem ? .metric : .imperial
    }

    var unitTemperature: UnitTemperature {
        switch measurementSystem {
        case .metric:
            return .celsius

        case .imperial:
            return .fahrenheit
        }
    }
}
