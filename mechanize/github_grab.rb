require 'mechanize'
require './my_stuff/colorize/wrapper'

ARGV[0] = ARGV.join(' ') and ARGV.delete_if.with_index { |el, i| i > 0 } if ARGV.count > 1
abort "Using:\n\e[37m#{$0}\e[0m \e[32mfindable_gem\e[0m" if ARGV.count != 1

a = Mechanize.new { |agent|
  agent.user_agent_alias = 'Linux Firefox'
}

a.get('https://google.ru') do |page|
  search_result = page.form_with(:name => 'f') do |search|
    # search.q = ARGV[0]
    search_field = search.field_with(name: 'q')
    search_field.value = ARGV[0]
  end.submit
  hit = false

  hrefs = search_result.links.reject{ |l| l.href.scan(/github\.com/).empty? }
  hrefs.each do |href|
    clicked_page = href.click
    repository_lang_tag = clicked_page.parser.at_css("div.repository-lang-stats-graph")
    markdowned_article = clicked_page.parser.at_css("article.markdown-body.entry-content")
    # puts "Page title: #{clicked_page.title}"
    # puts markdowned_article.to_xml[134..400] if !markdowned_article.nil?

    if !markdowned_article.nil?
      puts "\t\e[33mYeap!\e[0m"
      paragraphs = markdowned_article.css(">p")
      puts "\e[35mbut paragraph not found\e[0m" and next if paragraphs.empty?
      paragraph = paragraphs.reject { |p| p.text.strip.empty? }.first
      puts "\e[30m=" * 22 + "\e[0m"
      lang_span = repository_lang_tag.css("span.language-color") if !repository_lang_tag.nil?
      if !lang_span.nil?
        puts "\t\e[33mURAAA!\e[0m"
        puts "\e[30m=" * 22 + "\e[0m"
        puts "URL: \e[37m#{clicked_page.uri}\e[0m"
        aria_labels = lang_span.map do |lang|
          lang.attributes["aria-label"].to_s
        end
        aria_labels = MyStuff::Colorize::Wrapper.wrap_array_by_priority(aria_labels)
        aria_labels.each do |percented_lang|
          print "#{percented_lang}"
        end
      end
      puts "\e[30m=" * 22 + "\e[0m"
      puts paragraph.text
      puts "\e[34m#{"=" * 22}\e[0m"
      hit = true
    end
    break if hit
  end
end