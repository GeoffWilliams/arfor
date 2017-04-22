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
require 'fileutils'
require 'net/http'

module Arfor
  module Download

    WRAP      = 60
    TEMP_EXT  = '.tmp'

    def self.get(url, target_file=false)
      uri = URI.parse(url)
      filename = File.basename(uri.path)
      if ! File.exists?(File.join(Dir.pwd, filename))
        puts "Downloading #{url}"
        uri = URI.parse(url)

        # user didn't supply a filename to save final file as so just use one
        # based on the url
        if ! target_file
          target_file = File.basename(uri.path)
        end
        tempfile = target_file + TEMP_EXT
        # download to a temporary file and rename to the real file only if
        # download succeeded based on exit code.  Prevents using truncated
        # files as 'real' files by accident if download times out (sigh) or
        # user cancels.

        i = 0
        Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
          resp = http.get(uri)
          open(target_file, "wb") do |file|
            print "."
            if i %= WRAP
              print "\n"
            end
            file.write(resp.body)
          end
        end

        if system("wget #{url} -o #{tempfile}")
          FileUtils.mv(tempfile, target_file)
        end
        # remove any stray tempfiles that remain
        FileUtils.rm_f(tempfile)
      else
        puts "installer for #{filename} already downloaded"
      end
    end

    def self.gem(gem)
      system("gem fetch #{gem}")
    end
  end
end
