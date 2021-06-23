# gem install faye-websocket
require 'faye/websocket'
require 'eventmachine'
# gem install colorize
require 'colorize'
require 'json'

# https://github.com/bitoex/bitopro-offical-api-docs/blob/master/v3-1/ws/ws.md
Url = 'wss://stream.bitopro.com:9443/ws/v1/pub/order-books/DOGE_TWD:1'

EM.run {
  ws = Faye::WebSocket::Client.new(Url)

  ws.on :open do |event|
    p [:open]
    # ws.send('Hello, world!')
  end

  ws.on :message do |event|
    return if event.nil?
    data = JSON.parse(event.data)

    puts "Time: #{data['datetime']}"
    puts "Bids Price: #{data['bids'][0]['price']}".green
    puts "Asks Price: #{data['asks'][0]['price']}".red
  end

  ws.on :close do |event|
    p [:close, event.code, event.reason]
    ws = nil
  end
}
