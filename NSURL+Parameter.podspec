Pod::Spec.new do |s|
  s.name         = 'NSURL+Parameter'
  s.version      = '0.1'
  s.summary      = 'NSURL initialization with parameter objects'
  s.description  = <<-DESC
                 NSURL initialization with a url string and a NSDictionary for the query string.
                 The values of the key-values in the NSDictionary should be NSString, NSDictionary, NSArray or NSSet.
DESC
  s.homepage     = 'https://github.com/ttsubono/NSURL-Parameter'
  s.license      = 'MIT'
  s.author       = { "Takahiro Tsubono" => "tsubono@gmail.com" }
  s.source       = { :git => 'https://github.com/ttsubono/NSURL-Parameter.git',
                     :tag => "v#{s.version}" }
  s.ios.deployment_target = '6.0'
  #s.osx.deployment_target = '10.8' // haven't tested
  s.requires_arc = true
  s.source_files = 'NSURL+Parameter/*.{h,m}'
end
