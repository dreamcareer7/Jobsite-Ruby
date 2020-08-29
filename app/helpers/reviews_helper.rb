module ReviewsHelper

  MAXIMUM_STARS = 5

  def full_stars
    self.average_score.to_i
  end

  def half_star
    return unless self.is_a?(Review)

    self.average_score.round.to_i > self.average_score.to_i ? 1 : 0
  end

  def empty_stars
    MAXIMUM_STARS - (full_stars + half_star)
  end

  def full_stars_by_type(score_type)
    self.send(score_type)
  end

  def empty_stars_by_type(score_type)
    MAXIMUM_STARS - self.send(score_type)
  end

end
