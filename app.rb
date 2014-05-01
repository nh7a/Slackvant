# Copyright (c) 2014 Naoki Hiroshima
# You can redistribute this and/or modify this under the same terms as Ruby

require 'rubygems'
require 'sinatra'
require 'json'

$stdout.sync = true

post '/' do
  begin
    response = []
    text = params[:text]
    r = Slackvant::Bot.handle(text)
    JSON.generate({text: r}) if r
  end
end

get '/' do
<<EOT
  <h1>Slackvant</h1>
  <form method='get'>
    <input type="text" name="text" autofocus />
    <input type="submit">
  </form>
  <hr>
  <pre>#{Slackvant::Bot.handle(params[:text]) if params[:text]}</pre>
EOT
end

module Slackvant
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
