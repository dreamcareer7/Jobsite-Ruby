module SocialUrlHelper
  def full_path(url)
    /^http/i.match(url) ? url : "http://#{url}"
  end
end
