# Google

require 'googleajax'

GoogleAjax.referrer = 'lingr.com'

module Lingrvant
  class Google < Plugin
    def help
      "!G[iv] query..."
    end

    def cmd_G(argv)
      r = GoogleAjax::Search.web(argv.join(' '))
      format(r[:results], :title_no_formatting, :content, :unescaped_url)
    end

    def cmd_Gi(argv)
      r = GoogleAjax::Search.images(argv.join(' '))
      format(r[:results], :content_no_formatting, :unescaped_url)
    end

    def cmd_Gv(argv)
      r = GoogleAjax::Search.video(argv.join(' '))
      format(r[:results], :title_no_formatting, :url)
    end

    def format(results, *items)
      return 'Your search did not match any documents.' unless results.count

      arr = []
      results[0..2].each do |r|
        arr << items.map {|i| r[i]}.join("\n")
      end
      arr.join("\n.\n").gsub(/<\/?b>/, '')
    end
  end

  Bot.register(Google)
end
