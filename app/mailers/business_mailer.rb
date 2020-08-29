class BusinessMailer < ApplicationMailer
  include MailerHelper

  ##GENERAL##
  
  def welcome_business(business)
    @business = business

    setup_email({ "-name-": [@business.name] }, 'ef1598a8-3f74-4704-ad69-23ae158bbc51')
    deliver_email(@business.user.email, "Welcome to Muqawiloon!")
  end

  def business_approved(business)
    @business = business

    setup_email({ "-business_name-": [@business.name] }, '4afe8d50-f893-4d9c-a5ee-9d3582954da7')
    deliver_email(@business.user.email, "Your business has been approved!")
  end

  def update_profile_prompt(buisness)
    @business = business

    setup_email({ "-name-": [@business.name] }, 'b624869e-a12b-49ff-bfcd-88297d56f404')
    deliver_email(@business.user.email, "Consider updating your profile")
  end

  def incomplete_prompt(business)
    @business = business

    setup_email({ "-name-": [@business.name] }, 'fbc4db09-0a9e-40db-b5b1-75cbef47fda5')
    deliver_email(@business.user.email, "Consider updating your profile")
  end

  def inactive_prompt(business)
    @business = business

    setup_email({ "-name-": [@business.name] }, 'c6b19252-c062-4cb1-9c67-2bc7acd00f5b')
    deliver_email(@business.user.email, "Come back to Muqawiloon")
  end

  def prompt_upgrade(business)
    @business = business

    setup_email({ "-name-": [@business.name] }, '82f4ba52-78ba-4fc1-9b39-236d91fc12fe')
    deliver_email(@business.email, "Consider upgrading your account")
  end

  def business_upgraded(business, subscription)
    @business = business
    @subscription = subscription

    setup_email({
      "-name-": [@business.name],
      "-subscription_type-": [@subscription.subscription_type.capitalize],
      "-expiry_date-": [@subscription.expiry_date.strftime('%B %d, %Y')],
      "-amount_paid-": [number_to_currency(@subscription.amount_paid)]
    }, '8e482768-3e78-4685-a5fe-a20591097c9e')
    deliver_email(@business.user.email, "Your account has been upgraded!")
  end

  def renew_subscription(business)
    @business = business

    setup_email({ "-name-": [@business.name] }, 'c5d62848-d5e1-40b4-920f-68289707b5b1')
    deliver_email(@business.user.email, "Your subscription expires soon")
  end

  ##PROJECT##

  def invited(project, business)
    @project = project
    @business = business

    setup_email({
      "-name-": [@business.name],
      "-project_user_name-": [@project.user.name],
      "-project_name-": [@project.title]
    }, '2d7ab5b3-b524-4c8c-93a2-8ae362ab39ca')
    deliver_email(@business.user.email, "You were invited to a project")
  end

  def shortlisted(project, business)
    @project = project
    @business = business

    setup_email({
      "-name-": [@business.name],
      "-project_user_name-": [@project.user.name],
      "-project_name-": [@project.title]
    }, 'd265c48c-c947-44f2-b55f-d105d270cb5a')
    deliver_email(@business.user.email, "You were shortlisted for a project")
  end

  def hired(project, business)
    @project = project
    @business = business

    setup_email({
      "-name-": [@business.name],
      "-project_user_name-": [@project.user.name],
      "-project_name-": [@project.title]
    }, '531572b6-f9ed-4191-9acc-0e081420d85e')
    deliver_email(@business.user.email, "You were hired to a project")
  end

  def completed(project, business)
    @project = project
    @business = business

    setup_email({
      "-name-": [@business.name],
      "-project_user_name-": [@project.user.name],
      "-project_name-": [@project.title]
    }, 'e29ca547-bd0b-45f9-aa67-40c5d130f0bd')
    deliver_email(@business.user.email, "A project you worked on is complete")
  end

  def new_review(review)
    @business = review.business

    setup_email({ "-name-": [@business.name] }, '510b5eb5-0354-4ec2-b482-4e66ac366d65')
    deliver_email(@business.user.email, "Your business has a new review")
  end

  def cancelled(project, business)
    @project = project
    @business = business

    setup_email({
      "-name-": [@business.name],
      "-project_user_name-": [@project.user.name],
      "-project_name-": [@project.title]
    }, '76e23904-6424-4bc6-a069-4b3a63dc6c79')
    deliver_email(@business.user.email, "A project you were working on has been cancelled")
  end

  def outstanding_quote_requests(business)
    @business = business

    setup_email({
      "-name-": [@business.name],
    }, 'edf416f7-723f-4b24-9d67-fb3aea28eb0c')
    deliver_email(@business.user.email, "You have outstanding quote requests")
  end

  def disabled(business)
    @business = business

    setup_email({
      "-name-": [@business.user.name],
      "-business_name-": [@business.name],
      "-contact_link-": ['https://www.muqawiloon.com/pages/contact'],
    }, '4d98f940-acdf-4139-aca9-419f34617b15')
    deliver_email(@business.user.email, "Your business has been disabled.")
  end

  def new_projects(business, projects)
    @business = business

    setup_email({
      "-name-": [@business.user.name],
      "-business_name-": [@business.name],
      "-project_one_name-": [projects[0].title],
      "-project_two_name-": [project[1].present? ? projects[1].title : ''],
      "-project_three_name-": [project[2].present? ? projects[2].title : ''],
      "-projects_link-": ["https://muqawiloon.com/business/project_feed/"]
    }, '6b4a26d1-2c0a-42bd-91ae-6f2ab4e28be2')
    deliver_email(@business.user.email, "Check out these new projects on Muqawiloon!")
  end

end
