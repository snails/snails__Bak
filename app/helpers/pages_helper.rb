#encoding: utf-8
module PagesHelper
  #如果没有设置标题变量，则使用默认的标题
  def title
    base_title = '蜗牛网'
    unless @title.nil?
      "#{@title}"
    else
      base_title
    end
  end
end
