import UIKit

class ErrorCell: UITableViewCell, Reusable {

    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    private lazy var titleLabel: UILabel = .init()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear

        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 32.0),
                titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32.0),
                titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 32.0),
                titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 32.0),
                titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
            ]
        )
    }
}
