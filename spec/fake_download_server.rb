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

require 'sinatra/base'
require 'webrick'
require 'webrick/log'
require "webrick/https"
require 'rack'

module FakeDownloadServer
  class FakeDownloadServer < Sinatra::Base

    get '/glorious_content.tar.gz' do
      "some glorious content"
    end

    get '/content.tar.gz' do
      'some content..'
    end

    get '/puppet-agent/*' do
      'A puppet agent :)'
    end
  end

  module WEBrick
    def self.run!
      webrick_options = {
        :Port                 => 9999,
        :Logger               => ::WEBrick::Log::new($stdout, ::WEBrick::Log::DEBUG),
      }

      Rack::Handler::WEBrick.run FakeDownloadServer, webrick_options
    end
  end

end