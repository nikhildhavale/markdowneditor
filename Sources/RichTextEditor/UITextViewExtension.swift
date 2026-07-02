import UIKit

extension UITextView {
    var placeholder: String? {
        get {
            (viewWithTag(999) as? UILabel)?.text
        }
        set {
            if let placeholder = newValue {
                let label = UILabel()
                label.tag = 999
                label.text = placeholder
                label.font = font
                label.textColor = .systemGray3
                label.numberOfLines = 1
                label.sizeToFit()

                addSubview(label)
                label.frame.origin = CGPoint(x: 5, y: (font?.pointSize ?? 16) / 2)

                self.bringSubviewToFront(label)
                NotificationCenter.default.addObserver(self, selector: #selector(updatePlaceholder), name: UITextView.textDidChangeNotification, object: self)
            } else {
                (viewWithTag(999))?.removeFromSuperview()
            }
        }
    }

    @objc private func updatePlaceholder() {
        if let label = viewWithTag(999) as? UILabel {
            label.isHidden = !text.isEmpty
        }
    }
}
