import UIKit
import Combine

public class RichTextEditor: UIView {
    public let textView = UITextView()
    public let toolbar = UIStackView()

    private var boldButton: UIButton!
    private var italicButton: UIButton!
    private var underlineButton: UIButton!
    private var bulletListButton: UIButton!
    private var numberedListButton: UIButton!
    private var increaseIndentButton: UIButton!
    private var decreaseIndentButton: UIButton!
    private var insertLinkButton: UIButton!

    private let buttonSize: CGFloat = 44
    private let toolbarHeight: CGFloat = 56
    private var toolbarBottomConstraint: NSLayoutConstraint!
    private var toolbarTrailingConstraint: NSLayoutConstraint!
    private var keyboardCancellables: Set<AnyCancellable> = []

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .systemBackground

        setupTextView()
        setupToolbar()
        setupConstraints()
        observeKeyboard()
    }

    private func setupToolbar() {
        toolbar.axis = .horizontal
        toolbar.spacing = 8
        toolbar.distribution = .fillEqually
        toolbar.alignment = .center
        toolbar.backgroundColor = .systemGray6
        toolbar.layer.cornerRadius = 8
        toolbar.clipsToBounds = true

        let buttons: [(String, Selector)] = [
            ("B", #selector(boldTapped)),
            ("I", #selector(italicTapped)),
            ("U", #selector(underlineTapped)),
            ("•", #selector(bulletListTapped)),
            ("1.", #selector(numberedListTapped)),
            ("→", #selector(increaseIndentTapped)),
            ("←", #selector(decreaseIndentTapped)),
            ("🔗", #selector(insertLinkTapped))
        ]

        for (title, selector) in buttons {
            let button = createToolbarButton(title: title, selector: selector)
            toolbar.addArrangedSubview(button)
        }

        boldButton = toolbar.arrangedSubviews[0] as? UIButton
        italicButton = toolbar.arrangedSubviews[1] as? UIButton
        underlineButton = toolbar.arrangedSubviews[2] as? UIButton
        bulletListButton = toolbar.arrangedSubviews[3] as? UIButton
        numberedListButton = toolbar.arrangedSubviews[4] as? UIButton
        increaseIndentButton = toolbar.arrangedSubviews[5] as? UIButton
        decreaseIndentButton = toolbar.arrangedSubviews[6] as? UIButton
        insertLinkButton = toolbar.arrangedSubviews[7] as? UIButton

        addSubview(toolbar)
    }

    private func createToolbarButton(title: String, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.backgroundColor = .white
        button.layer.cornerRadius = 6
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.systemBlue.withAlphaComponent(0.6), for: .highlighted)

        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: buttonSize - 8)
        ])

        return button
    }

    private func setupTextView() {
        textView.font = .systemFont(ofSize: 16)
        textView.backgroundColor = .systemBackground
        textView.isScrollEnabled = true
        textView.layer.borderColor = UIColor.systemGray3.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8

        addSubview(textView)
    }

    private func setupConstraints() {
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false

        toolbarBottomConstraint = toolbar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        toolbarTrailingConstraint = toolbar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),

            toolbar.widthAnchor.constraint(equalToConstant: 280),
            toolbar.heightAnchor.constraint(equalToConstant: toolbarHeight),
            toolbarTrailingConstraint,
            toolbarBottomConstraint
        ])
    }

    private func observeKeyboard() {
        let keyboardWillShow = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { notification in
                (
                    keyboardFrame: notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
                    duration: notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
                )
            }
            .filter { $0.keyboardFrame != nil && $0.duration != nil }
            .map { ($0.keyboardFrame!.height, $0.duration!) }

        let keyboardWillHide = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .compactMap { notification in
                notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
            }
            .map { (CGFloat(0), $0) }

        keyboardWillShow
            .merge(with: keyboardWillHide)
            .sink { [weak self] keyboardHeight, duration in
                guard let self = self else { return }
                let bottomConstant = keyboardHeight > 0 ? -keyboardHeight - 8 : -8
                self.toolbarBottomConstraint.constant = bottomConstant

                UIView.animate(withDuration: duration) {
                    self.layoutIfNeeded()
                }
            }
            .store(in: &keyboardCancellables)
    }

    // MARK: - Text Formatting Actions

    @objc private func boldTapped() {
        insertMarkdown(prefix: "**", suffix: "**")
    }

    @objc private func italicTapped() {
        insertMarkdown(prefix: "*", suffix: "*")
    }

    @objc private func underlineTapped() {
        insertMarkdown(prefix: "<u>", suffix: "</u>")
    }

    @objc private func bulletListTapped() {
        insertListItem(prefix: "- ")
    }

    @objc private func numberedListTapped() {
        insertListItem(prefix: "1. ")
    }

    @objc private func increaseIndentTapped() {
        adjustIndent(increase: true)
    }

    @objc private func decreaseIndentTapped() {
        adjustIndent(increase: false)
    }

    @objc private func insertLinkTapped() {
        let alertController = UIAlertController(title: "Insert Link", message: "Enter the URL", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "https://example.com"
        }
        alertController.addAction(UIAlertAction(title: "Insert", style: .default) { [weak self] _ in
            if let url = alertController.textFields?.first?.text, !url.isEmpty {
                self?.insertMarkdown(prefix: "[", suffix: "](\(url))")
            }
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        if let parentViewController = self.parentViewController {
            parentViewController.present(alertController, animated: true)
        }
    }

    private func insertMarkdown(prefix: String, suffix: String) {
        guard let selectedRange = textView.selectedTextRange else { return }
        let selectedText = textView.text(in: selectedRange) ?? ""

        let replacement = prefix + selectedText + suffix
        textView.replace(selectedRange, withText: replacement)

        textView.selectedTextRange = textView.textRange(from: selectedRange.start, to: selectedRange.start)
    }

    private func insertListItem(prefix: String) {
        guard let selectedRange = textView.selectedTextRange,
              let currentText = textView.text else { return }

        let location = textView.offset(from: textView.beginningOfDocument, to: selectedRange.start)

        var insertPosition = location
        if location > 0 && currentText[currentText.index(currentText.startIndex, offsetBy: location - 1)] != "\n" {
            textView.selectedTextRange = selectedRange
            textView.replace(selectedRange, withText: "\n" + prefix)
            return
        }

        let selectedText = textView.text(in: selectedRange) ?? ""
        let replacement = prefix + selectedText
        textView.replace(selectedRange, withText: replacement)
    }

    private func adjustIndent(increase: Bool) {
        guard let selectedRange = textView.selectedTextRange,
              let currentText = textView.text else { return }

        let location = textView.offset(from: textView.beginningOfDocument, to: selectedRange.start)
        let length = textView.offset(from: selectedRange.start, to: selectedRange.end)

        var adjustedText = currentText
        let startIndex = currentText.index(currentText.startIndex, offsetBy: location)

        if increase {
            adjustedText.insert(contentsOf: "  ", at: startIndex)
        } else if location >= 2 && String(adjustedText[currentText.index(currentText.startIndex, offsetBy: location - 2)..<startIndex]) == "  " {
            let removeStart = currentText.index(currentText.startIndex, offsetBy: location - 2)
            let removeEnd = startIndex
            adjustedText.replaceSubrange(removeStart..<removeEnd, with: "")
        }

        textView.text = adjustedText

        let newPosition = textView.position(from: textView.beginningOfDocument, offset: increase ? location + 2 : max(location - 2, 0))!
        textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
    }

    var parentViewController: UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            responder = responder?.next
            if let viewController = responder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
