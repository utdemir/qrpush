#!/usr/bin/ruby -w

require 'rqrcode'
require 'filemagic'

require 'optparse'
require 'socket'
require 'uri'


options = {}
optparse = OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on("-p", "--port", "Run verbosely") do |v|
    options[:verbose] = v
  end
end

optparse.parse

if ARGV.size != 1
	puts optparse
	exit 1
end

PATH = ARGV[0]

class HttpServer
	def initialize(path)
		@path = path
		@server = TCPServer.new "0.0.0.0", 9090
	
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
	escaped = URI.escape(fname)
	while escaped.length > 40
		ext = File.extname fnamex
		base = fname[0..-ext.length-2]
		fname = base + ext
		escaped = URI.escape fname
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

escaped = escape_filename(File.basename(PATH))

urls = get_ip_addresses.map{|a| "http://#{a}:9090/#{escaped}"}
p urls

url = urls[0]
p url

puts "Url: #{urls[0]}"

def printqr(text)
	qr = RQRCode::QRCode.new(text, :size => 4, :level => :l)

	s = qr.to_s(:true => "  ", :false => "\u2588"*2)

	len = s.index("\n") + 2
	
	puts "\u2588" * len
	s.split("\n").each {|l| puts "\u2588#{l}\u2588"}
	puts "\u2588" * len
end

printqr(urls[0])

server = HttpServer.new(PATH)
loop do
	begin
		server.serve
	rescue Interrupt
		exit 1
	rescue Exception => e
		puts e.message
	end	
end
