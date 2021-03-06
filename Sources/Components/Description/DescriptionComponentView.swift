//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

protocol DescriptionComponentViewDelegate: class {
    func descriptionComponentView(_ descriptionComponentView: DescriptionComponentView, didTapExpandDescriptionFor component: DescriptionComponent)
    func descriptionComponentView(_ descriptionComponentView: DescriptionComponentView, didTapHideDescriptionFor component: DescriptionComponent)
}

public class DescriptionComponentView: UIView {
    weak var delegate: DescriptionComponentViewDelegate?

    private var textHeightConstraint = NSLayoutConstraint()
    private var gradientHeightConstraint = NSLayoutConstraint()
    private var gradientLayer: CAGradientLayer?

    private var isWholeTextShowing: Bool = false
    private let isHidingCollapseButton: Bool = false // Toggle switch for hiding collapse button after expaning
    private let collapsedDescriptionHeight: CGFloat = 200
    private let showButtonHeightLimit: CGFloat = 300
    private let observerKeyPath = "descriptionTextView.bounds"
    private let widthOfComponent = UIScreen.main.bounds.width - .mediumLargeSpacing * 2

    @objc private dynamic lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isAccessibilityElement = true
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.contentMode = .topLeft
        return textView
    }()

    private lazy var gradientView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: widthOfComponent, height: collapsedDescriptionHeight))
        fadeBottom(of: view)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var showWholeDescriptionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isAccessibilityElement = true
        button.setTitleColor(.primaryBlue, for: .normal)
        button.addTarget(self, action: #selector(showWholeDescriptionAction), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: .mediumSpacing, left: 0, bottom: .mediumSpacing, right: 0)
        button.titleLabel?.font = .title4
        return button
    }()

    var component: DescriptionComponent? {
        didSet {
            guard let component = component else {
                return
            }

            descriptionTextView.attributedText = component.text
            showWholeDescriptionButton.setTitle(component.titleShow, for: .normal)
            descriptionTextView.accessibilityAttributedLabel = component.text

            if component.isCollapsable {
                if descriptionTextView.sizeOfStringFor(width: widthOfComponent).height <= showButtonHeightLimit {
                    descriptionTextView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
                } else {
                    setupButton()
                }
            } else {
                descriptionTextView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            }
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        addSubview(descriptionTextView)

        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: topAnchor),
            descriptionTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            descriptionTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
        ])
    }

    @objc private func showWholeDescriptionAction(sender: UIButton) {
        guard let component = component, let delegate = delegate else {
            return
        }

        if isWholeTextShowing {
            textHeightConstraint.isActive = true
            gradientHeightConstraint.isActive = true

            delegate.descriptionComponentView(self, didTapHideDescriptionFor: component)
            isWholeTextShowing = false
        } else {
            textHeightConstraint.isActive = false
            gradientHeightConstraint.isActive = false
            showWholeDescriptionButton.heightAnchor.constraint(equalToConstant: 0).isActive = isHidingCollapseButton

            delegate.descriptionComponentView(self, didTapExpandDescriptionFor: component)
            isWholeTextShowing = true
        }
    }

    func updateButtonTitle() {
        if isWholeTextShowing {
            showWholeDescriptionButton.setTitle(component?.titleHide, for: .normal)
        } else {
            showWholeDescriptionButton.setTitle(component?.titleShow, for: .normal)
        }
    }

    func setButtonShowing(showing: Bool) {
        if showing {
            showWholeDescriptionButton.alpha = 1
        } else {
            showWholeDescriptionButton.alpha = 0
            showWholeDescriptionButton.isHidden = isHidingCollapseButton
        }
    }

    func setupButton() {
        addSubview(showWholeDescriptionButton)
        addSubview(gradientView)

        addObserver(self, forKeyPath: observerKeyPath, options: .new, context: nil)

        textHeightConstraint = descriptionTextView.heightAnchor.constraint(lessThanOrEqualToConstant: collapsedDescriptionHeight)
        gradientHeightConstraint = gradientView.heightAnchor.constraint(equalToConstant: collapsedDescriptionHeight)

        NSLayoutConstraint.activate([
            textHeightConstraint,

            showWholeDescriptionButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor),
            showWholeDescriptionButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            showWholeDescriptionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            showWholeDescriptionButton.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -.mediumLargeSpacing),

            gradientView.bottomAnchor.constraint(equalTo: showWholeDescriptionButton.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            gradientHeightConstraint,
        ])
    }

    deinit {
        removeObserver(self, forKeyPath: observerKeyPath)
    }

    func fadeBottom(of view: UIView) {
        let startColor = UIColor(white: 1, alpha: 0).cgColor
        let endColor = UIColor(white: 1, alpha: 1).cgColor

        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [startColor, endColor]
        gradient.locations = [0.7, 1]

        view.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
    }

    func updategradientLayerFrame(of view: UIView) {
        gradientLayer?.removeFromSuperlayer()
        fadeBottom(of: view)
    }

    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == observerKeyPath {
            updategradientLayerFrame(of: gradientView)
            return
        }
        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
    }
}
