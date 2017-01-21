$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "arfor"
PATH_ORIG         = ENV['PATH']
WGET_PATH_PASSES  = File.join('spec', 'fixtures', 'fake_bin', 'passes')
WGET_PATH_FAILS   = File.join('spec', 'fixtures', 'fake_bin', 'fails')
PE_VERSION        = "xxxx.x.x"
AGENT_VERSION     = "y.y.y"
