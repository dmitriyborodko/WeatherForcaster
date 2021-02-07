import UIKit

class Coordinator {

    var rootVC: UIViewController? { weatherNavigationController }

    private var weatherNavigationController: UINavigationController?

    init() {
        configureUI()
    }

    private func configureUI() {
        let weatherVC = WeatherVC()
        weatherVC.showErrorAlertEvent = { description in
            let alertController = UIAlertController(title: "Error", message: description, preferredStyle: .alert)
            let action = UIAlertAction(title: "Try again?", style: .default) { [weak weatherVC] _ in
                weatherVC?.reloadData()
            }
            alertController.addAction(action)
            weatherVC.present(alertController, animated: true)
        }

        weatherNavigationController = UINavigationController()
        weatherNavigationController?.setViewControllers([weatherVC], animated: false)
    }
}
