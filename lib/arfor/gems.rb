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

require 'arfor/download'
module Arfor
  module Gems
    STANDARD_GEMS = [
      'escort',
      'hiera-eyaml',
      'highline',
      'http-cookie',
      'mime-types',
      'mime-types-data',
      'nesty',
      'netrc',
      'pe_rbac',
      'puppetclassify',
      'rest-client',
      'trollop',
      'unf',
      'unf_ext',
    ]

    GEM_DIR = 'gems'

    def self.download(gems = STANDARD_GEMS)
      FileUtils.mkdir_p(GEM_DIR)
      Dir.chdir(GEM_DIR) { |dir|
        gems.each { |gem|
          Arfor::Download::gem(gem)
        }
      }
    end
  end
end
