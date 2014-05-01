# Flickr

require 'net/http'
require 'json'

module Slackvant
  class Flickr < Plugin
    def help
      <<EOT
!F[qnzcb] query"
q: square 150x150
n: small, 320 on longest side
z: medium 640, 640 on longest side
c: medium 800, 800 on longest side†
b: large, 1024 on longest side*
EOT
    end

    def self.setup_cmd(cmd)
      define_method "cmd_F#{cmd}" do |argv|
        get_urls(argv, cmd)
      end
    end
    %W( #{} q n z c b ).map {|x| setup_cmd x}

    def search(keyword)
      arr = []
      params = URI.encode_www_form(
        method: 'flickr.photos.search',
        api_key: ENV['FLICKR_API_KEY'],
        format: 'json',
        sort: 'relevance',
        per_page: 10,
        text: keyword)

      url = URI("http://api.flickr.com/services/rest?#{params}")
      response = Net::HTTP.get_response(url)

      json = response.body.sub(/jsonFlickrApi\(/, '').sub(/\);?$/, '')
      puts json
      photos = JSON.parse(json)['photos']
      photos ? photos['photo'] : []
    end

    def get_urls(keywords, size, max=10)
      urls = []
      size = size.empty? ? "" : "_#{size}"
      photos = search(keywords.join(' '))
      puts "-- photos: #{photos}"
      photos[0..max].each do |i|
        urls << "http://farm#{i['farm']}.staticflickr.com/#{i['server']}/#{i['id']}_#{i['secret']}#{size}.jpg"
      end
      urls.join("\n")
    end
  end

  Bot.register(Flickr) if ENV['FLICKR_API_KEY']
end
