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
require 'octokit'
require "highline/import"
require "arfor/util/github"
require "json"

module Arfor
  module GithubModule
    PUPPET_METADATA = 'metadata.json'
    README_FILE     = 'README.md'
    README_ERB      = "../../res/puppet_module/#{README_FILE}.erb"

    def self.create()

      # http://stackoverflow.com/a/2889747/3441106
      forge_name  = ask("#{Arfor::QUESTION} Forge module name: ") do |q|
        q.validate = /[\w_]+-[\w_]+/
      end
      description = ask("#{Arfor::QUESTION} Module description: ")

      forge_name_split  = forge_name.split('-')
      forge_user        = forge_name_split[0]
      module_name       = forge_name_split[1]

      git_name    = "puppet-#{module_name}"

      git_opts    = {
        :description => description,
      }

      # Step 1 - generate puppet module
      if system("puppet module generate --skip-interview #{forge_name}")

        Dir.chdir(module_name) {

          # temporary ;-) fix for needing to replace the Gemfile
          File.delete('Gemfile')

          # Step 2 - install PDQtest
          system("pdqtest init")

          # Step 3 - make remote git repo
          begin
            resp = Arfor::Util::Github::create_repository(git_name, git_opts)
            full_name = resp.full_name
          rescue Octokit::UnprocessableEntity => e
            raise "Repository creation error:  #{e.message}"
          end

          # Step 4 - doco template
          template  = File.read(File.join(File.dirname(File.expand_path(__FILE__)), README_ERB))
          content   = ERB.new(template, nil, '-').result(binding)
          File.write(README_FILE, content)

          # Step 5 - checkout local copy of git repo, merge changes and upload
          system("git init && git remote add origin #{resp.clone_url}")

          # Step 6 - update puppet metdata.json with settings from git
          metadata = JSON.parse(File.read(PUPPET_METADATA))
          metadata['source']      = resp.clone_url
          metadata['project_url'] = resp.clone_url
          metadata['issues_url']  = resp.issues_url
          metadata['summary']     = description
          File.write(PUPPET_METADATA, JSON.pretty_generate(metadata))

          # Step 7 - cleanup backup crud files
          Dir.glob("**/*.pdqtest_old").each { |f|
            File.delete(f)
          }

          # Step 8 - Enable travis (you need to have already logged yourself in)
          # the sleep is to allow time for the apis to settle before travis does
          # its scans
          puts "sleep for sync"
          sleep(30)
          system("travis enable --no-interactive")

          # Step 9 - initial git commit and upload changes
          system("git add -A && git commit -m 'initial' && git push origin master")
        }
      else
        raise "module generation error"
      end

      Arfor::OK
    end


  end
end
