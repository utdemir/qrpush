#!/usr/bin/ruby 

require 'rqrcode'
require 'filemagic'

require 'io/console'
require 'optparse'
require 'socket'
require 'uri'

class HttpServer
  def initialize(path, port)
    @path = path
    @server = TCPServer.new("0.0.0.0", port)
    
    raise "File not found/readable" \
      if not File.exists?(@path) or not File.file?(@path)
  end
  
  def get_mime
    FileMagic.new(FileMagic::MAGIC_MIME).file(@path)
  end
  
  def serve
    loop do
      session = @server.accept
      req = session.gets
      
      puts req
      src = File.open @path, "rb"
      
      session.print "HTTP/1.1 200/OK\r\nServer: sendviaqr\r\nContent-Length: #{src.size}\r\nContent-type: #{get_mime}\r\n\r\n"
      
      while not src.eof?
        buffer = src.read(256)
        session.write(buffer)
      end
      src.close
      session.close
    end
  end
end

def escape_filename(fname)
  escaped = URI.encode_www_form_component fname
  while escaped.length > 40
    ext = File.extname fnamex
    base = fname[0..-ext.length-2]
    fname = base + ext
    escaped = URI.encode_www_form_component fname
  end
  escaped
end

def get_ip_addresses
  locals = %w(127.0.0.1 ::1)
  addresses = Socket.ip_address_list.select{|a| a.ipv4?}
  addresses.map!{|a| a.ip_address}
  addresses.select!{|a| not locals.include? a}
  addresses
end

$options = {:qr_size => 2, :port => 9090, :clear => false}
optparse = OptionParser.new do |opts|
  opts.banner = "Usage: qrpush.rb [options] PATH"
  
  opts.on("-p", "--port PORT", "Port for web server", Integer) do |v|
    $options[:port] = v
  end
  
  opts.on("-s", "--size SIZE", "Size for QrCode", Integer) do |v|
    $options[:qr_size] = v
  end
  
  opts.on("-c", "--clear", "Clear screen") do $options[:clear] = true end
end

optparse.parse!(ARGV)

if ARGV.size != 1
  puts optparse
  exit 1
end

PATH = ARGV[0]

raise "File \"#{PATH}\" is not found." unless File.exists? PATH
raise "File \"#{PATH}\" is not readable." unless File.readable? PATH

escaped = escape_filename(File.basename(PATH))

ips = get_ip_addresses
raise "No IP address found." if ips.size == 0
if ips.size > 1
  puts "More than one IP found, select one:"
  ips.each_with_index { |ip, index| puts "#{index+1} - #{ip}" }
  begin
    print '> '
    num = STDIN.gets.strip.to_i
  end while num <= 0 or num > ips.size
    
  ip = ips[num-1]
end

url = "http://#{ip}:#{$options[:port]}/#{escaped}"
puts "Url: #{url}"
puts

def printqr(text, size, clear)
  begin
    qr = RQRCode::QRCode.new(text, :size => size, :level => :l)
  rescue RQRCode::QRCodeRunTimeError
    puts "Size #{size} is too small, increasing to #{size+1}."
    size += 1
  end while qr == nil
    
  s = qr.to_s(:true => "  ", :false => "\u2588"*2)
  
  len = s.index("\n") + 2
  
  puts "\u2588" * len
  s.split("\n").each {|l| puts "\u2588#{l}\u2588"}
  puts "\u2588" * len
end

server = HttpServer.new(PATH, $options[:port])
Thread.new { 
  loop do
    begin
      server.serve
    rescue Interrupt
      exit 1
    rescue Exception => e
      puts e.message
    end	
  end
}

printqr(url, $options[:qr_size], $options[:clear])

STDIN.getch
