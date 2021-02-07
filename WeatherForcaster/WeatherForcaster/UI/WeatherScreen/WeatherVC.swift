import UIKit

class WeatherVC: UIViewController {

    var showErrorAlertEvent: ((String) -> Void)?

    private enum State {
        case loading
        case presenting(WeatherVM)
        case error(Error)
    }

    private lazy var titleSegmentedControl: UISegmentedControl = self.makeTitleSegmentedControl()
    private lazy var collectionView: UICollectionView = makeCollectionView()

    private var dataSource: UICollectionViewDiffableDataSource<WeatherVM.Section, WeatherVM.Item>?
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
        view = collectionView

        configureUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    func reloadData() {
        guard isViewLoaded else { return }

        loadData()
    }

    @objc private func onTitleSegmentedControlValueChanged() {
        loadData()
    }

    @objc private func onRefreshControlValueChanged() {
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

    private func makeCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.alwaysBounceVertical = true

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefreshControlValueChanged), for: .valueChanged)
        collectionView.refreshControl = refreshControl

        return collectionView
    }

    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.titleView = titleSegmentedControl
    }

    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (
            sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment
        ) -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(
                    CGFloat(layoutEnvironment.container.effectiveContentSize.width > 500 ? 0.425 : 0.65)
                ),
                heightDimension: .absolute(150)
            )

            let section = NSCollectionLayoutSection(
                group: NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            )

            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 20
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

            let titleSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(44)
            )
            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: titleSize,
                elementKind: WeatherSectionTitleView.sectionHeaderElementKind,
                alignment: .top
            )
            section.boundarySupplementaryItems = [titleSupplementary]

            return section
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20

        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
    }

    private func configureWeatherCell(_ cell: WeatherCell, indexPath: IndexPath, viewModel: WeatherVM.Item) {
        cell.time = viewModel.time
        cell.temperature = viewModel.temperature
        cell.icon = #imageLiteral(resourceName: "camera")
        imageService.fetchImage(with: viewModel.iconURL) { [weak cell] result in
            guard let cell = cell, case .success(let image) = result else { return }
            cell.icon = image
        }
    }

    private func applyState(_ state: State) {
        switch state {
        case .loading:
            collectionView.refreshControl?.beginRefreshing()
            applyEmptyDataSource()

        case .presenting(let viewModel):
            collectionView.refreshControl?.endRefreshing()
            applyDataSource(for: viewModel)

        case .error(let error):
            collectionView.refreshControl?.endRefreshing()
            applyEmptyDataSource()
            showErrorAlertEvent?(error.localizedDescription)
        }
    }

    private func applyEmptyDataSource() {
        dataSource = nil
        collectionView.reloadData()
    }

    private func applyDataSource(for viewModel: WeatherVM) {
        let cellRegistration = UICollectionView.CellRegistration<WeatherCell, WeatherVM.Item> {
            self.configureWeatherCell($0, indexPath: $1, viewModel: $2)
        }

        dataSource = UICollectionViewDiffableDataSource<WeatherVM.Section, WeatherVM.Item>(
            collectionView: collectionView
        ) { collectionView, indexPath, item -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }

        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<WeatherSectionTitleView>(
            elementKind: WeatherSectionTitleView.sectionHeaderElementKind
        ) { supplementaryView, string, indexPath in
            supplementaryView.title = viewModel.sections[indexPath.section].title
        }

        dataSource?.supplementaryViewProvider = { view, kind, index in
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: supplementaryRegistration, for: index
            )
        }

        var currentSnapshot = NSDiffableDataSourceSnapshot<WeatherVM.Section, WeatherVM.Item>()
        viewModel.sections.forEach { section in
            currentSnapshot.appendSections([section])
            currentSnapshot.appendItems(section.items)
        }

        dataSource?.apply(currentSnapshot, animatingDifferences: false) {
            self.collectionView.reloadData()
        }
    }

    private func loadData() {
        applyState(.loading)

        weatherService.fetchWeather(with: Constants.defaultCityName) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let weatherForecast):
                self.applyState(
                    .presenting(WeatherVM(weatherForecast: weatherForecast, formatter: self.weatherDateFormatter))
                )

            case .failure(let error):
                self.applyState(.error(error))
            }
        }
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
