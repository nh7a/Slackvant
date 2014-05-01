# Simple echo

module Lingrvant
  class Echo < Plugin

    def help
      "!echo foo"
    end

    def on_message(text, params)
      if text =~ /^helo\s*$/
        response = '250'
      elsif text =~ /^ehlo\s*$/
        response = <<EOT
250-AUTH LOGIN CRAM-MD5 PLAIN
250-AUTH=LOGIN CRAM-MD5 PLAIN
250-STARTTLS
250-PIPELINING
250 8BITMIME
EOT
      elsif text =~ /^[.0-9\(\)\+\-\/\*\s]+\s*=$/
        begin
          response = eval("(#{text[0..-2]})")
        rescue
        end
      else
        response = super
      end
      return response
    end

    def cmd_echo(argv)
      argv.join(' ')
    end

  end

  Bot.register(Echo)
end
