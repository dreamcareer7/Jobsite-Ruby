COUNTRIES = ["Saudi Arabia", "Egypt", "United Arab Emirates", "Qatar", "Kuwait", "Jordan", "Oman", "Bahrain", "Turkey", "Morocco", "Lebanon", "Nigeria"]

COUNTRIES.each do |country|
  Country.create(name: country)
end
