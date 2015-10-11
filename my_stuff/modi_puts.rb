module Kernel
  def improve_output(interlocator, text)
    puts "\nСобеседник - \e[32m#{interlocator}\e[0m:"
    puts " =>\t\e[38m#{text}\e[0m"
    puts "#{"=" * 33}\n"
  end

  def x_puts(title, value)
    puts "\t\t\e[33m#{title}\e[0m:\t\e[36m#{value}\e[0m"
  end

  def alert(desc, text)
    puts fill("\u06ae", 36)
    puts "#{fill("\u2b00\u2b02",5)}\t\e[33m#{desc}\e[0m\t#{fill("\u2B1a",5)}"
    puts "\t#{fill("\u096a", 24)}\n"
    puts "\n#{fill("\u06aa", 1)}\t\e[31m#{text}\e[0m\t#{fill("\u12ef", 1)}\n\n"
    puts fill("\u2b02", 36)
  end

  def fill(code, count)
    "\e[32m#{code.encode("utf-8") * count}\e[0m"
  end
end
