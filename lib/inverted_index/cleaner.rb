module InvertedIndex
  class Cleaner
    def self.clean(text)
      # Split by spaces
      tokens = text.split(' ')

      # To lowercase
      tokens = tokens.each {|token| token.downcase}
     
      # Remove stopwords
      tokens = tokens - InvertedIndex::Stopwords.words

      # Remove all non-word characters
      words = []
      tokens = tokens.each do |token|
        word = token.gsub(/\W/,'')
        words << word if !word.empty?
      end
      tokens = words

      # TODO: Scan text for special text (e.g. dates, time)
      # A date looks like /((january|february|march)\s\d,\s\d\d\d\d)/i
      # A time looks like
      # 00:00 # 00:00:00 # 00:00:00 a.m. # 00:00:00 p.m. # 00:00:00 pm
      matches = text.scan(/(\d\d:\d\d(:\d\d)?(\s(a|p)\.?m\.?)?)/i)
      matches.each {|match| tokens << match[0].downcase.strip}
   
      # Remove all non-ascii words
      ascii_terms = []
      tokens.each {|token| ascii_terms << token if token.ascii_only?}
      tokens = ascii_terms

      # Stem
      stemmed_terms = []
      tokens.each {|token| stemmed_terms << token.stem if !token.stem.empty?}
      tokens = stemmed_terms
    end
  end
end
