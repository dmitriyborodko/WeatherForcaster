import Foundation

protocol TemperatureFormatter {

    func formatTemperature(_ temperature: Double, locale: Locale) -> String
}

struct DefaultTemperatureFormatter: TemperatureFormatter {

    let measurementFormatter: MeasurementFormatter = .init()

    func formatTemperature(_ temperature: Double, locale: Locale) -> String {
        measurementFormatter.locale = locale
        measurementFormatter.numberFormatter.maximumFractionDigits = 1
        return measurementFormatter.string(from: Measurement(value: temperature, unit: locale.unitTemperature))
    }
}
