require "thor"
require "irealb/parser"

module IRealB
  module Parser
    class Runner < Thor
      desc :json, "Takes an iReal B text file (decoded contents of href attribute) and outputs chords-json."
      def json(path)

      end
      
      protected
    
      def expand_paths(paths = [])
        paths.map do |path|
          [path] + Dir[path + "**/*.rb"]
        end.flatten.uniq.reject {|f| File.directory?(f) }
      end
    end
  end
end
