Pod::Spec.new do |s|
 s.name = 'STPhotoMap'
 s.version = '0.1.5'
 s.license = { :type => "MIT", :file => "LICENSE" }
 s.summary = 'A map that displays photos'
 s.homepage = 'https://streetography.com'
 s.social_media_url = 'https://streetography.com'
 s.authors = { "Streetography" => "mike@lanza.net" }
 s.source = { :git => "https://github.com/mikelanza/st-photo-map-ios.git", :tag => s.version.to_s }
 s.platforms = { :ios => "11.0" }
 s.requires_arc = true
 s.swift_versions = ['5.0']

 s.default_subspec = "Core"
 s.subspec "Core" do |ss|
     ss.source_files = "Sources/**/*.swift"
     ss.resource_bundles = { "STPhotoMap" => ["Sources/**/*.{lproj,xcassets}"] }
     ss.dependency "Kingfisher", "~> 5.0"
     ss.dependency "STPhotoCore", "~> 0.1.4"
     ss.dependency "STPhotoDetails", "~> 0.1.0"
     ss.dependency "STPhotoCollection", "~> 0.1.2"
     ss.framework = "Foundation"
 end

end
