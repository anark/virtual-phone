module ApplicationHelper
  def flash_class(level)
    case level
    #when :notice then "alert-info"
    when :notice then "alert-success"
    when :error then "alert-error"
    when :alert then nil
    when :success then "alert-success"
    end
  end
end
