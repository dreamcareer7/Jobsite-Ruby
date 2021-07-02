module EmailHelper
  #USER

  def send_welcome_email
    UserMailer.welcome_user(self).deliver_now
  end

  def send_business_model_email
    UserMailer.business_model(self).deliver_now
  end

  def send_user_upgrade_prompt_email
    UserMailer.prompt_upgrade(self).deliver_now
  end

  def send_user_update_profile_prompt_email
    UserMailer.prompt_update(self).deliver_now
  end

  def send_user_upgraded_email(subscription)
    UserMailer.user_upgraded(self, subscription).deliver_now
  end

  def send_project_posted_email(project)
    UserMailer.project_posted(project).deliver_now
  end

  def send_new_quote_email(quote)
    UserMailer.new_quote(quote).deliver_now
  end

  def send_project_marked_complete_email(project)
    UserMailer.marked_complete(project)
  end

  def send_project_follow_up_email(project)
    UserMailer.completed_follow_up(project)
  end

  def send_project_cancelled_by_business_email(project)
    UserMailer.cancelled(project)
  end

  def send_check_quotes_email
    UserMailer.check_quotes(self).deliver_now
  end

  def send_user_renew_subscription_email
    UserMailer.renew_subscription(self).deliver_now
  end

  def send_updates_about_following_email
    UserMailer.update_following(self).deliver_now
  end

  def send_business_received_project_email
    UserMailer.business_received_project(self).deliver_now
  end

  def send_project_deleted_email(project)
    UserMailer.project_deleted(project).deliver_now
  end

  def send_new_project_applicant_email(project, business)
    UserMailer.new_applicant(project, business).deliver_now
  end

  #BUSINESS

  def send_new_business_email
    AdminMailer.new_business(self)
    AdminNotification.new_business_notification(self)
    return unless self.user.present?

    BusinessMailer.welcome_business(self).deliver_now
  end

  def send_business_approved_email(business)
    BusinessMailer.business_approved(business)
  end

  def send_business_upgrade_prompt_email
    BusinessMailer.prompt_upgrade(self).deliver_now
  end

  def send_business_upgraded_email(subscription)
    return unless self.user.present?

    BusinessMailer.business_upgraded(self, subscription).deliver_now
  end

  def send_new_review_email
    return unless self.user.present?

    BusinessMailer.new_review(self).deliver_now
  end

  def send_invited_to_project_email(project, business)
    BusinessMailer.invited(project, business).deliver_now
  end

  def send_shortlisted_email(project, business)
    return unless business.user.present?

    BusinessMailer.shortlisted(project, business).deliver_now
  end

  def send_hired_for_project_email(project, business)
    BusinessMailer.hired(project, business).deliver_now
  end

  def send_project_cancelled_by_user_email(project, business)
    BusinessMailer.cancelled(project, business).deliver_now
  end

  def send_project_confirmed_complete_email(project, business)
    BusinessMailer.completed(project, business).deliver_now
  end

  def send_business_renew_subscription_email
    BusinessMailer.renew_subscription(self).deliver_now
  end

  def send_inactive_business_email
    return unless self.user.present?

    BusinessMailer.inactive_prompt(self).deliver_now
  end

  def send_business_profile_incomplete_email
    return unless self.user.present?

    BusinessMailer.incomplete_prompt(self).deliver_now
  end

  def send_update_business_profile_email
    return unless self.user.present?

    BusinessMailer.update_profile_prompt(self).deliver_now
  end

  def send_outstanding_quote_requests_email
    return unless self.user.present?

    BusinessMailer.outstanding_quote_requests(self).deliver_now
  end

  def send_business_disabled_email(business)
    return unless business.user.present?

    BusinessMailer.disabled(business).deliver_now
  end

  def send_new_projects_email(business, projects)
    return unless business.user.present?

    BusinessMailer.new_projects(business, projects).deliver_now
  end

  #ADMIN

  def send_notify_admin_new_business_email(business)
    AdminMailer.new_business(business).deliver
  end

  def send_notify_admin_business_shortlisted_email(project, business)
    AdminMailer.business_shortlisted(project, business).deliver
  end

  def send_notify_admin_business_hired_email(project, business)
    AdminMailer.business_shortlisted(project, business).deliver
  end

  def send_notify_admin_project_new_project(project)
    AdminMailer.new_project(project).deliver
  end

  def send_notify_admin_project_complete_email(project)
    AdminMailer.project_completed(project).deliver
  end

  def send_notify_admin_project_cancelled_email(project)
    AdminMailer.project_cancelled(project).deliver
  end

end
