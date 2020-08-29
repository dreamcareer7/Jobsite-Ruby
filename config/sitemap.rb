# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://#{ ENV['DOMAIN'] }"
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.sitemaps_host = "https://s3.#{ ENV['S3_REGION'] }.amazonaws.com/#{ ENV['S3_SITEMAP_BUCKET'] }/"
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(fog_provider: 'AWS',
                                                                    aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
                                                                    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
                                                                    fog_directory: ENV['S3_SITEMAP_BUCKET'],
                                                                    fog_region: ENV['S3_REGION'],
                                                                    fog_path_style: true)

categories = Category.all
sub_categories = SubCategory.visible
services = Service.visible
businesses = Business.active.includes(cities: :translations)

SitemapGenerator::Sitemap.create do

  City.all.each do |city|
    add root_path(city: city.name), changefreq: 'always', priority: 1
    add categories_path(city: city.name), changefreq: 'always', priority: 0.8

    categories.each do |category|
      add category_path(category, city: city.name), lastmod: category.updated_at, changefreq: 'always', priority: 0.9
    end

    sub_categories.each do |sub_category|
      add sub_category_path(sub_category, city: city.name), lastmod: sub_category.updated_at, changefreq: 'always', priority: 0.9
    end

    services.each do |service|
      add service_path(service, city: city.name), lastmod: service.updated_at, changefreq: 'always', priority: 0.9
    end

  end

  businesses.each do |business|
    business.cities.distinct.each do |city|
      add business_path(business, city: city.name), lastmod: business.updated_at, changefreq: 'always', priority: 0.9
    end
  end

  add '/pages/about'
  add '/pages'
  add '/gallery'
  add '/cities', changefreq: 'always', priority: 1

end
