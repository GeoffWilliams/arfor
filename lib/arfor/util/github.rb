#!/usr/bin/env ruby
#
# Copyright 2017 Geoff Williams for Declarative Systems PTY LTD
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

require "highline/import"

module Arfor
  module Util
    module Github

      def self.read_token
        if File.exists?(Arfor::TOKEN_FILE)
          token = File.read(Arfor::TOKEN_FILE)
        else
          token = ask "#{Arfor::QUESTION} Github token (https://github.com/settings/tokens/new): "
          write_token(token)
        end

        token
      end

      def self.write_token(token)
        File.write(Arfor::TOKEN_FILE, token)
      end

      def self.create_repository(git_name, git_opts)
        puts "creating #{git_name}"
        client = Octokit::Client.new(:access_token => read_token)
        # user = client.user
        # puts user.login
        resp = client.create_repository(git_name, git_opts)

        resp
      end
    end
  end
end
