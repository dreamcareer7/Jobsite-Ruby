puts "creating photos..."
Business.by_city(City.find_by name: "Jeddah").all.shuffle.first(10).each do |business|
  business.banner = File.new("#{Rails.root}/app/assets/images/missing/business_banner.jpg")

  business.save
end

SelfAddedProject.all.shuffle.first(10).each do |project|
  project.image_one = File.new("#{Rails.root}/app/assets/images/missing/project_image1.png")
  project.image_two = File.new("#{Rails.root}/app/assets/images/missing/project_image2.png")
  project.image_three = File.new("#{Rails.root}/app/assets/images/missing/project_image3.jpg")

  project.save
end
