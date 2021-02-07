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
        
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.adjustsFontForContentSizeCategory = true
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate(
            [
                titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.insets.left),
                titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.insets.top),
                titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: Constants.insets.right),
                titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.insets.bottom)
            ]
        )
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
    }
}

private enum Constants {
    
    static let insets: UIEdgeInsets = .init(top: 10.0, left: 10.0, bottom: -10.0, right: -10.0)
}
