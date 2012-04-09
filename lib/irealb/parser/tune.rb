module IRealB
  class Parser
    class Tune
      attr_accessor :name
      attr_accessor :composer
      attr_accessor :style
      attr_accessor :key
      attr_accessor :chord_groupings

      def initialize(attributes = {})
        self.chord_groupings = []

        attributes.each do |key, value|
          self.send("#{key}=", value) if respond_to?(key)
        end
      end

      def as_json(options = {})
        {
          :name => name,
          :composer => composer,
          :style => style,
          :key => key,
          :changes => chord_groupings.as_json
        }.reject {|k,v| v.nil? }
      end
    end
  end
end
