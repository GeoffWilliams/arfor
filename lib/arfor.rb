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

require "arfor/version"
require "etc"

module Arfor
  # Your code goes here...
  CONFIG_DIR    = "#{Etc.getpwuid.dir}/.arfor"
  LICENCE_FILE  = "#{CONFIG_DIR}/licence.key"
  TOKEN_FILE    = "#{CONFIG_DIR}/github_token"
  TRAVIS_CONF   = "#{Etc.getpwuid.dir}/.travis/config.yml"
  QUESTION      = "🤖"
  OK            = "👍"
  ERROR         = "💩"

end
