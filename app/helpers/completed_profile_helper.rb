module CompletedProfileHelper

  def percentage_to_colour(profile)
    return 'u-text-accent' if profile.nil?

    if profile >= 75
      'u-text-positive'
    elsif profile >= 50
      'u-text-yellow'
    else
      'u-text-accent'
    end
  end

end
