module HandleImpressions
  extend ActiveSupport::Concern

  def impressions_this_week
    self.impressions_between(1.week.ago, Date.tomorrow)
  end

  def impressions_last_week
    self.impressions_between(2.weeks.ago, 1.week.ago)
  end

  def impressions_change
    (self.impressions_this_week.count / self.impressions_last_week.count) rescue self.impressions_this_week.count
  end

  def impressions_between(start_date, end_date)
    #adding own method as impressionist_count seems to be broken in rail5
    #https://github.com/charlotte-ruby/impressionist/issues/212
    self.impressions.where(created_at: start_date..end_date)
  end

end
