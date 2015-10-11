require 'mechanize'

agent = Mechanize.new
page = agent.get('http://www.eldorado.ru/cat/detail/71119348/?show=properties')
images = page.search("img")

puts images.length
images.reject {|img| img.attributes["src"].content.scan(/.*\/?[A-Za-z0-9]+\.(jpg|ico|png|gif)\z/).empty? }.each do |image|
  img_content = image.attributes["src"].content
  filename = img_content.gsub(/.*\/([A-Za-z0-9]+\.(jpg|ico|png|gif))\z/, '\1')
  agent.get(image.attributes["src"]).save("./mechanize/images/eldor/#{filename}")
end