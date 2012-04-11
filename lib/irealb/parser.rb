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
        parse_tune(raw_tune).tap do |tune|
          @tunes << tune if tune
        end
      end
      self
    end

    def as_json(options = {})
      tunes.map(&:as_json)
    end


    protected

    def parse_tune(raw_tune)
      return nil if raw_tune.size < 5

      Tune.new(:name => raw_tune[0], :composer => raw_tune[1], :style => raw_tune[2], :key => raw_tune[3]).tap do |tune|
        raw_changes = raw_tune[5].to_s

        tokens = raw_changes.scan(/\*[A-Za-z]|\<[^\>]+\>|S|Y|Q|U|s|l|T\d\d|[\|\{\}\[\]]|N\d|[^ \|\,\]\}]+/)
        parse_changes(tune, tokens)

        reduce_time_signatures(tune)
      end
    end

    def parse_changes(tune, tokens)
      current_section = ChordGrouping.new
      current_bar = []
      current_ending = nil
      tune_ended = false

      end_bar = lambda {|token|
        unless current_bar.empty?
          if current_ending
            current_section.endings ||= [[], []]
            current_section.endings[current_ending - 1] << current_bar
          else
            current_section.bars << current_bar
          end

          current_bar = []
        end
      }

      tokens.each do |token|
        case token
        when /\*[A-Za-z]/
          current_section.section = token.gsub("*", "")
        when /T\d\d/
          current_section.time = "#{token[1]}/#{token[2]}"
        when "|"
          end_bar.call(token)
        when "]"
          end_bar.call(token)

          tune.chord_groupings << current_section
          current_section = ChordGrouping.new
          current_ending = nil
        when "Z"
          tune.chord_groupings << current_section
          current_section = ChordGrouping.new
          tune_ended = true
        when "}"
          end_bar.call(token)

          if tune_ended
            current_section.coda = true
            tune.chord_groupings << current_section
            current_section = ChordGrouping.new
          else
            current_section.repeat = 1

            unless current_ending
              tune.chord_groupings << current_section
              current_section = ChordGrouping.new
            end
          end
        when "N1"
          current_ending = 1
        when "N2"
          current_ending = 2
        when "Q"
          current_bar << {"goto" => "coda"}
        when /^\</
          current_bar << {"note" => token.gsub("<", "").gsub(">", "") }
        when "Y"
          true # Code Designation
        when "[", "{"
          true # Begin Section Designation
        when "s", "l", "S"
          true # Don't know what these are, but we don't want them
        else
          current_bar << parse_chord(token)
        end
      end
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

