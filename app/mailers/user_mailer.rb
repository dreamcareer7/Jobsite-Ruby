class UserMailer < ApplicationMailer
  include MailerHelper

  ##GENERAL##
  
  def welcome_user(user)
    @user = user

    setup_email({ "-name-": [@user.name] }, 'ef1598a8-3f74-4704-ad69-23ae158bbc51')
    deliver_email(@user.email, "Welcome to Muqawiloon!")
  end

  def business_model(user)
    @user = user

    setup_email({ "-name-": [@user.name] }, '0ea34943-21f9-4508-a0fd-89ff5df3657a')
    deliver_email(@user.email, "Muqawiloon business model")
  end

  def prompt_upgrade(user)
    @user = user

    setup_email({ "-name-": [@user.name] }, '82f4ba52-78ba-4fc1-9b39-236d91fc12fe')
    deliver_email(@user.email, "Consider upgrading your account")
  end

  def prompt_update(user)
    @user = user

    setup_email({ "-name-": [@user.name] }, 'fbc4db09-0a9e-40db-b5b1-75cbef47fda5')
    deliver_email(@user.email, "Consider updating your profile")
  end

  def user_upgraded(user, subscription)
    @user = user
    @subscription = subscription

    setup_email({
      "-name-": [@user.name],
      "-expiry_date-": [@subscription.expiry_date.strftime('%B %d, %Y')],
      "-amount_paid-": [number_to_currency(@subscription.amount_paid)]
    }, 'c9817cad-d0e3-41be-8a9c-d01973b47358')
    deliver_email(@user.email, "Your account has been upgraded!")
  end

  def renew_subscription(user)
    @user = user

    setup_email({ "-name-": [@user.name] }, 'c5d62848-d5e1-40b4-920f-68289707b5b1')
    deliver_email(@user.email, "Your subscription expires soon")
  end

  def update_following(user)
    @user = user
    @city = City.find(@user.browse_location).name
    @listing = user.follows.where("follow_target_type = ? OR follow_target_type = ?", "Service", "SubCategory").shuffle.first
    @business = user.follows.where(follow_target_type: "Business").shuffle.first

    return unless @listing.present? || @business.present?

    if @listing.present? && @business.present?
      @listing = @listing.follow_target
      @business = @business.follow_target
      setup_email({
        "-name-": [@user.name],
        "-follow_target_one-": [@listing.name],
        "-follow_target_one_link-": ["https://www.muqawiloon.com/#{ @city }/#{ @listing.class }/#{ @listing.name }"],
        "-follow_target_two-": [@business.name],
        "-follow_target_two_link-": ["https://www.muqawiloon.com/#{ @city }/businesses/#{ @business.name }"],
      }, '11100d5d-5a05-41f6-b236-864fb67b2251')
    elsif @listing.present?
      @listing = @listing.follow_target
      setup_email({
        "-name-": [@user.name],
        "-follow_target-": [@listing.name],
        "-follow_target_link-": ["https://www.muqawiloon.com/#{ @city }/#{ @listing.class }/#{ @listing.name }"],
      }, '5a2329ba-44d6-4471-a943-1c7a305d942e')
    else
      @business = @business.follow_target
      setup_email({
        "-name-": [@user.name],
        "-follow_target-": [@business.name],
        "-follow_target_link-": ["https://www.muqawiloon.com/#{ @city }/businesses/#{ @business.name }"],
      }, '6fabb499-bde8-4482-a303-9c3e34e077e3')
    end

    deliver_email(@user.email, "An update on the businesses and listings you follow")
  end

  ##PROJECT##

  def new_applicant(project, business)
    @user = project.user
    setup_email({
      "-name-": [project.user.name],
      "-business_name-": [business.name],
    }, '4d6b87f2-f82e-41d0-aa21-3a5071e6f9f8')
    deliver_email(@user.email, "Your project has a new applicant")
  end

  def new_quote(quote)
    @quote = quote
    @user = @quote.project.user

    setup_email({
      "-name-": [@user.name],
      "-approximate_budget-": [@quote.approximate_budget],
      "-approximate_duration-": [@quote.approximate_duration],
      "-proposal-": [@quote.proposal],
      "-project_link-": ["https://#{ENV['DOMAIN']}/user/projects/#{@quote.project.id}"]
    }, 'b7959bc2-8137-48cf-9cf8-1a340c4eafdb')
    deliver_email(@user.email, "Your project has a new quote")
  end

  def check_quotes(project)
    @project = project
    @user = @project.user

    setup_email({
      "-name-": [@user.name],
      "-project_name-": [@project.title]
    }, '65b15ac3-a1f1-4b15-aee5-e10b71678363')
    deliver_email(@user.email, "Your project has new quotes")
  end

  def project_posted(project)
    @project = project
    @user = @project.user

    setup_email({
      "-name-": [@user.name],
      "-project_name-": [@project.title]
    }, 'b6e574bd-7a6a-4e1b-bdc9-3576a0af6b4d')
    deliver_email(@user.email, "Your project has been posted")
  end

  def marked_complete(project)
    @project = project
    @user = @project.user

    setup_email({
      "-name-": [@user.name],
      "-project_name-": [@project.title]
    }, '22fe5992-72ab-4a18-bb76-eb15151e753c')
    deliver_email(@user.email, "Your project has been marked as complete")
  end

  def completed_follow_up(project)
    @project = project
    @user = @project.user

    setup_email({
      "-name-": [@user.name],
      "-project_name-": [@project.title]
    }, 'b77173eb-6666-485c-ab65-8c4c100db388')
    deliver_email(@user.email, "Your project has been marked as complete")
  end

  def cancelled(project)
    @project = project
    @user = @project.user

    setup_email({
      "-name-": [@user.name],
      "-project_name-": [@project.title]
    }, 'a44e2cb1-b740-44f8-917f-bdd9f2457fa7')
    deliver_email(@user.email, "Your project has been cancelled")
  end

  def business_received_project(project)
    @project = project
    @user = project.user
    @businesses = Business.by_city(@project.city).by_category(@project.category).shuffle.first(3)

    return unless @businesses.present? && @businesses.length == 3

    setup_email({
      "-name-": [@user.name],
      "-project_name-": [@project.title],
      "-business_one-": [@businesses[0].name],
      "-business_two-": [@businesses[1].name],
      "-business_three-": [@businesses[2].name],
    }, 'c03f4842-076c-40b0-ac3f-4c6917497a81')
    deliver_email(@user.email, "Businesses are looking at your project")
  end

  def project_deleted(project)
    @project = project
    @user = @project.user

    setup_email({
      "-name-": [@user.name],
      "-project_name-": [@project.title]
    }, '62a44f16-1f65-4d11-8cd3-e78a84f92340')
    deliver_email(@user.email, "Your project has been removed")
  end

end
