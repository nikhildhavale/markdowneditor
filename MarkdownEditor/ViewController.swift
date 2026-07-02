//
//  ViewController.swift
//  MarkdownEditor
//
//  Created by Nikhil Dhavale on 02/07/26.
//

import UIKit

class ViewController: UIViewController {
    let richTextEditor = RichTextEditor()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        title = "Markdown Editor"
        view.backgroundColor = .systemBackground

        richTextEditor.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(richTextEditor)

        NSLayoutConstraint.activate([
            richTextEditor.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            richTextEditor.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            richTextEditor.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            richTextEditor.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])

        richTextEditor.textView.placeholder = "Start typing..."
    }
}

