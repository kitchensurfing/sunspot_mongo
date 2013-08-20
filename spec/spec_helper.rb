require "rails"
require 'forwardable'
require 'sunspot/rails/spec_helper'
require "sunspot_mongo"
require "mongoid"

# Load support files
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb' ))].each {|f| require f}

# Load shared examples
require "shared_examples"

def setup_servers_and_connections
  FileUtils.mkdir_p '/tmp/sunspot_mongo_test/'

  @solr_pid  = fork { `sunspot-solr start --log-file=/tmp/sunspot_mongo/solr.log --log-level=INFO --port=8900` }
  sleep 2

  Mongoid::Config.connect_to 'sunspot_mongo_test'

  Sunspot.config.solr.url = 'http://127.0.0.1:8900/solr'
end
setup_servers_and_connections

RSpec.configure do |config|
  config.before :each do
    Sunspot.remove_all!
  end
end
