
Pod::Spec.new do |s|

s.name         = "XHSegmentView"
s.version      = "1.0.0"
s.summary      = "XHSegmentView."
s.description  = <<-DESC
                a view like segment on github;
				DESC
s.homepage     = "https://github.com/chengxianghe/XHSegmentView.git"
s.license      = "MIT"
s.author       = { "chengxianghe" => "chengxianghe@outlook.com" }
s.source       = { :git => "https://github.com/chengxianghe/XHSegmentView.git", :tag => s.version }
s.platform     = :ios, "7.0"

s.source_files  = "XHSegmentView/XHSegmentView/*"

s.frameworks = 'Foundation', 'UIKit'

s.requires_arc = true

end
