Pod::Spec.new do |s|
 s.name = 'STPhotoMap'
 s.version = '0.0.1'
 s.license = { :type => "MIT", :file => "LICENSE" }
 s.summary = 'A map that displays photos'
 s.homepage = 'https://github.com/mikelanza/st-photo-map-ios.git'
 s.social_media_url = 'https://twitter.com/ '
 s.authors = { "Streetography" => "mike@lanza.net" }
 s.source = { :git => "https://github.com/mikelanza/STPhotoMap.git", :tag => "v"+s.version.to_s }
 s.platforms = { :ios => "11.0", :osx => "10.10", :tvos => "9.0", :watchos => "2.0" }
 s.requires_arc = true

 s.default_subspec = "Core"
 s.subspec "Core" do |ss|
     ss.source_files  = "Sources/**/*.swift"
     ss.framework  = "Foundation"
 end
end
