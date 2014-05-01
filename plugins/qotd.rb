# Quote of the day

require 'net/http'

module Lingrvant
  class QOTD < Plugin

    def help
      "!Q"
    end

    def cmd_Q(argv)
      params = []
      params << 'number=4'
      params << 'collection[]=mgm'
      params << 'collection[]=motivate'
      params << 'collection[]=classic'
      params << 'collection[]=coles'
      params << 'collection[]=lindsly'
      params << 'collection[]=poorc'
      params << 'collection[]=altq'
      params << 'collection[]=20thcent'
      params << 'collection[]=bywomen'
      params << 'collection[]=devils'
      params << 'collection[]=contrib'
      params = params.join('&')
      response = Net::HTTP.get_response('www.quotationspage.com', "/random.php3?#{params}")
      q = response.body
      m = q.match(/<dt class="quote">(.*)<\/dt><dd class="author">(.*)<\/dd>/)
      if m
        quote = remove_tags(m[1])
        author = remove_tags(m[2])
        "#{quote} --- #{author}"
      else
        'no quote found'
      end
    end

    def remove_tags(html)
      html.gsub(/<[a-zA-Z\/][^>]*>/, '')
    end
  end

  Bot.register(QOTD)
end
