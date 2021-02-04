import Foundation

protocol LocationNameFormatter {

    func format(city: String?, country: String?) -> String?
}

struct DefaultLocationNameFormatter: LocationNameFormatter {

    func format(city: String?, country: String?) -> String? {
        guard let city = city else { return nil }

        if let country = country, country != "none" {
            return city + ", " + country
        } else {
            return city
        }
    }
}
