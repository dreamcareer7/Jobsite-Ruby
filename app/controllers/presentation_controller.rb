class PresentationController < ApplicationController

  def presentation
    pdf_filename = File.join(Rails.root, "app/assets/images/presentation/muqawiloon.pdf")
    send_file(pdf_filename, filename: "muqawiloon.pdf", type: "application/pdf", disposition: "inline")
  end

end
