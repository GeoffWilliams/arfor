$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "arfor"
require 'fake_download_server'

Thread.start { FakeDownloadServer::WEBrick.run! }

PE_VERSION = "2016.4.2"
AGENT_VERSION = "1.8.2"
FAKE_DOWNLOAD_SERVER = "http://localhost:9999"
