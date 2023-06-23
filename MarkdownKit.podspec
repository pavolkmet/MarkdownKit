#
#  Be sure to run `pod spec lint MarkdownKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "MarkdownKit"
  spec.version      = "0.0.1"
  spec.summary      = "A Swift package for parsing, building, editing, and analyzing Markdown documents."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  spec.description  = <<-DESC
  Swift Markdown is a Swift package for parsing, building, editing, and analyzing Markdown documents.

  The parser is powered by GitHub-flavored Markdown's cmark-gfm implementation, so it follows the spec closely.
  As the needs of the community change, the effective dialect implemented by this library may change.
  
  The markup tree provided by this package is comprised of immutable/persistent, thread-safe, copy-on-write value types that only copy substructure that has changed. 
  Other examples of the main strategy behind this library can be seen in Swift's lib/Syntax and its Swift bindings, SwiftSyntax.
                   DESC

  spec.homepage  = "https://github.com/pavolkmet/MarkdownKit"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See https://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  spec.license = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  spec.author             = { "Pavol Kmet" => "pavolkmet@icloud.com" }
  spec.social_media_url   = "https://twitter.com/PavolKmet"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  spec.platform = :ios, "15.0"

  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  spec.source = { :git => "https://github.com/pavolkmet/PannarioKit-iOS.git", :tag => spec.version }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  # spec.preserve_paths = "Sources/MarkdownKit/**/*"
  # spec.source_files = 'Sources/MarkdownKit/**/*{.c,.h,.swift}'

  spec.default_subspecs = 'Core'

  spec.subspec 'Core' do |sp|
    
    sp.preserve_paths = "Sources/Core/**/*"
    sp.source_files = 'Sources/Core/**/*.swift'
    sp.dependency 'MarkdownKit/Markdown'
    
  end

  spec.subspec 'Markdown' do |sp|
    
    sp.preserve_paths = "Sources/Markdown/**/*"
    sp.source_files = 'Sources/Markdown/**/*.swift'
    sp.dependency 'MarkdownKit/CAtomic'
    sp.dependency 'MarkdownKit/cmark-gfm'
    sp.dependency 'MarkdownKit/cmark-gfm-extensions'
    
  end

  spec.subspec 'CAtomic' do |sp|
    
    sp.source_files = 'Sources/CAtomic/**/*{.c,.h}'
    sp.preserve_paths = 'Sources/CAtomic/**/*'
    sp.public_header_files = 'Sources/CAtomic/include/*.h'
    
  end

 spec.subspec 'cmark-gfm' do |sp|

   sp.source_files = 'Sources/cmark-gfm/**/*{.c,.h}'
   sp.preserve_paths = 'Sources/cmark-gfm/**/*'
   sp.public_header_files = 'Sources/cmark-gfm/include/*.h'
   sp.exclude_files = [
     'Sources/cmark-gfm/scanners.re',
     'Sources/cmark-gfm/libcmark-gfm.pc.in',
     'Sources/cmark-gfm/config.h.in',
     'Sources/cmark-gfm/CMakeLists.txt',
     'Sources/cmark-gfm/cmark-gfm_version.h.in',
     'Sources/cmark-gfm/case_fold_switch.inc',
     'Sources/cmark-gfm/entities.inc'
   ]

 end

 spec.subspec 'cmark-gfm-extensions' do |sp|

   sp.source_files = 'Sources/cmark-gfm-extensions/**/*{.c,.h}'
   sp.preserve_paths = 'Sources/cmark-gfm-extensions/**/*'
   sp.public_header_files = 'Sources/cmark-gfm-extensions/include/*.h'
   sp.exclude_files = [
     'Sources/cmark-gfm-extensions/CMakeLists.txt',
     'Sources/cmark-gfm-extensions/ext_scanners.re'
   ]

 end

  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

end
