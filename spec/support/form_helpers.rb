module FormHelpers
  def submit_form
    find('input[name="commit"]', match: :first, visible: true).click
  end
end
