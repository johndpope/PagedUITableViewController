Pod::Spec.new do |s|
  s.name             = 'PagedUITableViewController'
  s.version          = '0.0.2'
  s.summary          = 'Automatically manage pagination with custom loading cell that allows pagination across network calls with few code lines.'
  s.description      = <<-DESC
UITableViewController subclass that automatically manages pagination with custom loading cell and network request delegation on your current controller.

Allows cells deletion and dataset reload for update all data to initial state.
                       DESC

  s.homepage         = 'https://github.com/sergiog90/PagedUITableViewController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Sergio García' => 'sergiogm.amurrio@gmail.com' }
  s.source           = { :git => 'https://github.com/sergiog90/PagedUITableViewController.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/sergio_g90'
  s.ios.deployment_target = '8.1'
  s.source_files = 'PagedUITableViewController/Classes/**/*'
  s.frameworks = 'UIKit'
end
