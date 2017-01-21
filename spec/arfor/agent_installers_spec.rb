require "spec_helper"
require "arfor/agent_installers"
require "arfor/download"
require "pp"
require "fakefs/safe"

describe Arfor::AgentInstallers do

  after do
    ENV['PATH'] = PATH_ORIG
    FakeFS::FileSystem.clear
  end

  it "downloads the installers without erroring" do
    ENV['PATH'] = "#{WGET_PATH_PASSES}:#{ENV['PATH']}"

    FakeFS do
      # even nastier hack - see notes in download_spec.rb
      workdir = File.join(Arfor::AgentInstallers::AGENT_INSTALLER_DIR, PE_VERSION)
      FileUtils.mkdir_p(workdir)
      Dir.chdir(workdir) {
        # normal platforms
        Arfor::AgentInstallers::PLATFORMS.each { |platform|
          tempfile = "puppet-agent-#{platform}.tar.gz#{Arfor::Download::TEMP_EXT}"
          FileUtils.touch(tempfile)
        }

        # windows...
        Arfor::AgentInstallers::WINDOWS.each { |arch|
          tempfile = "puppet-agent-#{arch}.msi#{Arfor::Download::TEMP_EXT}"
          FileUtils.touch(tempfile)
        }
      }
      Arfor::AgentInstallers.download(PE_VERSION, AGENT_VERSION)
    end
  end

end
