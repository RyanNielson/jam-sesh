name             "basic-rails-env"
maintainer       "Ryan Nielson"
maintainer_email "ryan.nielson@gmail.com"
license          "MIT"
description      "Installs and configures a basic Rails environment."
version          "1.0.0"

%w{ ubuntu }.each do |os|
  supports os
end

#%w{ git rbenv postgresql }.each do |cb|

#%w{ rbenv postgresql }.each do |cb|
#  depends cb
#end