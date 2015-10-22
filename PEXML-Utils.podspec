Pod::Spec.new do |s|
  s.name         = "PEXML-Utils"
  s.version      = "1.0.2"
  s.license      = "MIT"
  s.summary      = "A collection of XML helper functions."
  s.author       = { "Paul Evans" => "evansp2@gmail.com" }
  s.homepage     = "https://github.com/evanspa/#{s.name}"
  s.source       = { :git => "https://github.com/evanspa/#{s.name}.git", :tag => "#{s.name}-v#{s.version}" }
  s.platform     = :ios, '8.4'
  s.source_files = '**/*.{h,m}'
  s.public_header_files = '**/*.h'
  s.exclude_files = "**/*Tests/*.*"
  s.requires_arc = true
  s.dependency 'KissXML', '~> 5.0'
  s.dependency 'PEObjc-Commons', '~> 1.0.72'
  s.xcconfig     = { 'HEADER_SEARCH_PATHS' => '"$(SDKROOT)/usr/include/libxml2"' }
end
