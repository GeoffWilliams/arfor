#!/usr/bin/env ruby
#
# Copyright 2017 Geoff Williams for Declarative Systems PTY LTD.
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
require 'etc'
module Arfor
  module PlatformInstaller
    BASE_URL        = "https://pm.puppetlabs.com/cgi-bin/download.cgi?"
    LICENCE_FILE    = "#{Etc.getpwuid.dir}/.arfor/licence.key"
    BASE_TARGET     = "puppet-enterprise-"
    SUFFIX_TARGET   = ".tar.gz"

    DEFAULT_VERSION = "2017.1.0"
    DEFAULT_DIST    = "el"
    DEFAULT_REL     = "7"
    DEFAULT_ARCH    = "x86_64"

    def self.licence_check
      licenced = false
      if File.exist?(LICENCE_FILE)
        licenced = File.foreach(LICENCE_FILE).grep(/thanks for registering/)
      end

      if ! licenced
        abort("Missing or invalid ArFour licence detected - email sales@declarativesystems.com to obtain one")
      end
      licenced
    end


    def self.download(version, dist, rel, arch)
      licence_check

      version = version || DEFAULT_VERSION
      dist    = dist || DEFAULT_DIST
      rel     = rel || DEFAULT_REL
      arch    = arch || DEFAULT_ARCH
      url     = "#{BASE_URL}&dist=#{dist}&rel=#{rel}&arch=#{arch}&version=#{version}"

      target_file = "#{BASE_TARGET}#{version}-#{dist}-#{rel}-#{arch}#{SUFFIX_TARGET}"

      Arfor::Download::get(url, target_file)
    end
  end
end
