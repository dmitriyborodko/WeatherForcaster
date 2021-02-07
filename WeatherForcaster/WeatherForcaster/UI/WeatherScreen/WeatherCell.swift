import UIKit

class WeatherCell: UICollectionViewCell {

    var temperature: String? {
        get { temperatureLabel.text }
        set { temperatureLabel.text = newValue }
    }

    var icon: UIImage? {
        get { iconImageView.image }
        set { iconImageView.image = newValue }
    }

    var time: String? {
        get { timeLabel.text }
        set { timeLabel.text = newValue }
    }

    private let timeLabel: UILabel = .init()
    private let temperatureLabel: UILabel = .init()
    private let iconImageView: UIImageView = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear
        configureUI()
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

    private func configureUI() {
        contentView.layer.cornerRadius = Constants.contentViewCornerRadius
        contentView.layer.cornerCurve = .continuous
        contentView.backgroundColor = .lightGray

        configureTimeLabel()
        configureTemperatureView()
        configureIconImageView()
    }

    private func configureTimeLabel() {
        timeLabel.font = Constants.temperatureFont
        timeLabel.textColor = .darkText
        timeLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(timeLabel)
        NSLayoutConstraint.activate(
            [
                timeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.contentViewInnerInsets.left),
                timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.contentViewInnerInsets.top),
                timeLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: Constants.contentViewInnerInsets.right)
            ]
        )
    }

    private func configureTemperatureView() {
        temperatureLabel.font = Constants.temperatureFont
        temperatureLabel.textColor = .darkText
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(temperatureLabel)
        NSLayoutConstraint.activate(
            [
                temperatureLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.contentViewInnerInsets.left),
                temperatureLabel.topAnchor
                    .constraint(equalTo: timeLabel.bottomAnchor, constant: Constants.timeLabelBottomOffset)
            ]
        )
    }

    private func configureIconImageView() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(iconImageView)
        NSLayoutConstraint.activate(
            [
                iconImageView.topAnchor
                    .constraint(equalTo: topAnchor, constant: Constants.contentViewInnerInsets.top),
                iconImageView.leftAnchor
                    .constraint(equalTo: temperatureLabel.rightAnchor, constant: Constants.iconImageViewLeftOffset),
                iconImageView.rightAnchor
                    .constraint(equalTo: rightAnchor, constant: Constants.contentViewInnerInsets.right),
                iconImageView.widthAnchor.constraint(equalToConstant: Constants.iconImageViewSize.width),
                iconImageView.heightAnchor.constraint(equalToConstant: Constants.iconImageViewSize.height)
            ]
        )
    }
}

private enum Constants {

    static let contentViewCornerRadius: CGFloat = 32.0
    static let contentViewInnerInsets: UIEdgeInsets = .init(top: 8.0, left: 8.0, bottom: -8.0, right: -8.0)
    static let timeLabelBottomOffset: CGFloat = 8.0

    static let iconImageViewSize: CGSize = .init(width: 66.0, height: 66.0)
    static let iconImageViewLeftOffset: CGFloat = 8.0

    static let temperatureFont: UIFont = UIFont.systemFont(ofSize: 50.0, weight: .thin)
}
