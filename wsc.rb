# gem install faye-websocket
require 'faye/websocket'
require 'eventmachine'
# gem install colorize
require 'colorize'
require 'json'
require 'time'

# https://github.com/bitoex/bitopro-offical-api-docs/blob/master/v3-1/ws/ws.md
Url = 'wss://stream.bitopro.com:9443/ws/v1/pub/order-books/DOGE_TWD:1'
Assets = 0

EM.run {
  ws = Faye::WebSocket::Client.new(Url, [], tls: { ping: 15 })

  ws.on :open do |event|
    p [:open]
    # ws.send('Hello, world!')
  end

  ws.on :message do |event|
    return if event.nil?
    data = JSON.parse(event.data)
    avg_price =
      (data['bids'][0]['price'].to_f + data['asks'][0]['price'].to_f) / 2

    system('clear')
    puts "Time: #{Time.now}"
    puts "Assets: #{Assets * avg_price}"
    puts "Bids Price: #{data['bids'][0]['price']}".green
    puts "Asks Price: #{data['asks'][0]['price']}".red
  end

  ws.on :close do |event|
    p [:close, event.code, event.reason]
    ws = nil
  end
}
