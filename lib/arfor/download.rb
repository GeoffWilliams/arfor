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

require 'uri'

module Arfor
  module Download
    def self.get(url)
      uri = URI.parse(url)
      filename = File.basename(uri.path)
      if ! File.exists?(File.join(Dir.pwd, filename))
        puts "Downloading #{url}"
        system("wget #{url}")
      else
        puts "installer for #{filename} already downloaded"
      end
    end

    def self.gem(gem)
      system("gem fetch #{gem}")
    end
  end
end
