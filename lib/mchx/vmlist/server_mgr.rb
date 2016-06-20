require 'json'
require 'pp'
require_relative 'server'

module Vmlist
  class ServerMgr
    def initialize
      @conf = {}
      @svrs = {}
    end

    def load_config
      @conf = JSON.parse(IO.read('config.json'))
    end

    def get_config
      @conf
    end

    def init_servers
      @conf.each do |name,config|
        @svrs[name] = VmList::Server.new(config)
        @svrs[name].connect
      end

    end

    def poll_servers
      @svrs.each do |name,svr|
        svr.load_clients
        svr.load_kvmhosts
        svr.load_kvmguests
      end
    end

    def get_servers_list
      total_list = []
      @svrs.each do |name,svr|
        svr.get_clients.each do |vv|
          total_list.push(vv)
        end

        pp svr.get_kvmhosts
        pp svr.get_kvmguests
      end
    end


  end
end