# Slackvant system commands

module Slackvant
  class System < Plugin

    def help
      <<EOT
!list
!help [module name]
EOT
    end

    def cmd_help(argv)
      if argv.count > 0
        target = argv[0].downcase
        Bot.plugins.each do |plugin|
          if target == plugin.name.downcase
            return plugin.help
          end
        end
      end
      help
    end

    def cmd_list(argv)
      names = Bot.plugins.collect {|i| i.name}
      names.join(', ')
    end

  end

  Bot.register(System)
end
