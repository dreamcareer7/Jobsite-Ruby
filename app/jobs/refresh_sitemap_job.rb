class RefreshSitemapJob < ApplicationJob
  require 'sitemap_generator'
  queue_as :default

  def perform
    SitemapGenerator::Interpreter.run
  end

end
