module VideoUrlHelper

  def handle_video_url
    self.self_added_projects.where.not(video_link: nil).each do |project|
      format_video_link(project)
    end
  end

  def format_video_link(project)
    target_link = project.video_link

    youtube_id = get_youtube_id(target_link)

    if youtube_id.present?
      formatted_link = "https://www.youtube.com/embed/#{ youtube_id[1] }"
    end

    project.update_attributes(video_link: formatted_link)

  end


  def get_thumbnail(video)
    youtube_id = get_youtube_id(video)

    if youtube_id.present?
      "http://img.youtube.com/vi/#{ youtube_id[1] }/0.jpg"
    end
  end

  def get_youtube_id(target_link)
    /(?:https?:\/\/)?(?:www\.)?youtu\.?be(?:\.com)?\/?.*(?:watch|embed)?(?:.*v=|v\/|\/)([\w\-_]+)\&?/.match(target_link)
  end

end
