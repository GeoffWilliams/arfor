require "spec_helper"
require "arfor/download"
require 'pp'
require "fakefs/safe"

describe Arfor::Download do
  # PATH_ORIG         = ENV['PATH']
  # WGET_PATH_PASSES  = File.join('spec', 'fixtures', 'fake_bin', 'passes')
  # WGET_PATH_FAILS   = File.join('spec', 'fixtures', 'fake_bin', 'fails')


  after do
    ENV['PATH'] = PATH_ORIG
    FakeFS::FileSystem.clear
  end

  it "downloads a file and renames it on success" do
    ENV['PATH'] = "#{WGET_PATH_PASSES}:#{ENV['PATH']}"
    FakeFS do
      # nasty hack - create a tempfile inside the fakefs to simulate what our
      # wget command would have done.  We can't do this through the fake exe
      # itself since it doesn't have access to the fake filesystem and attempts
      # to write to the real one instead ;-)
      dlfile = 'content.tar.gz'
      tempfile = dlfile + Arfor::Download::TEMP_EXT
      FileUtils.touch(tempfile)
      Arfor::Download::get("http://some/wonderous/#{dlfile}")
      dlfile_exists = File.exists?(dlfile)
      tempfile_exists = File.exists?(tempfile)

      expect(dlfile_exists).to be true
      expect(tempfile_exists).to be false
    end
  end

  it "removes files on failures" do
    ENV['PATH'] = "#{WGET_PATH_FAILS}:#{ENV['PATH']}"
    # nasty hack, see above

    FakeFS do
      dlfile = 'content.tar.gz'
      tempfile = dlfile + Arfor::Download::TEMP_EXT
      FileUtils.touch(tempfile)
      Arfor::Download::get("http://some/wonderous/#{dlfile}")
      dlfile_exists = File.exists?(dlfile)
      tempfile_exists = File.exists?(tempfile)

      expect(dlfile_exists).to be false
      expect(tempfile_exists).to be false
    end
  end

end
