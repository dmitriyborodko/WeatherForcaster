import UIKit

class WeatherVC: UIViewController {

    private enum State {
        case loading
        case presenting(WeatherViewModel)
        case error(Error)
    }

    private lazy var titleSegmentedControl: UISegmentedControl = self.makeTitleSegmentedControl()
    private lazy var tableView: UITableView = makeTableView()

    private var state: State = .loading
    private var selectedAssetType: NavigationState {
        NavigationState(rawValue: titleSegmentedControl.selectedSegmentIndex) ?? .default
    }

    private let weatherService: WeatherService
    private let imageService: ImageService
    private let weatherDateFormatter: WeatherDateFormatter

    init(
        weatherService: WeatherService = Services.weatherService,
        imageService: ImageService = Services.imageService,
        weatherDateFormatter: WeatherDateFormatter = Services.weatherDateFormatter
    ) {
        self.weatherService = weatherService
        self.imageService = imageService
        self.weatherDateFormatter = weatherDateFormatter

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = tableView

        configureUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    @objc private func onTitleSegmentedControlValueChanged() {
        reloadTableView()
    }

    @objc private func onRefreshControlValueChange() {
        loadData()
    }

    private func makeTitleSegmentedControl() -> UISegmentedControl {
        let segmentedControl = UISegmentedControl()

        for (index, type) in NavigationState.allCases.enumerated() {
            segmentedControl.insertSegment(withTitle: type.title, at: index, animated: false)
        }

        segmentedControl.selectedSegmentIndex = NavigationState.default.rawValue
        segmentedControl.addTarget(self, action: #selector(onTitleSegmentedControlValueChanged), for: .valueChanged)

        return segmentedControl
    }

    private func makeTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.dataSource = self

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefreshControlValueChange), for: .valueChanged)
        tableView.refreshControl = refreshControl

        return tableView
    }

    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.titleView = titleSegmentedControl
    }

    private func reloadTableView() {
        switch self.state {
        case .loading:
            self.tableView.refreshControl?.beginRefreshing()

        case .presenting, .error:
            self.tableView.refreshControl?.endRefreshing()
        }

        self.tableView.reloadData()
    }

    private func loadData() {
        self.state = .loading
        self.reloadTableView()

        weatherService.fetchWeather(with: Constants.defaultCityName) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let weatherForecast):
                self.state = .presenting(
                    WeatherViewModel(weatherForecast: weatherForecast, formatter: self.weatherDateFormatter)
                )
                self.reloadTableView()

            case .failure(let error):
                self.state = .error(error)
                self.reloadTableView()
            }
        }
    }
}

extension WeatherVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch state {
        case .loading:
            return 0

        case .presenting:
            return 1

        case .error:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch state {
        case .loading:
            return UITableViewCell()

        case .presenting(let viewModel):
            guard let item = viewModel.sections[safe: indexPath.section]?.items[safe: indexPath.row] else {
                return UITableViewCell()
            }

            return dequeueWeatherCell(in: tableView, viewModel: item)

        case .error(let error):
            let cell: ErrorCell = tableView.registerAndDequeueReusableCell()
            cell.title = "\(error.localizedDescription)"

            return cell
        }
    }

    private func dequeueWeatherCell(in tableView: UITableView, viewModel: WeatherItemViewModel) -> UITableViewCell {
        let cell: WeatherCell = tableView.registerAndDequeueReusableCell()
        cell.temperature = viewModel.temperature

        cell.icon = #imageLiteral(resourceName: "camera")
        imageService.fetchImage(with: viewModel.iconURL) { [weak cell] result in
            guard case .success(let image) = result else { return }
            cell?.icon = image
        }

        return cell
    }
}

private enum NavigationState: Int, CaseIterable {

    case actual = 0
    case stored

    static var `default`: Self = .actual

    var title: String {
        switch self {
        case .actual:
            return "Actual"

        case .stored:
            return "Stored"
        }
    }
}

private enum VCError: Error {

    case weakSelfDeinit
}

private enum Constants {

    static let defaultCityName = "München,DE"
}
