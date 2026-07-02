# RichTextEditor

A UIKit-based rich text editor component with a floating toolbar that appears in the bottom-right and moves with the keyboard.

## Features

- **8 Formatting Controls**:
  - Bold (`**text**`)
  - Italic (`*text*`)
  - Underline (`<u>text</u>`)
  - Bulleted List (`- `)
  - Numbered List (`1. `)
  - Increase Indent
  - Decrease Indent
  - Insert Link (`[text](url)`)

- **Floating Toolbar**: Positioned at the bottom-right, automatically moves up with the keyboard
- **Keyboard Management**: Uses Combine for reactive keyboard height tracking
- **Markdown Support**: Outputs markdown-formatted text
- **iOS 13+**: Built with UIKit and Combine

## Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/nikhildhavale/markdowneditor.git", from: "1.0.0")
]
```

Or in Xcode:
1. File → Add Packages
2. Enter: `https://github.com/nikhildhavale/markdowneditor.git`
3. Select version and add to your target

### CocoaPods

Add to your `Podfile`:

```ruby
pod 'RichTextEditor', '~> 1.0.0'
```

Then run:
```bash
pod install
```

## Usage

### Basic Setup

```swift
import UIKit
import RichTextEditor

class ViewController: UIViewController {
    let editor = RichTextEditor()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        editor.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(editor)
        
        NSLayoutConstraint.activate([
            editor.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            editor.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            editor.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            editor.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
        editor.textView.placeholder = "Start typing..."
    }
}
```

### Accessing the Text

```swift
// Get markdown text
let markdownText = editor.textView.text

// Listen for text changes
NotificationCenter.default.addObserver(
    forName: UITextView.textDidChangeNotification,
    object: editor.textView,
    queue: .main
) { _ in
    let text = editor.textView.text ?? ""
    print("Text changed: \(text)")
}
```

## Customization

### Styling

The editor and toolbar are fully customizable through their properties:

```swift
// Text view styling
editor.textView.font = .systemFont(ofSize: 18)
editor.textView.textColor = .label

// Toolbar styling
editor.toolbar.backgroundColor = .systemGray5
```

## Layout Details

- **Toolbar Width**: 280pt
- **Toolbar Height**: 56pt
- **Button Height**: 36pt
- **Spacing**: 8pt between buttons
- **Positioning**: Bottom-right of the editor, moves up with keyboard

## Minimum Requirements

- iOS 13.0+
- Swift 5.5+

## License

MIT License
