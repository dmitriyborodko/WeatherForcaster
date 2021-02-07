import UIKit

class ContainerCollectionViewCell: UITableViewCell, Reusable {

    private weak var controllerView: UIView?

    func setControllerView(_ controllerView: UIView) {
        guard controllerView != self.controllerView || controllerView.superview != contentView else { return }

        controllerView.translatesAutoresizingMaskIntoConstraints = false

        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.addSubview(controllerView)

        controllerView.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor).isActive = true
        controllerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor).isActive = true
        controllerView.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor).isActive = true
        controllerView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor).isActive = true

        self.controllerView = controllerView
    }
}
