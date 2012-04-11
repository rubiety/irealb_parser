module IRealB
  class Parser
    class ChordGrouping
      attr_accessor :section
      attr_accessor :time
      attr_accessor :repeat
      attr_accessor :bars
      attr_accessor :endings
      attr_accessor :coda

      def initialize(attributes = {})
        self.bars = []

        attributes.each do |key, value|
          self.send("#{key}=", value) if respond_to?(key)
        end
      end

      def as_json(options = {})
        {
          :section => section,
          :time => time,
          :repeat => repeat,
          :coda => coda,
          :bars => bars,
          :endings => endings
        }.reject {|k,v| v.nil? }
      end
    end
  end
end
