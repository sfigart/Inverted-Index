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
	  clean_word  = clean(word)
	  @tokens << clean_word unless clean_word.empty?
	end
      end
      
      # Return text separated by spaces
      @text = @tokens.join(' ')
    end

    # TODO: Still need to clean more characters without losing
    # context (e.g. dates, U.S.)
    def clean(text)
      # Replace new line and tabs with space
      # Replace apostrophe with ''
      return text.gsub(/(\n|\t)/,' ').gsub(/\'/,'').strip
    end
  end
end
