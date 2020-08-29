class AdminMailer < ActionMailer::Base
  layout 'mailer'

  def new_business(business)
    @business = business

    mail(
      to: 'info@muqawiloon.com',
      from: "\"Muqawiloon\" <info@muqawiloon.com>",
      subject: "A new business has been added"
    )
  end

  def new_project(project)
    @project = project

    mail(
      to: 'info@muqawiloon.com, projects@muqawiloon.com',
      from: "\"Muqawiloon\" <info@muqawiloon.com>",
      subject: "A new project has been added"
    )
  end

  def project_completed(project)
    @project = project

    mail(
      to: 'info@muqawiloon.com, projects@muqawiloon.com',
      from: "\"Muqawiloon\" <info@muqawiloon.com>",
      subject: "A project has been completed"
    )
  end

  def project_cancelled(project)
    @project = project

    mail(
      to: 'info@muqawiloon.com, projects@muqawiloon.com',
      from: "\"Muqawiloon\" <info@muqawiloon.com>",
      subject: "A project has been cancelled"
    )
  end

  def business_hired(project, business)
    @project = project
    @business = business

    mail(
      to: 'info@muqawiloon.com',
      from: "\"Muqawiloon\" <info@muqawiloon.com>",
      subject: "A business has been hired"
    )
  end

  def business_shortlisted(project, business)
    @project = project
    @business = business

    mail(
      to: 'info@muqawiloon.com, projects@muqawiloon.com',
      from: "\"Muqawiloon\" <info@muqawiloon.com>",
      subject: "A business has been shortlisted"
    )
  end

end
