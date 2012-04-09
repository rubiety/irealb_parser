require "thor"
require "irealb/parser"

module IRealB
  class Parser
    class Runner < Thor
      desc :json, "Takes an iReal B text file (decoded contents of href attribute) and outputs chords-json."
      def json(path)
        puts JSON.pretty_generate(IRealB::Parser.new(File.read(path)).parse.as_json)
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

