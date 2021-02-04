import UIKit

class WeatherCell: UITableViewCell, Reusable {

    var temperature: String? {
        get { temperatureLabel.text }
        set { temperatureLabel.text = newValue }
    }

    var icon: UIImage? {
        get { iconImageView.image }
        set { iconImageView.image = newValue }
    }

    private let overallView: UIView = .init()
    private let temperatureLabel: UILabel = .init()
    private let iconImageView: UIImageView = .init()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear

        configureOverallView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.temperature = nil
        self.icon = #imageLiteral(resourceName: "camera")
    }

    func configureOverallView() {
        overallView.layer.cornerRadius = Constants.overallViewCornerRadius
        overallView.layer.cornerCurve = .continuous
        overallView.backgroundColor = .lightGray
        contentView.addSubview(overallView)
        overallView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                overallView.leftAnchor.constraint(
                    greaterThanOrEqualTo: contentView.leftAnchor,
                    constant: Constants.contentEdgeInsets.left
                ),
                overallView.topAnchor.constraint(
                    equalTo: topAnchor,
                    constant: Constants.overallViewInnerInsets.top
                ),
                overallView.rightAnchor.constraint(
                    greaterThanOrEqualTo: contentView.rightAnchor,
                    constant: Constants.contentEdgeInsets.right
                ),
                overallView.bottomAnchor.constraint(
                    equalTo: bottomAnchor,
                    constant: Constants.overallViewInnerInsets.bottom
                ),
                overallView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            ]
        )

        configureTemperatureView()
        configureIconImageView()
    }

    func configureTemperatureView() {
        temperatureLabel.font = Constants.temperatureFont
        temperatureLabel.textColor = .darkText
        overallView.addSubview(temperatureLabel)

        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                temperatureLabel.leftAnchor
                    .constraint(equalTo: leftAnchor, constant: Constants.overallViewInnerInsets.left),
                temperatureLabel.topAnchor
                    .constraint(equalTo: topAnchor, constant: Constants.overallViewInnerInsets.top),
                temperatureLabel.bottomAnchor
                    .constraint(equalTo: bottomAnchor, constant: Constants.overallViewInnerInsets.bottom),
            ]
        )
    }

    func configureIconImageView() {
        overallView.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                iconImageView.topAnchor
                    .constraint(equalTo: topAnchor, constant: Constants.overallViewInnerInsets.top),
                iconImageView.leftAnchor
                    .constraint(equalTo: temperatureLabel.rightAnchor, constant: Constants.iconImageViewLeftOffset),
                iconImageView.rightAnchor
                    .constraint(equalTo: rightAnchor, constant: Constants.overallViewInnerInsets.right),
                iconImageView.widthAnchor.constraint(equalToConstant: Constants.iconImageViewSize.width),
                iconImageView.heightAnchor.constraint(equalToConstant: Constants.iconImageViewSize.height)
            ]
        )
    }
}

private enum Constants {

    static let contentEdgeInsets: UIEdgeInsets = .init(top: 32.0, left: 16.0, bottom: 32.0, right: 16.0)

    static let overallViewCornerRadius: CGFloat = 32.0
    static let overallViewInnerInsets: UIEdgeInsets = .init(top: 16.0, left: 32.0, bottom: 16.0, right: -32.0)

    static let iconImageViewSize: CGSize = .init(width: 66.0, height: 66.0)
    static let iconImageViewLeftOffset: CGFloat = 8.0

    static let temperatureFont: UIFont = UIFont.systemFont(ofSize: 50.0, weight: .thin)
}
