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
require 'fileutils'

module Arfor
  module AgentInstallers

    WINDOWS = [
      'x86',
      'x64',
    ]

    AGENT_INSTALLER_DIR = 'agent_installers'

    @@base_url = "https://pm.puppetlabs.com/puppet-agent"

    def self.base_url=(base_url)
      @@base_url = base_url
    end

    def self.base_url
      @@base_url
    end

    def self.download(pe_version, agent_version, supported_platforms, print_urls)

      base_url_agent    = "#{@@base_url}/#{pe_version}/#{agent_version}/repos"
      base_url_normal   = "#{base_url_agent}/puppet-agent-"
      base_url_windows  = "#{base_url_agent}/windows/puppet-agent-"
      suffix            = ".tar.gz"
      suffix_windows    = ".msi"
      download_dir      = "./#{AGENT_INSTALLER_DIR}/#{pe_version}"

      if ! Dir.exists?(download_dir)
        FileUtils.mkdir_p(download_dir)
      end
      Dir.chdir(download_dir) do
        supported_platforms.each { |platform|
          url = "#{base_url_normal}#{platform}#{suffix}"
          if print_urls
            puts url
          else
            Arfor::Download::get(url)
          end
        }

        WINDOWS.each { |platform|
          url = "#{base_url_windows}#{platform}#{suffix_windows}"
          if print_urls
            puts url
          else
            Arfor::Download::get(url)
          end
        }
      end
    end


  end
end
