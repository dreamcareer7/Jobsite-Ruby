PROFESSIONAL_TYPES = ['Civil works',
                      'Commercial space',
                      'Governmental',
                      'Historical/Heritage site',
                      'Residential home and apartment',
                      'Hotel and resort',
                      'Industrial facility',
                      'Luxury estate',
                      'Mixed use development project',
                      'New build',
                      'Offshore marine project',
                      'Plot of land',
                      'Renovation/Restoration',
                      'Restaurant and kitchen',
                      'Sky scraper and mega structure',
                      'Small space']

SUPPLIER_TYPES = ['Official authorised distributor',
                  'Delivery to location',
                  'International brand',
                  'Large orders',
                  'Retail purchase',
                  'Warantee available']

MACHINERY_TYPES = ['Official authorised distributor',
                   'Delivery to location',
                   'Hire with operator',
                   'Insurance policy available',
                   'International brand',
                   'New',
                   'Training services',
                   'Used',
                   'Warantee available']

PROFESSIONAL_TYPES.each do |pro_type|
  ProjectType.create(name: pro_type, category_type: :professional)
end

SUPPLIER_TYPES.each do |pro_type|
  ProjectType.create(name: pro_type, category_type: :supplier)
end

MACHINERY_TYPES.each do |pro_type|
  ProjectType.create(name: pro_type, category_type: :machinery)
end
