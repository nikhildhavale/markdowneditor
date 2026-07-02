# RichTextEditor - Setup & Architecture

## Project Structure

```
MarkdownEditor/
├── Sources/RichTextEditor/           # SPM/Pod source code
│   ├── RichTextEditor.swift          # Main editor component
│   ├── UITextViewExtension.swift     # Placeholder text support
│   └── ComposeViewController.swift   # Example usage
├── MarkdownEditor/                   # Xcode demo app (optional)
│   ├── ViewController.swift
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
├── Package.swift                     # Swift Package Manager manifest
├── RichTextEditor.podspec           # CocoaPods specification
├── README.md                         # User documentation
└── SETUP.md                          # This file
```

## Installation

### Option 1: Swift Package Manager (SPM)

#### Via Xcode UI
1. File → Add Packages
2. Enter: `https://github.com/nikhildhavale/markdowneditor.git`
3. Select version constraint and add to target

#### Via Package.swift
```swift
dependencies: [
    .package(url: "https://github.com/nikhildhavale/markdowneditor.git", from: "1.0.0")
]
```

#### Via Command Line
```bash
cd your-project
swift package add RichTextEditor
```

### Option 2: CocoaPods

```bash
# Add to Podfile
pod 'RichTextEditor', '~> 1.0.0'

# Install
pod install
```

## Architecture

### Core Component: RichTextEditor

A `UIView` subclass that combines a `UITextView` with a floating toolbar.

**Key Features:**
- **Toolbar Position**: Bottom-right, floats above keyboard
- **Keyboard Management**: Uses Combine publishers for reactive updates
- **Text Formatting**: Markdown-based (wraps selected text with markers)
- **8 Formatting Controls**:
  1. Bold: `**text**`
  2. Italic: `*text*`
  3. Underline: `<u>text</u>`
  4. Bulleted List: `- item`
  5. Numbered List: `1. item`
  6. Increase Indent: `  ` (2 spaces)
  7. Decrease Indent: remove `  `
  8. Insert Link: `[text](url)`

### Keyboard Management with Combine

The editor uses Combine to observe keyboard events:

```swift
// Publishes keyboard visibility + animation duration
NotificationCenter.default
    .publisher(for: UIResponder.keyboardWillShowNotification)
    // Extract height and duration
    // Merge with keyboardWillHideNotification
    // Update toolbar position with animation
    .sink { /* update constraints */ }
    .store(in: &keyboardCancellables)
```

This approach is:
- **Reactive**: Responds to keyboard state changes automatically
- **Animated**: Synchronizes with keyboard animation
- **Memory-safe**: Uses cancellables for proper cleanup

## Usage

### Basic Integration

```swift
import RichTextEditor

class MyViewController: UIViewController {
    let editor = RichTextEditor()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add to view
        editor.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(editor)
        
        // Constrain to available space
        NSLayoutConstraint.activate([
            editor.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            editor.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            editor.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            editor.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
        // Optional: Set placeholder
        editor.textView.placeholder = "Your placeholder text"
    }
}
```

### Getting the Content

```swift
// Get markdown text
let text = editor.textView.text

// Listen for changes
NotificationCenter.default.addObserver(
    forName: UITextView.textDidChangeNotification,
    object: editor.textView,
    queue: .main
) { _ in
    print("Text: \(editor.textView.text)")
}
```

### Customization

```swift
// Customize text view
editor.textView.font = .systemFont(ofSize: 18, weight: .light)
editor.textView.textColor = .label

// Customize toolbar
editor.toolbar.backgroundColor = .systemBackground
```

## Behavior Details

### Formatting Behavior

When a formatting button is tapped:

1. **With Selection**: Wraps selected text
   - Text: `hello` → Bold → `**hello**`

2. **Without Selection**: Inserts empty markers
   - Cursor position preserved for typing

3. **List Operations**: 
   - Creates new line if not at line start
   - Inserts list prefix at current position

4. **Link Insert**: 
   - Shows alert for URL input
   - Wraps selected text: `[selected](https://url.com)`

### Keyboard Interaction

- **Show**: Toolbar slides up with keyboard (synchronized animation)
- **Hide**: Toolbar slides down when keyboard dismisses
- **Offset**: 8pt padding above keyboard

## Requirements

- **iOS**: 13.0+
- **Swift**: 5.5+
- **Frameworks**: UIKit, Combine

## Distribution

### For SPM Users
- Ensure `Package.swift` is at repo root
- Source files in `Sources/RichTextEditor/`
- Supports iOS 13.0+

### For CocoaPods Users
- `.podspec` defines the library
- Excludes `Package.swift` from distribution
- Maps `Sources/RichTextEditor/` → `source_files`

## Development

### Building Locally

```bash
# Test with SPM
swift build

# Test with Xcode (demo app)
open MarkdownEditor.xcodeproj
```

### Testing

The demo app (`MarkdownEditor/ViewController.swift`) shows basic usage.

## Future Enhancements

Possible additions (not yet implemented):
- Rich text (NSAttributedString) support
- Custom toolbar button styling
- Code block formatting
- Strikethrough
- Blockquote
- Inline code
- Image insertion
- Auto-link detection

## License

MIT License
