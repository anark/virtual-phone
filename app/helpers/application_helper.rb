module ApplicationHelper
  def flash_messages
    content_tag :div, :class => 'flashes', :id => 'notices' do
      flash.collect do |type, message|
        unless type == :domain
          content_tag :div, :class => "flash flash_#{type}" do
            content_tag :div, message, :class => "flash_content"
          end
        end
      end.join.html_safe
    end
  end
end
