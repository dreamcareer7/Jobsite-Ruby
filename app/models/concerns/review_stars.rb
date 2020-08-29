module ReviewStars
  extend ActiveSupport::Concern

  MAXIMUM_STARS = 5

  def full_stars
    self.average_review_score.to_i
  end

  def half_star
    self.average_review_score.round.to_i > self.average_review_score.to_i ? 1 : 0
  end

  def empty_stars
    MAXIMUM_STARS - (full_stars + half_star)
  end

  def review_stars_to_s
    if average_review_score > 4.5
      "| Highly recommended"
    elsif average_review_score >= 4
      "| Recommended"
    elsif average_review_score >= 3
      "| Good"
    else
      ""
    end
  end

end
