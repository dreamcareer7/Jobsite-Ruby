category = Category.find_by name: "Contractors"
	x = category.sub_categories.create(name: "General Contractors")
	x.attributes = { name: "ترجم", locale: :ar }
	x.save!

	x = category.sub_categories.create(name: "Building Contractors")
	x.attributes = { name: "ترجم", locale: :ar }
	x.save!

	x = category.sub_categories.create(name: "Civil Works Contractors")
	x.attributes = { name: "ترجم", locale: :ar }
	x.save!

	x = category.sub_categories.create(name: "Mechanical Contractors")
	x.attributes = { name: "ترجم", locale: :ar }
	x.save!

	x = category.sub_categories.create(name: "Electrical Contractors")
	x.attributes = { name: "ترجم", locale: :ar }
	x.save!

	x = category.sub_categories.create(name: "Specialist Contractors")
	x.attributes = { name: "ترجم", locale: :ar }
	x.save!

category = Category.find_by name: "Machinery"
	category.sub_categories.create(name: "Earth Moving Machinery")
	category.sub_categories.create(name: "Light Machinery")
	category.sub_categories.create(name: "Building Material Machinery")
	category.sub_categories.create(name: "Cranes")
	category.sub_categories.create(name: "Road Machinery")
	category.sub_categories.create(name: "Spare Parts")
	category.sub_categories.create(name: "Machinery Service Centre")

category = Category.find_by name: "Suppliers"
	category.sub_categories.create(name: "Building and Construction")
	category.sub_categories.create(name: "Tools and Hardware")
	category.sub_categories.create(name: "Landscaping and Garden")
	category.sub_categories.create(name: "Electro-Mechanical")
	category.sub_categories.create(name: "Plumbing")
	category.sub_categories.create(name: "Wood materials")

sub_cat_types = ["General", "Building", "Civil", "Mechanical", "Electrical", "Specialist"]

category = Category.find_by name: "Consultants"
  sub_cat_types.each do |cat_type|
    category.sub_categories.create(name: "#{ cat_type } Consultants")
  end
category = Category.find_by name: "Specialists"
  sub_cat_types.each do |cat_type|
    category.sub_categories.create(name: "#{ cat_type } Specialists")
  end
category = Category.find_by name: "Municipal"
  sub_cat_types.each do |cat_type|
    category.sub_categories.create(name: "#{ cat_type } Municipal")
  end
