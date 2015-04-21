require 'net/http'
require 'socket'
require_relative 'cache_store'

server = TCPServer.new("127.0.0.1", 2000) #create a server

cache_store = CacheStore.new

loop do

  Thread.start(server.accept) do |client|  #separate execution

    puts "Enter URL you want to cache"
    url = gets.chomp
    uri = URI(url)

    body = cache_store.fetch(url)
    if body
      puts "fetching #{url} from cache"
    else
      puts "cache miss for #{url}"
      res = Net::HTTP.get_response(uri) # => String
      cache_store.store(url, res.body)
      body = res.body
    end

    client.puts body
    client.close

  end
end
