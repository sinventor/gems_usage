require 'RMagick'

image = Magick::Image.read("./tmp/images/github_grab_1.png").first
modi_image = image.crop(54, 54, 670, 560)
modi_image.write("./rmagick/images/changed/github_01.png")