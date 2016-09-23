Pod::Spec.new do |spec|
  spec.name     = 'PagedUITableViewController'
  spec.version  = '0.0.1'
  spec.author   = { 'Sergio García' => 'sergiogm.amurrio@gmail.com' }
  spec.homepage = 'https://github.com/sergiog90/PagedUITableViewController'
  spec.summary  = 'Automatically manage pagination with custom loading cell that allows pagination across network calls with few code lines.'
  spec.license  = 'MIT'
  spec.source   = { :git => 'https://github.com/sergiog90/PagedUITableViewController.git', :tag => spec.version.to_s }
  spec.social_media_url = 'https://twitter.com/sergio_g90'
  spec.source_files = 'PagedUITableViewController'
  spec.platform = :ios
  spec.ios.deployment_target = '8.1'
  spec.requires_arc = true
  spec.frameworks = 'UIKit'
end