require 'nokogiri'

module XlsxTemplater
  class TemplateProcessor
    attr_reader :data

    # data is expected to be a hash of symbols => string or arrays of hashes.
    def initialize(data, delimiter)
      @data, @delimiter = data, delimiter
    end

    def render(document)
      if document.respond_to?(:force_encoding)
        document = document.force_encoding(Encoding::UTF_8) 
      end
      safe_delimiter = Regexp.escape(@delimiter)
      data.each do |key, value|
        case value
        when TrueClass, FalseClass
          if value
            document.gsub!(/\#(END)?IF:#{key.to_s.upcase}\#/, '')
          else
            document.gsub!(/\#IF:#{key.to_s.upcase}\#[^\#]*\#ENDIF:#{key.to_s.upcase}\#/m, '')
          end
        # TODO work with array
        # when Array
        else
          document.gsub! /#{safe_delimiter}#{key}#{safe_delimiter}/i, safe(value)
        end
      end
      document
    end

    private

    def safe(text)
      text.to_s.gsub(/[&><"']/, '&' => '&amp;', '>' => '&gt;', '<' => '&lt;', '"' => '&quot;', "'" => '&apos;')
    end
  end
end
