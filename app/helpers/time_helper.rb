module TimeHelper
  TIMESTAMP_MODIFIER_MINUTE = 5.minutes

  def hour_to_s
    self.created_at.strftime('%H:%M')
  end

  def date_to_s
    self.created_at.strftime('%B %d, %Y')
  end

  def today?
    self.created_at > Time.zone.now.beginning_of_day
  end

  def calls_for_timestamp?(message, previous_message)
    if message.today?
      (message.created_at - previous_message.created_at) > TIMESTAMP_MODIFIER_MINUTE
    else
      message.created_at > previous_message.created_at.end_of_day
    end
  end

end
