module ApplicationHelper

  def device_type  
      request.env['mobvious.device_type']
  end

end
