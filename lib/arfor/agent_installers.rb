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

    # platforms list obtained by running
    # cd /opt/puppetlabs/puppet/modules/pe_repo/manifests
    # cat platform/*.pp | grep pe_repo::
    # on a puppet enterprise master - you will have to clean up the output...

    PLATFORMS = [
      'aix-5.3-power',
      'aix-6.1-power',
      'aix-7.1-power',
      'debian-7-amd64',
      'debian-7-i386',
      'debian-8-amd64',
      'debian-8-i386',
      'el-4-i386',
      'el-4-x86_64',
      'el-5-i386',
      'el-5-x86_64',
      'el-6-i386',
      'el-6-s390x',
      'el-6-x86_64',
      'el-7-s390x',
      'el-7-x86_64',
      'fedora-22-i386',
      'fedora-22-x86_64',
      'fedora-23-i386',
      'fedora-23-x86_64',
      'fedora-24-i386',
      'fedora-24-x86_64',
      'osx-10.10-x86_64',
      'osx-10.11-x86_64',
      'sles-10-i386',
      'sles-10-x86_64',
      'sles-11-i386',
      'sles-11-s390x',
      'sles-11-x86_64',
      'sles-12-s390x',
      'sles-12-x86_64',
      'solaris-10-i386',
      'solaris-10-sparc',
      'solaris-11-i386',
      'solaris-11-sparc',
      'ubuntu-10.04-amd64',
      'ubuntu-10.04-i386',
      'ubuntu-12.04-amd64',
      'ubuntu-12.04-i386',
      'ubuntu-14.04-amd64',
      'ubuntu-14.04-i386',
      'ubuntu-16.04-amd64',
      'ubuntu-16.04-i386',
    ]

    WINDOWS = [
      'x86',
      'x64',
    ]

    def self.download(pe_version, agent_version)
      base_url          = "https://pm.puppetlabs.com/puppet-agent/#{pe_version}/#{agent_version}/repos"
      base_url_normal   = "#{base_url}/puppet-agent-"
      base_url_windows  = "#{base_url}/windows/puppet-agent-"
      suffix            = ".tar.gz"
      suffix_windows    = ".msi"
      download_dir      = "./agent_installers/#{pe_version}"

      if ! Dir.exists?(download_dir)
        FileUtils.mkdir_p(download_dir)
      end
      Dir.chdir(download_dir) do
        PLATFORMS.each { |platform|
          url = "#{base_url_normal}#{platform}#{suffix}"
          Arfor::Download::get(url)
        }

        windows.each { |platform|
          url = "#{base_url_windows}#{platform}#{suffix_windows}"
          Arfor::Download::get(url)
        }
      end
    end

    def self.inspect(tarball)
      if tarball =~ /puppet-enterprise-\d{4}\.\d+\.\d+.*\.tar\.gz/
        if File.exists?(tarball)

          # capture the main version
          pe_version = tarball.match(/puppet-enterprise-(\d{4}\.\d+\.\d+)/).captures.first

          # look for the agent version
          agent_package = %x(tar ztf #{tarball} '**/puppet-agent*')
          agent_version = agent_package.match(/puppet-agent-(\d+\.\d+\.\d+)/).captures.first
        else
          Escort::Logger.error.error "File not found: #{tarball}"
        end
      else
        Escort::Logger.error.error "Not a puppet install tarball: #{tarball}"
      end
      return pe_version, agent_version
    end

  end
end
