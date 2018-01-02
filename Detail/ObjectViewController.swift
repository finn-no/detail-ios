import UIKit

class ObjectViewController: UIViewController {
    var components: [Component] {
        return [
            Component(id: "c1", type: .title),
            Component(id: "c2", type: .link),
            Component(id: "c3", type: .link),
            Component(id: "c4", type: .link),
            Component(id: "c5", type: .link),
            Component(id: "c6", type: .link),
            Component(id: "c7", type: .link),
            Component(id: "c8", type: .link),
            Component(id: "c9", type: .link),
            Component(id: "c10", type: .link),
            Component(id: "c11", type: .link),
            Component(id: "c12", type: .link),
            Component(id: "c13", type: .link),
            Component(id: "c14", type: .link),
            Component(id: "c15", type: .link),
            Component(id: "c16", type: .link),
            Component(id: "c17", type: .link),
            Component(id: "c18", type: .link),
            Component(id: "c19", type: .link),
            Component(id: "c20", type: .link),
        ]
    }

    lazy var objectView: ObjectView = {
        let view = ObjectView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(objectView)
        // lay out to fill constraints

        NSLayoutConstraint.activate([
            objectView.topAnchor.constraint(equalTo: view.topAnchor),
            objectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            objectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            objectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        objectView.dataSource = self
        objectView.delegate = self
        objectView.reloadData()
    }
}

extension ObjectViewController: ObjectViewDataSource {
    func componentsInObjectView(_ objectView: ObjectView) -> [Component] {
        return components
    }
}

extension ObjectViewController: ObjectViewDelegate {
    func objectView(_ objectView: ObjectView, didSelectComponent component: Component) {
        print("selected component: \(component.id)")
    }
}
