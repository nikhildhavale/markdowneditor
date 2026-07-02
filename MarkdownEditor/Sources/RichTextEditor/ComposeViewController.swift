import UIKit

/// Example view controller showing how to use RichTextEditor in a compose dialog.
public class ComposeViewController: UIViewController {
    let editor = RichTextEditor()
    let sendButton = UIButton(type: .system)
    let cancelButton = UIButton(type: .system)

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        title = "Compose"
        view.backgroundColor = .systemBackground

        setupNavigationButtons()
        setupEditor()
        setupConstraints()
    }

    private func setupNavigationButtons() {
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)

        sendButton.setTitle("Send", for: .normal)
        sendButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendButton)
    }

    private func setupEditor() {
        editor.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(editor)

        editor.textView.placeholder = "What's on your mind?"
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            editor.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            editor.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            editor.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            editor.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    @objc private func sendTapped() {
        let markdownText = editor.textView.text
        print("Sending: \(markdownText)")
        dismiss(animated: true)
    }

    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
}
