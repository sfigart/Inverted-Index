require 'hpricot'

module InvertedIndex
  class Parse
    attr_accessor :html, :doc, :body, :text, :tokens
    def initialize(html)
      @html = html
    end

    def parse
      @doc = Hpricot(@html)
      @doc.search('script').remove
      @doc.search('style').remove
      @doc.search('iframe').remove

      # Get all text nodes
      @text_nodes = (@doc/"//*/text()")
      @tokens = []
      @text_nodes.each do |node|
	text = node.to_plain_text.strip
	words = clean(text).split(' ')
	words.each do |word|
	  @tokens << word unless word.empty?
	end
      end
      
      # Return text separated by spaces
      @text = @tokens.join(' ')
    end

    def clean(text)
      # Replace new line and tabs with space
      return text.gsub(/(\n|\t)/,' ').strip
    end
  end
end
