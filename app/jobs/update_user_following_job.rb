class UpdateUserFollowingJob < ApplicationJob
  queue_as :default

  def perform
    @target_users = User.following_candidates

    @target_users.each do |user|
      user.send_updates_about_following_email
    end

    @target_users.count
  end

end

