module UserHelpers

  def user_logs_in(traits = nil)
    user = FactoryGirl.create(:user, traits)

    login_as(user, scope: :user)
    visit user_profile_index_path

    return user
  end

end
