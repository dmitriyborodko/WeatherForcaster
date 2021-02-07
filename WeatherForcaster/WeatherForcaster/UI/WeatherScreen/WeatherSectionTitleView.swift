import UIKit

class WeatherSectionTitleView: UICollectionReusableView {

    static let sectionHeaderElementKind = "section-header-element-kind"

    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.adjustsFontForContentSizeCategory = true
        addSubview(titleLabel)
        
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
    }
}
