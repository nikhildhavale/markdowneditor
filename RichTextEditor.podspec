Pod::Spec.new do |spec|
  spec.name         = "RichTextEditor"
  spec.version      = "1.0.0"
  spec.summary      = "A rich text editor component with markdown formatting support"
  spec.description  = "RichTextEditor is a UIView-based component that provides a text editor with a toolbar containing 8 formatting controls: Bold, Italic, Underline, Bulleted list, Numbered list, Increase indent, Decrease indent, and Insert link."

  spec.homepage     = "https://github.com/nikhildhavale/markdowneditor"
  spec.license      = { :type => "MIT" }
  spec.author       = { "Nikhil Dhavale" => "nikhild@mangospring.com" }

  spec.platform     = :ios, "13.0"
  spec.source       = { :git => "https://github.com/nikhildhavale/markdowneditor.git", :tag => "#{spec.version}" }
  spec.source_files = "Sources/RichTextEditor/**/*.swift"
  spec.exclude_files = "Package.swift"

  spec.swift_version = "5.5"
  spec.requires_arc = true
end
