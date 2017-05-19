#!/usr/bin/env ruby
#
# Copyright 2017 Geoff Williams for Declarative Systems PTY LTD
# Copyright 2016 Geoff Williams for Puppet Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
module Arfor
  module ControlRepo
    WORKING_DIR       = 'puppet-control'
    UPSTREAM_EXAMPLE  = 'https://github.com/puppetlabs/control-repo'
    CLEANUP_FILES     = [
      'README.md',
      'LICENSE',
      'site/role/manifests/database_server.pp',
      'site/role/manifests/web_server.pp',
      'site/role/manifests/database_server.pp',
      'site/role/manifests/example.pp',
      'site/profile/manifests/example.pp',
    ]

    VENDORED_FILES    = '../../res/control_repo/.'
    CLEAN_RUBY        = "unset RUBYLIB GEM_HOME GEM_PATH RUBYOPT BUNDLE_GEMFILE; "

    # create a new contorl repository in a directory ./puppet-control
    def self.create()
      if File.exists?(WORKING_DIR)
        abort("Puppet control repository already exists at #{WORKING_DIR}")
      else
        # Step 1 - git clone of upstream puppet control repository
        system("git clone #{UPSTREAM_EXAMPLE} #{WORKING_DIR}")

        # Step 2 - crud cleanup
        CLEANUP_FILES.each { |f|
          # swallow errors relating to files that are no longer in upstream
          begin
            File.delete(f)
          rescue
          end
        }
        # ...And remove upstream git repo - not needed
        FileUtils.rm_rf(File.join(WORKING_DIR, '.git'))

        # Step 3 - Copy in files
        dir = File.join(File.dirname(File.expand_path(__FILE__)), VENDORED_FILES)
        FileUtils.cp_r(dir, WORKING_DIR)

        # Step 4 - Install onceover
        Dir.chdir(WORKING_DIR) {
          system("#{CLEAN_RUBY} bundle install")
          system("#{CLEAN_RUBY} bundle exec onceover init")

          # Step 5 - setup git
          system("git init")
          system("git checkout -b production")

          # Step 6 - initial git commit
          system("git add -A")
          system("git commit -m 'initial' ")
        }
      end
    end
  end
end
