module MyStuff
  module Colorize

    COLORS = {
      'black' => 30,
      'red' => 31,
      'green' => 32,
      'yellow' => 33,
      'blue' => 34,
      'magenta' => 35,
      'cyan' => 36,
      'white' => 37
    }

    COLORS_FOR_COUNTABLE = {
      'green' => 32,
      'blue' => 34,
      'cyan' => 36,
      'white' => 37,
      'red' => 31
    }

    EXTRAS = {
      'clear' => 0,
      'bold' => 1,
      'underline' => 4,
      'reversed' => 7
    }
    class Wrapper
      def self.wrap_array(array)

        array.each_with_index.map do |str, i|
          rand_col = COLORS.values[rand(COLORS.size)]
          rand_fore_col = EXTRAS['clear']
          "\e[#{rand_col}m#{str}\e[#{rand_fore_col}m" + (i == array.length - 1 ? "\n" : "  ")
        end
      end

      def self.wrap_array_by_priority(array)
        array = [array] if !array.is_a? Array
        array if array.size <= 1
        array_with_percents = array.map do |str|
          [ str, str.scan(/(\d+[,.]\d+)/).flatten.first.to_f ]
        end
        desc_sorted = array_with_percents.sort_by { |pair| -pair[1] }
        desc_sorted.each_with_index.map do |str, i|
          fo_color = COLORS_FOR_COUNTABLE.values[i % COLORS_FOR_COUNTABLE.count]
          "\e[#{fo_color}m#{str[0]} \e[#{EXTRAS['clear']}m#{"\n" if i == array.count - 1}"
        end
      end
    end
  end
end