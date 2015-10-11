require 'mechanize'
require './my_stuff/modi_puts'

abort "#{$0} login passwd" if (ARGV.size != 2)

a = Mechanize.new { |agent|
  agent.user_agent_alias = "Android"
  agent.follow_meta_refresh = true
}

a.get('http://vk.com/') do |page|
  source_page = a.get(page.link_with(text: /Войти/))
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
  # puts my_page.link_with(text: /Фото/).node
  # puts "=" * 25
  photos_page = a.click(my_page.link_with(:text => /Фотогр/))
  # posts_p = a.click(photos_page.feild_with(:name => /posts/))

  link_with_posts = photos_page.links.find { |link| link.attributes["name"] }
  posts_page = a.click(link_with_posts)
  albums_page = posts_page.link_with(text: /и альбомы/).click
  upload_page = albums_page.link_with(text: /фотографии/i).click
  File.open("./mechanize/research/tmp/vk/photos_p.html", "w") do |f|
    f.write(upload_page.parser.to_xml)
  end unless File.exists?("./mechanize/research/tmp/vk/photos_p.html")
  # puts upload_page.forms.first.form_node.to_s + " форм"
  submitted_page = upload_page.form_with(method: 'POST') do |f|
    puts "Enter.."
    File.open("./mechanize/research/tmp/vk/new_album_p.html", "w") do |file|
      file.write(f.form_node)
    end unless File.exists?("./mechanize/research/tmp/vk/new_album_p.html")
    title_field = f.field_with(name: 'title')
    title_field.value = "album 0004"
    text_area_field = f.textareas.first
    text_area_field.value = "Technics for " * 550
    f["view"] = "3"
    f["comm"] = "1"
  end.submit

  images_for_upload = Dir["./mechanize/images/eldor/*.jpg"]

  submitted_page.form_with(method: 'POST') do |upload_form|
    File.open("./mechanize/research/tmp/vk/imgs_upload_p.html", "w") do |file|
      file.write(upload_form.form_node)
    end

    upload_form.file_uploads.each do |file_upl|
      file_upl.file_name = images_for_upload[rand(images_for_upload.size)]
    end
  end.submit
end
