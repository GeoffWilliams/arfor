require "spec_helper"
require "arfor/download"
require 'pp'
require "fakefs/safe"

describe Arfor::Download do

  after do
    FakeFS::FileSystem.clear
  end

  it "downloads a file and renames it on success" do
    FakeFS do
      # nasty hack - create a tempfile inside the fakefs to simulate what our
      # wget command would have done.  We can't do this through the fake exe
      # itself since it doesn't have access to the fake filesystem and attempts
      # to write to the real one instead ;-)
      dlfile = 'content.tar.gz'
      tempfile = dlfile + Arfor::Download::TEMP_EXT
      FileUtils.touch(tempfile)
      Arfor::Download::get("#{FAKE_DOWNLOAD_SERVER}/#{dlfile}")
      dlfile_exists = File.exists?(dlfile)
      tempfile_exists = File.exists?(tempfile)

      expect(dlfile_exists).to be true
      expect(tempfile_exists).to be false
    end
  end

  it "removes files on failures" do
    FakeFS do
      dlfile = 'nothere.tar.gz'
      tempfile = dlfile + Arfor::Download::TEMP_EXT

      begin
        # will throw exection due to missing file (expected to happen)
        Arfor::Download::get("#{FAKE_DOWNLOAD_SERVER}/#{dlfile}")
      rescue
        dlfile_exists = File.exists?(dlfile)
        tempfile_exists = File.exists?(tempfile)

        expect(dlfile_exists).to be false
        expect(tempfile_exists).to be false
      end
    end
  end

end
