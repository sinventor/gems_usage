require 'mechanize'

abort "#{$0} vk_username vk_password" if ARGV.count != 2

agent = Mechanize.new

agent.get('http://vk.com/') do |page|
  source_page = agent.get(page.link_with(text: /Войти/))
  src_form = source_page.forms.first
  username_field = src_form.field_with(:name => 'email')
  username_field.value = ARGV[0]
  pass_field = src_form.field_with(:name => 'pass')
  pass_field.value = ARGV[1]
  my_page = src_form.submit
  if my_page.title.include?("Login |")
    alert("Опаачки!!", "Неверный логин(пароль)")
    x_puts "title", my_page.title
    x_puts "uri",   my_page.uri
    break
  else
    puts fill("\u2713", 33)
  end

  messages_page = my_page.link_with(:text => /Сообщения/).click
  entries = messages_page.parser.xpath('//div[@class="di_cont"]')
  talks = entries.collect do |row|
    talk = {}
    [
      [:interlocator, 'div[@class="di_head"]/span[@class="mi_author"]/text()'],
      [:text, 'div[@class="di_body"]/div[@class="di_text"]/text()']
    ].each do |name, xpath|
      talk[name] = row.at_xpath(xpath).to_s.strip
    end
    talk
  end
  talks.each do |talk|
    improve_output(talk[:interlocator], talk[:text])
  end
end

BEGIN {
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
}