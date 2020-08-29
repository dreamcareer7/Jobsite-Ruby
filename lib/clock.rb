require 'clockwork'
require './config/boot'
require './config/environment'

include Clockwork

module Clockwork

  handler do |job|
    case job

    when 'refresh.sitemap'
      if ENV["DOMAIN"] == "muqawiloon.com"
        RefreshSitemapJob.perform_later
        puts 'Sitemap was generated.'
      else
        puts 'Sitemap was not generated due to environment.'
      end

    when 'prompt.outstanding_quote_requests'
      if ENV["DOMAIN"] == "muqawiloon.com"
        candidates = PromptBusinessOutstandingQuoteRequestsJob.perform_later
        puts "Prompt inactive businesses email sent to #{ candidates.count } candidates"
      end

    when 'prompt.inactive_businesses'
      if ENV["DOMAIN"] == "muqawiloon.com"
        candidates = PromptBusinessInactiveJob.perform_later
        puts "Prompt inactive businesses email sent to #{ candidates.count } candidates"
      end

    when 'prompt.user_upgrade'
      if ENV["DOMAIN"] == "muqawiloon.com"
        candidates = PromptUserUpgradeJob.perform_later
        puts "Prompt user upgrade email sent to #{ candidates.count } candidates"
      end

    when 'prompt.business_upgrade'
      if ENV["DOMAIN"] == "muqawiloon.com"
        candidates = PromptBusinessUpgradeJob.perform_later
        puts "Prompt business upgrade email sent to #{ candidates.count } candidates"
      end

    when 'prompt.user_update'
      if ENV["DOMAIN"] == "muqawiloon.com"
        candidates = PromptUserUpdateProfileJob.perform_later
        puts "Prompt user update email sent to #{ candidates.count } candidates"
      end

    when 'update.business_new_projects'
      if ENV["DOMAIN"] == "muqawiloon.com"
        UpdateBusinessNewProjectsJob.perform_later
        puts "Updated businesses about new projects"
      end

    when 'prompt.business_update'
      if ENV["DOMAIN"] == "muqawiloon.com"
        candidates = PromptBusinessUpdateProfileJob.perform_later
        puts "Prompt business update email sent to #{ candidates.count } candidates"
      end

    when 'prompt.business_update'
      if ENV["DOMAIN"] == "muqawiloon.com"
        candidates = PromptBusinessUpdateProfileJob.perform_later
        puts "Prompt business update email sent to #{ candidates.count } candidates"
      end

    when 'prompt.user_check_quotes'
      if ENV["DOMAIN"] == "muqawiloon.com"
        candidates = PromptUserCheckQuotesJob.perform_later
        puts "Prompt user check quotes email sent to #{ candidates.count } candidates"
      end

    when 'prompt.user_renew_subscription'
      if ENV["DOMAIN"] == "muqawiloon.com"
        candidates = PromptUserRenewSubscriptionJob.perform_later
        puts "Prompt user renew subscription email sent to #{ candidates.count } candidates"
      end

    when 'prompt.business_renew_subscription'
      if ENV["DOMAIN"] == "muqawiloon.com"
        candidates = PromptBusinessRenewSubscriptionJob.perform_later
        puts "Prompt business renew subscription email sent to #{ candidates.count } candidates"
      end

    when 'update.user_following'
      if ENV["DOMAIN"] == "muqawiloon.com"
        candidates = PromptBusinessRenewSubscriptionJob.perform_later
        puts "Update user following sent to #{ candidates.count } candidates"
      end

    when 'update.sendgrid_contact_lists'
      if ENV["DOMAIN"] == "muqawiloon.com"
        UpdateSendgridContactListsJob.perform_later
        puts "Updated sendgrid contact lists"
      end

    when 'clockwork.running'
      puts 'Clockwork is running normally.'

    else
      puts 'No job was run.'

    end
  end

  #log that clockwork is running
  every(1.hour, 'clockwork.running')

  #regenerate sitemap
  every(12.hours, 'refresh.sitemap')

  #email businesses that are inactive
  every(1.day, 'prompt.inactive_businesses', at: '8:00')

  #email businesses that have outstanding quote requests
  every(1.day, 'prompt.outstanding_quote_requests', at: '8:30')

  #email user to check quotes
  every(1.day, 'prompt.user_check_quotes', at: '10:00')

  #email user to update profile
  every(1.day, 'prompt.user_update', at: '12:00')

  #email business to complete profile
  every(1.day, 'prompt.business_incomplete_profile', at: '12:30')

  #email business to update profile
  every(1.day, 'prompt.busines_update', at: '12:00')

  #email business about new projects
  every(1.day, 'update.business_new_projects', at: '13:00')

  #email user to upgrade
  every(1.day, 'prompt.user_upgrade', at: '14:00')

  #email user to upgrade
  every(1.day, 'prompt.business_upgrade', at: '14:30')

  #email business to renew subscription
  every(1.day, 'prompt.business_renew_subscription', at: '16:00')

  #email user to renew subscription
  every(1.day, 'prompt.user_renew_subscription', at: '16:00')

  #email users about businesses and listings they follow
  every(30.days, 'update.user_following', at: '17:00')

  #email users about businesses and listings they follow
  every(3.days, 'update.sendgrid_contact_lists', at: '00:00')

end
