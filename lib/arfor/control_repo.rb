#!/usr/bin/env ruby
#
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
      'LICENSE'
    ]

    VENDORED_FILES    = '../../res/control_repo/.'

    # create a new contorl repository in a directory ./puppet-control
    def self.create()
      if File.exists?(WORKING_DIR)
        abort("Puppet control repository already exists at #{WORKING_DIR}")
      else
        # Step 1 - git clone of upstream puppet control repository
        system("git clone #{UPSTREAM_EXAMPLE} #{WORKING_DIR}")

        # Step 2 - crud cleanup
        CLEANUP_FILES.each { |f|
          File.rm(f)
        }

        # Step 3 - Copy in files
        dir = File.join(File.dirname(File.expand_path(__FILE__)), VENDORED_FILES)
        FileUtils.cp_r(dir, WORKING_DIR)

        # Step 4 - Install onceover
        Dir.chdir(WORKING_DIR) {
          system("bundle install")
          system("bundle exec onceover init")

          # Step 5 - setup git
          system("git init")
          system("git checkout -b production")
        }
      end
    end
  end
end
