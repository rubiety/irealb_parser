require "rubygems"
require "active_support/core_ext"
require "active_support/json/encoding"

module IRealB
  class Parser
    require "irealb/parser/chord"
    require "irealb/parser/chord_grouping"
    require "irealb/parser/tune"

    attr_reader :text
    attr_reader :tunes

    def initialize(text)
      @text = text
      @tunes = []
    end

    def parse
      @text.split("=").in_groups_of(6).each do |raw_tune|
        @tunes << parse_tune(raw_tune)
      end
      self
    end

    def as_json(options = {})
      tunes.map(&:as_json)
    end


    protected

    def parse_tune(raw_tune)
      Tune.new(:name => raw_tune[0], :composer => raw_tune[1], :style => raw_tune[2], :key => raw_tune[3]).tap do |tune|

        # TODO: This scan does not account for brackets that don't have a section designation, or repeats with multiple endings
        raw_tune[5].to_s.scan(/\*(A|B|C|D|E|F|G)(\[|\{)([^\*]*)(\]|\}|Z)/).each do |raw_section|
          tune.chord_groupings << parse_section(raw_section)
        end

        reduce_time_signatures(tune)
      end
    end

    def parse_section(raw_section)
      ChordGrouping.new(:section => raw_section[0], :repeat => (raw_section[1] == '{' ? 1 : nil)).tap do |chord_grouping|
        raw_bars = raw_section[2]

        if md = raw_bars.match(/^T(\d)(\d).*/)
          chord_grouping.time = "#{md[1]}/#{md[2]}"
          raw_bars.gsub!(/^T(\d)(\d)/, "")
        end

        # TODO: Need to extract these somehow:
        raw_bars.gsub!(/\<[^<]+\>/, "")

        chord_grouping.bars = parse_bars(raw_bars) 
      end
    end

    def parse_bars(raw_bars)
      raw_bars.to_s.split("|").map(&:strip).map {|e| e.split(/ |,/).map {|c| parse_chord(c) }}
    end

    def parse_chord(raw_chord)
      raw_chord.gsub!("^", "maj")
      raw_chord.gsub!("h", "dim")
      raw_chord.gsub!("x", "%")
      raw_chord
    end

    def reduce_time_signatures(tune)
      # TODO: This is a bit tricky...
    end
  end
end

