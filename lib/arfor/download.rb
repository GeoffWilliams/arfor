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
require 'ruby-progressbar'

module Arfor
  module Download

    WRAP      = 60
    TEMP_EXT  = '.tmp'

    def self.resolve_url(url,limit = 10)
      url_resolved = false
      file_size = -1

      raise ArgumentError, 'HTTP redirect too deep' if limit == 0
      uri = URI.parse(url)
      Net::HTTP.start(uri.host, uri.port, :use_ssl=>(uri.scheme == 'https')) { |http|
        http.read_timeout = 1000
        resp  = http.head(url)


        file_size = resp['content-length']

        case resp
        when Net::HTTPSuccess
          url_resolved = url
        when Net::HTTPRedirection
          url_resolved, file_size = resolve_url(resp['location'], limit - 1)
        else
          resp.error!
        end
      }

      return url_resolved, file_size
    end


    def self.get(url)
      resolved_url, file_size = resolve_url(url)

      uri = URI.parse(resolved_url)
      target_file = File.basename(uri.path)
      tempfile = target_file + TEMP_EXT

      # check if the resolved filename exists locally - this will work even when
      # user hits the download url that includes ver=latest since we resolve to
      # the real filenam
      if ! File.exists?(target_file)
        progressbar = ProgressBar.create(:title => target_file)
        Net::HTTP.start(uri.host, uri.port, :use_ssl=>true) do |http|
          request = Net::HTTP::Get.new uri


          http.request request do |resp|
            puts "Downloading: #{resolved_url}"
            downloaded_bytes = 0
            File.open tempfile, 'wb' do |io|
              resp.read_body do |chunk|
                downloaded_bytes += chunk.size
                percent_complete = (downloaded_bytes.to_f / file_size.to_i) * 100

                io.write chunk
                progressbar.progress=(percent_complete)
              end
            end
          end
        end

        if File.exist?(tempfile)
          # get to here without erroring then safe to move
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
