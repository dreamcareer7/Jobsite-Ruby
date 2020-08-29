contractor = Category.create(name: "Contractors")
supplier = Category.create(name: "Suppliers")
machinery = Category.create(name: "Machinery")
consultants = Category.create(name: "Consultants")
specialists = Category.create(name: "Specialists")
municipal = Category.create(name: "Municipal")

contractor.attributes = { name: "مقاول", locale: :ar }
contractor.save!
supplier.attributes = { name: "المورد", locale: :ar }
supplier.save!
machinery.attributes = { name: "آلية", locale: :ar }
machinery.save!
consultants.attributes = { name: "الاستشاريين", locale: :ar }
consultants.save!
specialists.attributes = { name: "المتخصصين", locale: :ar }
specialists.save!
municipal.attributes = { name: "محلي", locale: :ar }
municipal.save!
