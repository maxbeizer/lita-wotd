require 'net/http'
require 'uri'
require 'rexml/document'

module Lita
  module Handlers
    class Wotd < Handler
      WOTD_URL = 'https://wordsmith.org/awad/rss1.xml'.freeze

      route(/wotd/, :wotd, command: true, help: {
        'wotd' => 'returns the word of the day from dictionary.com'
      })

      def wotd(response)
        response.reply(the_word)
      end

      private

      def the_word
        "#{extract_the_word} - wordsmith.org"
      end

      def extract_the_word
        title = doc.get_elements('//title').last.get_text
        description = doc.get_elements('//description').last.get_text
        "#{title} => #{description}"
      end

      def doc
        @doc ||= REXML::Document.new(api_call.body)
      end

      def uri
        URI.parse WOTD_URL
      end

      def api_call
        Net::HTTP.get_response(uri)
      end
    end

    Lita.register_handler(Wotd)
  end
end
