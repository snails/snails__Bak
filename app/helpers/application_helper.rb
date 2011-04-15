module ApplicationHelper
  def logo
    logo = image_tag("logo.png",:alt => "Snail Logo", :class => "logo")
  end
end
