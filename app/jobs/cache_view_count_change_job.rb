class CacheViewCountChangeJob < ApplicationJob
  #counter cache doesn't seem to be working with rails5 + impressionist
  #https://github.com/charlotte-ruby/impressionist/issues/212
  queue_as :default

  def perform(target)
    target.update(view_count_change: target.impressions_change)
  end
end

