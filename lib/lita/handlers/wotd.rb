require 'net/http'
require 'uri'
require 'rexml/document'

module Lita
  module Handlers
    class Wotd < Handler
      route(/wotd/, :wotd, command: true, help: {
        'wotd' => 'returns the word of the day from dictionary.com'
      })

      def wotd(response)
        response.reply(the_word)
      end

      private
      def the_word
        "#{extract_the_word} - dictionary.com"
      end

      def extract_the_word
        xml_data = api_call.body
        doc      = REXML::Document.new(xml_data)
        doc.get_elements('//description').last.get_text
      end

      def uri
        URI.parse 'http://dictionary.reference.com/wordoftheday/wotd.rss'
      end

      def api_call
        Net::HTTP.get_response(uri)
      end
    end

    Lita.register_handler(Wotd)
  end
end
