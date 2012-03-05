module InvertedIndex
  class Parse
    attr_accessor :html, :doc, :body, :text
    def initialize(html)
      @html = html
    end

    def parse
      # Remove blank nodes, substitute entities
      @doc = Nokogiri::HTML(@html) do |config|
	config.noblanks.noent
      end
      @body = @doc.css('body')
      @body.css('script').remove
      @body.css('style').remove
      @body.css('iframe').remove
      @text = @body.text
=begin
      # Removing images because we are not interested in image tags for nohttp://digg.comw
      @images = @body.css('img').remove

      # Process anchor text separately because the .text function does not include
      # separators for link text
      @anchors = @body.css('a').remove
      @anchor_text = []
      @anchors.each {|a| @anchor_text << a.text}

      @text = @anchor_text.join(' ')

      # Replace all new lines and tabs with spaces
      @text << @body.text.gsub(/\n|\t/, ' ')

      # Replace apostrophe's with ''
      @text.gsub!(/\'/,'')

      # Replace all remaining non-word characters with spaces
      @text.gsub!(/\W/, ' ')
=end
    end
  end
end
