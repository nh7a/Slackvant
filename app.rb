# Copyright (c) 2013 Naoki Hiroshima
# You can redistribute this and/or modify this under the same terms as Ruby

require 'rubygems'
require 'sinatra'
require 'json'

$stdout.sync = true

post '/' do
  begin
    response = []
    raw = request.env["rack.input"].read
    body = JSON.parse(raw)
    body['events'].each do |e|
      m = e['message']
      r = Lingrvant::Bot.handle(m['text'], m)
      response << r if r
    end
    response.join("\n")
  rescue Exception => e
    puts e
  end
end

get '/' do
<<EOT
  <h1>Lingrvant</h1>
  <form method='get'>
    <input type="text" name="s" autofocus />
    <input type="submit">
  </form>
  <hr>
  <pre>#{Lingrvant::Bot.handle(params['s']) if params['s']}</pre>
EOT
end

module Lingrvant
  class Bot
    @@plugins = []

    class <<self
      def plugins
        @@plugins
      end

      def register(klass)
        @@plugins << klass.new
      end

      def handle(text, params=nil)
        response = []
        @@plugins.each do |i|
          begin
            response << i.on_message(text, params)
          rescue => e
            response << "#{e} (#{e.class})"
          end
        end
        response.compact.join("\n")
      end
    end
  end

  class Plugin
    def on_message(text, params)
      if text[0] == '!'
        argv = text.split(' ')
        command = argv.shift.strip
        method = "cmd_#{command[1..-1]}"
        if respond_to?(method.to_sym)
          puts "** #{name}.#{method}(#{argv})"
          send(method, argv)
        end
      end
    end

    def help; "no help... doh!"; end
    def name; @name ||= self.class.name.match('[^:]+$')[0]; end
  end

  Dir.glob("plugins/**/*.rb").each{|f| load f}
end
