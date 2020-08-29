CITIES = [
  { name: "Riyadh", latitude: 24.713552, longitude: 46.675296, translation: "الرياض" },
  { name: "Jeddah", latitude: 21.285407, longitude: 39.237551, translation: "جدة", },
  { name: "Medinah", latitude: 24.524654, longitude: 39.569184, translation: "المدينة المنورة" },
  #{ name: "Mecca", latitude: 21.389082, longitude: 39.857912 },
  #{ name: "Hofuf", latitude: 25.314156, longitude: 49.629908 },
  #{ name: "Ta'if", latitude: 21.437273, longitude: 40.512714 },
  #{ name: "Dammam", latitude: 26.392667, longitude: 49.977714 },
  #{ name: "Khamis Mushait", latitude: 18.309339, longitude: 42.766233 },
  #{ name: "Buraidah", latitude: 26.359231, longitude: 43.981812 },
  #{ name: "Khobar", latitude: 26.217191, longitude: 50.197138 },
  #{ name: "Tabuk", latitude: 28.383508, longitude: 36.566191 },
  #{ name: "Ha'il", latitude: 27.511410, longitude: 41.720824 },
  #{ name: "Hafar Al-Batin", latitude: 28.359521, longitude: 45.942012 },
  #{ name: "Jubail", latitude: 26.959771, longitude: 49.568742 },
  #{ name: "Al-Kharj", latitude: 24.145537, longitude: 47.311945 },
  #{ name: "Qatif", latitude: 26.576492, longitude: 49.998236 },
  #{ name: "Abha", latitude: 18.246468, longitude: 42.511724 },
  #{ name: "Najran", latitude: 17.565604, longitude: 44.228944 },
  #{ name: "Yanbu", latitude: 24.023176, longitude: 38.189978 },
  #{ name: "Al Qunfundhah", latitude: 19.128140, longitude: 41.078739 }
]

EGYPT = ["Cairo", "Alexandria"]
SAUDI_ARABIA = ["Makkah", "Dammam", "Madinah", "Al Khobar", "Tabuk", "Al Jubail", "Al Qasim"]
UAE = ["Dubai", "Abu Dhabi", "Al Ain", "Sharjah", "Doha"]
KUWAIT = ["Al Ahmadi", "Kuwait City"]
JORDAN = ["Aqaba", "Amman"]
OMAN = ["Muscat", "Salalah"]
BAHRAIN = ["Manama", "Al Budayyi", "Al Muharraq"]
TURKEY = ["Ankara", "Izmir", "Antalya", "Istanbul"]
MOROCCO = ["Rabat"]
LEBANON = ["Beirut"]
NIGERIA = ["Lagos"]

CITIES.each do |city|
  country = Country.find_by name: "Saudi Arabia"

  new_city = country.cities.create(
    name: city[:name],
    latitude: city[:latitude],
    longitude: city[:longitude]
  )

  new_city.attributes = { name: city[:translation], locale: :ar }
  new_city.save
end

EGYPT.each do |city|
  country = Country.find_by name: "Egypt"
  country.cities.create(name: city)
end

SAUDI_ARABIA.each do |city|
  country = Country.find_by name: "Saudi Arabia"
  country.cities.create(name: city)
end

UAE.each do |city|
  country = Country.find_by name: "United Arab Emirates"
  country.cities.create(name: city)
end

KUWAIT.each do |city|
  country = Country.find_by name: "Kuwait"
  country.cities.create(name: city)
end

JORDAN.each do |city|
  country = Country.find_by name: "Jordan"
  country.cities.create(name: city)
end

OMAN.each do |city|
  country = Country.find_by name: "Oman"
  country.cities.create(name: city)
end

BAHRAIN.each do |city|
  country = Country.find_by name: "Bahrain"
  country.cities.create(name: city)
end

TURKEY.each do |city|
  country = Country.find_by name: "Turkey"
  country.cities.create(name: city)
end

MOROCCO.each do |city|
  country = Country.find_by name: "Morocco"
  country.cities.create(name: city)
end

LEBANON.each do |city|
  country = Country.find_by name: "Lebanon"
  country.cities.create(name: city)
end

NIGERIA.each do |city|
  country = Country.find_by name: "Nigeria"
  country.cities.create(name: city)
end
