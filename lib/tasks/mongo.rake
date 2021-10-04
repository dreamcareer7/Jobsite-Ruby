namespace :mongo do
  task :migrate => :environment do
    # client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'muqawiloon')
    client = Mongo::Client.new(ENV["MONGO_DATABASE_URL"])
    db=client.database

    admins = db[:admins]
    admin_keys = Admin.new.attributes.keys
    Admin.all.each do |admin|
      doc = {}
      admin_keys.each do |key|
        newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
        puts newKey
        if newKey == 'name'
          doc[newKey] = {ar: admin[key], en: admin[key]}
        elsif newKey.include? 'IP'
          doc[newKey] = admin[key].to_s
        else
          doc[newKey] = admin[key].to_s
        end
      end
      result = admins.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    collection = db[:banners]
    keys = Banner.new.attributes.keys
    Banner.all.each do |object|
      doc = {}
      keys.each do |key|
        newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
        doc[newKey] = object[key]
      end
      if object.image_en.exists?
        doc['ImageEnFileUrl'] = object.image_en.url
      end
      if object.image_ar.exists?
        doc['ImageArFileUrl'] = object.image_ar.url
      end
      result = collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    collection = db[:categories]
    keys = Category.new.attributes.keys
    Category.all.each do |object|
      doc = {}
      keys.each do |key|
        newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
        if newKey == 'name'
          I18n.locale = :ar
          ar_name = object.name
          I18n.locale = :en
          en_name = object.name
          doc[newKey] = {ar: ar_name, en: en_name}
        else
          doc[newKey] = object[key]
        end
      end
      result = collection.replace_one({slug: doc['slug']}, doc, {upsert: true})
    end

    collection = db[:subcategories]
    keys = SubCategory.new.attributes.keys
    SubCategory.all.each do |object|
      doc = {}
      keys.each do |key|
        newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
        if newKey == 'name'
          I18n.locale = :ar
          ar_name = object.name
          I18n.locale = :en
          en_name = object.name
          doc[newKey] = {ar: ar_name, en: en_name}
        elsif newKey == 'categoryId'
          newKey = 'parent'
          doc[newKey] = db[:categories].find({id: object[key]}).first[:_id]
          doc[key] = object[key]
        else
          doc[newKey] = object[key]
        end
      end
      result = collection.replace_one({slug: doc['slug']}, doc, {upsert: true})
    end

    collection = db[:services]
    keys = Service.new.attributes.keys
    Service.all.each do |object|
      doc = {}
      keys.each do |key|
        newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
        if newKey == 'name'
          I18n.locale = :ar
          ar_name = object.name
          I18n.locale = :en
          en_name = object.name
          doc[newKey] = {ar: ar_name, en: en_name}
        elsif newKey == 'subCategoryId'
          newKey = 'parent'
          if [83, 108, 109, 110, 111, 112].include? object[key]
            doc[newKey] = db[:subcategories].find({slug: 'none'}).first[:_id]
          else
            doc[newKey] = db[:subcategories].find({id: object[key]}).first[:_id]
          end
          doc[key] = object[key]
        else
          doc[newKey] = object[key]
        end
      end
      result = collection.replace_one({slug: doc['slug']}, doc, {upsert: true})
    end

    countries = db[:countries]
    countries_keys = Country.new.attributes.keys
    Country.all.each do |country|
      doc = {}
      countries_keys.each do |key|
        newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
        if newKey == 'name'
          I18n.locale = :ar
          ar_name = country.name
          I18n.locale = :en
          en_name = country.name
          doc[newKey] = {ar: ar_name, en: en_name}
        else
          doc[newKey] = country[key]
        end
      end
      result = countries.replace_one({"name.en": doc['name']['en']}, doc, {upsert: true})
    end


    cities = db[:cities]
    cities_keys = City.new.attributes.keys
    City.all.each do |city|
      doc = {}
      cities_keys.each do |key|
        newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
        if newKey == 'name'
          I18n.locale = :ar
          ar_name = city.name
          I18n.locale = :en
          en_name = city.name
          doc[newKey] = {ar: ar_name, en: en_name}
        elsif newKey == 'countryId'
          doc[newKey] = db[:countries].find({id: city[key]}).first[:_id]
          doc[key] = city[key]
        else
          doc[newKey] = city[key]
        end
      end

      if city.banner.exists?
        doc['BannerFileUrl'] = city.banner.url
      end

      result = cities.replace_one({slug: doc['slug']}, doc, {upsert: true})
    end

    collection = db[:certifications]
    certifications_keys = Certification.new.attributes.keys
    Certification.all.each do |object|
      doc = {}
      certifications_keys.each do |key|
        newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
        if newKey == 'countryId'
          begin
          doc[newKey] = db[:countries].find({id: object[key]}).first[:_id]
          rescue
          end

          doc[key] = object[key]
        else
          doc[newKey] = object[key]
        end
      end
      if object.logo.exists?
        doc['LogoFileUrl'] = object.logo.url
      end
      result = collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    # adminCities = db[:admincities]
    # adminCities_key = AdminCity.new.attributes.keys
    # AdminCity.all.each do |admin_city|
    #   doc = {}
    #   adminCities_key.each do |key|
    #     newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
    #     if newKey == 'adminId'
    #       begin
    #         doc[newKey] = db[:admins].find({id: admin_city[key]}).first[:_id]
    #       rescue
    #       end
    #
    #       doc[key] = admin_city[key]
    #     elsif newKey == 'cityId'
    #       begin
    #       doc[newKey] = db[:cities].find({id: admin_city[key]}).first[:_id]
    #       rescue
    #       end
    #       doc[key] = admin_city[key]
    #     else
    #       doc[newKey] = admin_city[key]
    #     end
    #   end
    #   result = adminCities.replace_one({id: doc['id']}, doc, {upsert: true})
    # end
    #
    #
    # adminCountries = db[:admincountries]
    # adminCountries_keys = AdminCountry.new.attributes.keys
    # AdminCountry.all.each do |admin_country|
    #   doc = {}
    #   adminCountries_keys.each do |key|
    #     newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
    #     if newKey == 'adminId'
    #       begin
    #         doc[newKey] = db[:admins].find({id: admin_country[key]}).first[:_id]
    #       rescue
    #       end
    #       doc[key] = admin_country[key]
    #     elsif newKey == 'countryId'
    #       begin
    #         doc[newKey] = db[:countries].find({id: admin_country[key]}).first[:_id]
    #       rescue
    #       end
    #       doc[key] = admin_country[key]
    #     else
    #       doc[newKey] = admin_country[key]
    #     end
    #   end
    #   result = adminCountries.replace_one({id: doc['id']}, doc, {upsert: true})
    # end

    collection = db[:industries]
    User::industries.each do |value, index|
      doc = {}
      doc['name'] = {'ar': value, 'en': value}
      doc['id'] = index
      doc['createdAt'] = Time.now
      doc['updatedAt'] = Time.now
      doc['disabled'] = false
      collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    collection = db[:users]
    user_keys = User.new.attributes.keys
    User.all.each do |user|
      doc = {}
      puts '------'
      puts user.industry
      puts '------'
      user_keys.each do |key|
        newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
        if newKey == 'name'
          doc[newKey] = {ar: user[key], en: user[key]}
        elsif newKey == 'industry'
          if user.industry
            industry_id = User::industries[user.industry]
            doc[newKey] = db[:industries].find({id: industry_id}).first[:_id]
            doc['industryid'] = industry_id
          end
        else
          doc[newKey] = user[key]
        end
      end

      if user.profile_image.exists?
        doc['ProfileImageFileUrl'] = user.profile_image.url
      end

      result = collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    collection = db[:businessclasses]
    Business::business_classes.each do |value, index|
      doc = {}
      doc['name'] = {'ar': value, 'en': value}
      doc['id'] = index
      doc['createdAt'] = Time.now
      doc['updatedAt'] = Time.now
      doc['disabled'] = false
      collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    collection = db[:businesstypes]
    Business::business_types.each do |value, index|
      doc = {}
      doc['name'] = {'ar': value, 'en': value}
      doc['id'] = index
      doc['createdAt'] = Time.now
      doc['updatedAt'] = Time.now
      doc['disabled'] = false
      collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    collection = db[:numberofemployees]
    Business::number_of_employees.each do |value, index|
      doc = {}
      doc['name'] = {'ar': value, 'en': value}
      doc['id'] = index
      doc['createdAt'] = Time.now
      doc['updatedAt'] = Time.now
      doc['disabled'] = false
      collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    collection = db[:serviceareas]
    Business::service_areas.each do |value, index|
      doc = {}
      doc['name'] = {'ar': value, 'en': value}
      doc['id'] = index
      doc['createdAt'] = Time.now
      doc['updatedAt'] = Time.now
      doc['disabled'] = false
      collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    collection = db[:projectsizes]
    Business::project_sizes.each do |value, index|
      doc = {}
      doc['name'] = {'ar': value, 'en': value}
      doc['id'] = index
      doc['createdAt'] = Time.now
      doc['updatedAt'] = Time.now
      doc['disabled'] = false
      collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    collection = db[:nbprojectscompleteds]
    Business::nb_projects_completeds.each do |value, index|
      doc = {}
      doc['name'] = {'ar': value, 'en': value}
      doc['id'] = index
      doc['createdAt'] = Time.now
      doc['updatedAt'] = Time.now
      doc['disabled'] = false
      collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    collection = db[:roles]
    BusinessContact::positions.each do |value, index|
      doc = {}
      doc['name'] = {'ar': value, 'en': value}
      doc['id'] = index
      doc['createdAt'] = Time.now
      doc['updatedAt'] = Time.now
      doc['disabled'] = false
      collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end


    collection = db[:businesses]
    business_keys = Business.new.attributes.keys
    location_keys = Location.new.attributes.keys
    Business.all.each do |business|
      doc = {}
      exists_obj = collection.find({id: business.id}).first
      if exists_obj
        business_id = exists_obj[:_id]
      else
        business_id = BSON::ObjectId.new
      end
      doc[:_id] = business_id

      business_keys.each do |key|
        newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
        if newKey == 'name'
          I18n.locale = :ar
          ar_name = business.name
          I18n.locale = :en
          en_name = business.name
          doc[newKey] = {ar: ar_name, en: en_name}
        elsif newKey == 'description'
          I18n.locale = :ar
          ar_desc = business.description
          I18n.locale = :en
          en_desc = business.description
          doc[newKey] = {ar: ar_desc, en: en_desc}
        elsif newKey == 'userId'
          begin
            doc[newKey] = db[:users].find({id: business[key]}).first[:_id]
          rescue
          end

          doc[key] = business[key]
        elsif newKey == 'businessClass'
          bc_id = Business::business_classes[business.business_class]
          begin
          doc[newKey] = db[:businessclasses].find({id: bc_id}).first[:_id]
          rescue
          end

          doc[key] = bc_id
        elsif newKey == 'businessType'
          bc_id = Business::business_types[business.business_type]
          begin
          doc[newKey] = db[:businesstypes].find({id: bc_id}).first[:_id]
          rescue
          end

          doc[key] = bc_id
        elsif newKey == 'serviceArea'
          bc_id = Business::service_areas[business.service_area]
          begin
          doc[newKey] = db[:serviceareas].find({id: bc_id}).first[:_id]
          rescue
          end

          doc[key] = bc_id
        elsif newKey == 'projectSize'
          newKey = 'projectSizeType'
          bc_id = Business::project_sizes[business.project_size]
          begin
          doc[newKey] = db[:projectsizes].find({id: bc_id}).first[:_id]
          rescue
          end

          doc[key] = bc_id
        elsif newKey == 'nbProjectsCompleted'
          bc_id = Business::nb_projects_completeds[business.nb_projects_completed]
          begin
            doc[newKey] = db[:nbprojectscompleteds].find({id: bc_id}).first[:_id]
          rescue
          end

          doc[key] = bc_id
        else
          doc[newKey] = business[key]
        end
      end

      if business.logo.exists?
        doc['LogoFileUrl'] = business.logo.url
      end
      if business.banner.exists?
        doc['BannerFileUrl'] = business.banner.url
      end
      if business.profile_image.exists?
        doc['ProfileImageFileUrl'] = business.profile_image.url
      end

      if business.categories.first
        doc['category'] = db[:categories].find({id: business.categories.first.id}).first[:_id]
      end

      subcategories = []
      business.sub_categories.each do |sub_cate|
        sub_cate_id = db[:subcategories].find({id: sub_cate.id}).first[:_id]
        unless subcategories.include? sub_cate_id
          subcategories.push(sub_cate_id)
        end
      end
      doc['subcategories'] = subcategories

      services = []
      business.services.each do |service|
        service_id = db[:services].find({id: service.id}).first[:_id]
        unless services.include? service_id
          services.push(service_id)
        end
      end
      doc['services'] = services

      # business social links
      doc['fbSocialProfile'] = business.social_links.facebook
      doc['linkedinSocialProfile'] = business.social_links.linkedin
      doc['youtubeSocialProfile'] = business.social_links.youtube
      doc['instaSocialProfile'] = business.social_links.instagram
      doc['googleplusSocialProfile'] = business.social_links.google_plus
      doc['prequalificationSocialProfile'] = business.social_links.prequalification

      # business locations
      location_ids = []
      locations_key = Location.new.attributes.keys
      business.locations.each do |location|
        location_doc = {}

        location_keys.each do |key|
          newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
          if newKey == 'cityId'
            location_doc[newKey] = db[:cities].find({id: location[key]}).first[:_id]
            location_doc[key] = location[key]

            location_doc['countryId'] = db[:countries].find({id: location.city.country_id}).first[:_id]
            location_doc['country_id'] = location.city.country_id
          elsif newKey == 'streetAddress'
            I18n.locale = :ar
            ar_loc = location.street_address
            I18n.locale = :en
            en_loc = location.street_address
            location_doc[newKey] = {ar: ar_loc, en: en_loc}
          else
            location_doc[newKey] = location[key]
          end
        end
        location_doc[:ownerType] = 'businesses'
        location_doc[:ownerId] = business_id
        location_doc[:owner_id] = business.id

        exists_obj = db[:locations].find({id: location.id}).first
        if exists_obj
          location_id = exists_obj[:_id]
        else
          location_id = BSON::ObjectId.new
        end
        location_doc[:_id] = location_id

        result = db[:locations].replace_one({id: location_doc['id']}, location_doc, {upsert: true})
        if result.n == 1
          location_ids.push(location_id)
        end
      end
      doc['locations'] = location_ids

      # business subscriptions
      subscription_ids = []
      subscription_keys = Subscription.new.attributes.keys
      business.subscriptions.each do |subscription|
        subscription_doc = {}
        subscription_keys.each do |key|
          newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
          if newKey == 'userId'
            begin
              subscription_doc[newKey] = db[:users].find({id: subscription[key]}).first[:_id]
            rescue
            end

            subscription_doc[key] = subscription[key]
          else
            subscription_doc[newKey] = subscription[key]
          end
        end

        exists_obj = db[:subscriptions].find({id: subscription.id}).first
        if exists_obj
          subscription_id = exists_obj[:_id]
        else
          subscription_id = BSON::ObjectId.new
        end
        subscription_doc[:_id] = subscription_id

        subscription_doc[:businessId] = business_id
        subscription_doc[:business_id] = business.id

        result = db[:subscriptions].replace_one({id: subscription_doc['id']}, subscription_doc, {upsert: true})
        if result.n == 1
          subscription_ids.push(subscription_id)
        end
      end
      doc['subscriptions'] = subscription_ids

      # business contacts
      business_contact = business.business_contact
      if business_contact
        contact_keys = BusinessContact.new.attributes.keys
        contact_doc = {}
        contact_keys.each do |key|
          newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
          if newKey == 'position'
            bc_id = BusinessContact::positions[business_contact.position]
            begin
              contact_doc[newKey] = db[:roles].find({id: bc_id}).first[:_id]
            rescue
            end

            contact_doc[key] = business_contact[key]
          else
            contact_doc[newKey] = business_contact[key]
          end
        end

        if business_contact.profile_image.exists?
          contact_doc['ProfileImageFileUrl'] = business_contact.profile_image.url
        end

        exists_obj = db[:businesscontacts].find({id: business_contact.id}).first
        if exists_obj
          contact_id = exists_obj[:_id]
        else
          contact_id = BSON::ObjectId.new
        end

        contact_doc[:_id] = contact_id
        result = db[:businesscontacts].replace_one({id: contact_doc['id']}, contact_doc, {upsert: true})
        if result.n == 1
          doc['contacts'] = contact_id
        end
      end

      # business hours
      business_hour = business.hours_of_operation.first
      if business_hour
        hours_keys = HoursOfOperation.new.attributes.keys
        hour_doc = {}
        hours_keys.each do |key|
          if business_hour[key].nil?
            next
          end
          newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
          if newKey.include? 'shift'
            newKey = newKey + 'Hour'
            hour_doc[newKey] = {ar: business_hour[key].strftime('%H:%M'), en: business_hour[key].strftime('%H:%M')}
          elsif newKey.include? 'Day'
            I18n.locale = :ar
            ar_day = business_hour[key]
            I18n.locale = :en
            en_day = business_hour[key]
            hour_doc[newKey] = {ar: ar_day, en: en_day}
          elsif newKey.include? 'Time'
            hour_doc[newKey] = {ar: business_hour[key].strftime('%H:%M'), en: business_hour[key].strftime('%H:%M')}
          elsif newKey == 'locationId'
            hour_doc[newKey] = db[:locations].find({id: business_hour[key]}).first[:_id]
            hour_doc[key] = business_hour[key]
          else
            hour_doc[newKey] = business_hour[key]
          end
        end

        exists_obj = db[:hoursofoperations].find({id: business_hour.id}).first
        if exists_obj
          hour_id = exists_obj[:_id]
        else
          hour_id = BSON::ObjectId.new
        end
        hour_doc[:_id] = hour_id

        hour_doc['businessId'] = business_id
        hour_doc['business_id'] = business.id

        result = db[:hoursofoperations].replace_one({id: hour_doc['id']}, hour_doc, {upsert: true})
        if result.n == 1
          doc['businessHours'] = hour_id
        end
      end

      result = collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    # brands
    collection = db[:brands]
    brands_keys = Brand.new.attributes.keys
    Brand.all.each do |object|
      doc = {}
      brands_keys.each do |key|
        newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
        if newKey == 'businessId'
          begin
            doc[newKey] = db[:businesses].find({id: object[key]}).first[:_id]
          rescue
          end
          doc[key] = object[key]
        else
          doc[newKey] = object[key]
        end
      end
      result = collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    # conversation
    collection = db[:conversations]
    conversations_keys = Conversation.new.attributes.keys
    Conversation.all.each do |object|
      doc = {}
      conversations_keys.each do |key|
        newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
        if newKey.include? 'Id'
          begin
            doc[newKey] = db[:businesses].find({id: object[key]}).first[:_id]
          rescue
          end

          doc[key] = object[key]
        else
          doc[newKey] = object[key]
        end
      end
      result = collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    # followings
    collection = db[:followings]
    user_ids = Follow.distinct.pluck(:user_id)
    user_ids.each do |user_id|
      begin
        user = User.find(user_id)
      rescue
        next
      end


      following_doc = {}
      begin
      ouser_id = db[:users].find({id: user_id}).first[:_id]
      rescue
      end

      subcategory_ids = []
      category_ids = []
      service_ids = []
      business_ids = []

      user.follows.each do |follow|
        if follow.follow_target_type == 'SubCategory'
          begin
          oid = db[:subcategories].find({id: follow.follow_target_id}).first[:_id]
          rescue
          end

          if oid
            subcategory_ids.push(oid)
          end
        end
        if follow.follow_target_type == 'Category'
          begin
          oid = db[:categories].find({id: follow.follow_target_id}).first[:_id]
          rescue
          end

          if oid
            category_ids.push(oid)
          end
        end
        if follow.follow_target_type == 'Service'
          begin
          oid = db[:services].find({id: follow.follow_target_id}).first[:_id]
          rescue
          end

          if oid
            service_ids.push(oid)
          end
        end
        if follow.follow_target_type == 'Business'
          begin
          oid = db[:businesses].find({id: follow.follow_target_id}).first[:_id]
          rescue
          end

          if oid
            business_ids.push(oid)
          end
        end
      end
      following_doc[:userId] = ouser_id
      following_doc[:subcategories] = subcategory_ids
      following_doc[:services] = service_ids
      following_doc[:categories] = category_ids
      following_doc[:businesses] = business_ids
      following_doc['createdAt'] = Time.now
      following_doc['updatedAt'] = Time.now

      result = collection.replace_one({id: following_doc['id']}, following_doc, {upsert: true})
    end


    # photo_gallery
    collection = db[:photogalleries]
    photo_gallery_keys = PhotoGallery.new.attributes.keys
    PhotoGallery.all.each do |object|
      doc = {}
      photo_gallery_keys.each do |key|
        newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
        if newKey == 'ownerId'
          if object.owner_type == 'Business'
            begin
            doc[newKey] = db[:businesses].find({id: object[key]}).first[:_id]
            rescue
            end

          end
          doc[key] = object[key]
        else
          doc[newKey] = object[key]
        end
      end
      result = collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    # project
    collection = db[:locationclasses]
    Project::location_classes.each do |value, index|
      doc = {}
      doc['name'] = {'ar': value, 'en': value}
      doc['id'] = index
      doc['createdAt'] = Time.now
      doc['updatedAt'] = Time.now
      doc['disabled'] = false
      collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    collection = db[:contactroles]
    Project::contact_roles.each do |value, index|
      doc = {}
      doc['name'] = {'ar': value, 'en': value}
      doc['id'] = index
      doc['createdAt'] = Time.now
      doc['updatedAt'] = Time.now
      doc['disabled'] = false
      collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    collection = db[:projectbudgets]
    Project::project_budgets.each do |value, index|
      doc = {}
      doc['name'] = {'ar': value, 'en': value}
      doc['id'] = index
      doc['createdAt'] = Time.now
      doc['updatedAt'] = Time.now
      doc['disabled'] = false
      collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    collection = db[:timelinetypes]
    Project::timeline_types.each do |value, index|
      doc = {}
      doc['name'] = {'ar': value, 'en': value}
      doc['id'] = index
      doc['createdAt'] = Time.now
      doc['updatedAt'] = Time.now
      doc['disabled'] = false
      collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    collection = db[:currencytypes]
    Project::currency_types.each do |value, index|
      doc = {}
      doc['name'] = {'ar': value, 'en': value}
      doc['id'] = index
      doc['createdAt'] = Time.now
      doc['updatedAt'] = Time.now
      doc['disabled'] = false
      collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    collection = db[:projectstatuses]
    Project::project_statuses.each do |value, index|
      doc = {}
      doc['name'] = {'ar': value, 'en': value}
      doc['id'] = index
      doc['createdAt'] = Time.now
      doc['updatedAt'] = Time.now
      doc['disabled'] = false
      collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    collection = db[:projects]
    project_keys = Project.new.attributes.keys
    Project.all.each do |project|
      doc = {}
      exists_obj = db[:projects].find({id: project.id}).first
      if exists_obj
        project_id = exists_obj[:_id]
      else
        project_id = BSON::ObjectId.new
      end
      doc[:_id] = project_id

      project_keys.each do |key|
        newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
        if newKey == 'locationClass'
          pid = Project::location_classes[project.location_class]
          begin
          doc[newKey] = db[:locationclasses].find({id: pid}).first[:_id]
          rescue
          end

          doc['location_class'] = pid
        elsif newKey == 'contactRole'
          pid = Project::contact_roles[project.contact_role]
          begin
          doc[newKey] = db[:contactroles].find({id: pid}).first[:_id]
          rescue
          end
          doc['contact_role'] = pid
        elsif newKey == 'projectBudget'
          pid = Project::contact_roles[project.project_budget]
          begin
          doc[newKey] = db[:projectbudgets].find({id: pid}).first[:_id]
          rescue
          end
          doc['project_budget'] = pid
        elsif newKey == 'timelineType'
          pid = Project::timeline_types[project.timeline_type]
          begin
          doc[newKey] = db[:timelinetypes].find({id: pid}).first[:_id]
          rescue
          end
          doc['timeline_type'] = pid
        elsif newKey == 'currencyType'
          pid = Project::currency_types[project.currency_type]
          begin
          doc[newKey] = db[:currencytypes].find({id: pid}).first[:_id]
          rescue
          end
          doc['currency_type'] = pid
        elsif newKey == 'projectStatus'
          pid = Project::project_statuses[project.project_status]
          begin
          doc[newKey] = db[:projectstatuses].find({id: pid}).first[:_id]
          rescue
          end
          doc['project_status'] = pid
        elsif newKey == 'userId'
          begin
          doc[newKey] = db[:users].find({id: project[key]}).first[:_id]
          rescue
          end
          doc[key] = project[key]
        elsif newKey == 'businessId'
          begin
          doc[newKey] = db[:businesses].find({id: project[key]}).first[:_id]
          rescue
          end
          doc[key] = project[key]
        elsif newKey == 'categoryId'
          begin
          doc[newKey] = db[:categories].find({id: project[key]}).first[:_id]
          rescue
          end
          doc[key] = project[key]
        else
          doc[newKey] = project[key]
        end
      end

      subcategories = []
      project.sub_categories.each do |sub_cate|
        sub_cate_id = db[:subcategories].find({id: sub_cate.id}).first[:_id]
        unless subcategories.include? sub_cate_id
          subcategories.push(sub_cate_id)
        end
      end
      doc['subCategoryId'] = subcategories

      services = []
      project.project_services.each do |project_service|
        service_doc = {}
        begin
        service_id = db[:services].find({id: project_service.service.id}).first[:_id]
        service_doc[:service_id] = service_id
        rescue
        end

        service_doc[:value] = project_service.details
        service_doc[:units] = project_service.option
        service_doc[:qty] = project_service.quantity
        unless services.include? service_id
          services.push(service_id)
        end
      end
      doc['serviceId'] = services

      # project locations
      location_ids = []
      locations_key = Location.new.attributes.keys
      [project.location].each do |location|
        if location.nil?
          next
        end

        location_doc = {}
        locations_key.each do |key|
          newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
          if newKey == 'cityId'
            begin
            location_doc[newKey] = db[:cities].find({id: location[key]}).first[:_id]
            rescue
            end

            location_doc[key] = location[key]
            begin
            location_doc['countryId'] = db[:countries].find({id: location.city.country_id}).first[:_id]
            rescue
            end

            location_doc['country_id'] = location.city.country_id
          elsif newKey == 'streetAddress'
            I18n.locale = :ar
            ar_loc = location.street_address
            I18n.locale = :en
            en_loc = location.street_address
            location_doc[newKey] = {ar: ar_loc, en: en_loc}
          else
            location_doc[newKey] = location[key]
          end
        end
        location_doc[:ownerType] = 'projects'
        location_doc[:ownerId] = project_id
        location_doc[:owner_id] = project.id

        exists_obj = db[:locations].find({id: location.id}).first
        if exists_obj
          location_id = exists_obj[:_id]
        else
          location_id = BSON::ObjectId.new
        end
        location_doc[:_id] = location_id

        result = db[:locations].replace_one({id: location_doc['id']}, location_doc, {upsert: true})
        if result.n == 1
          location_ids.push(location_id)
        end
      end
      doc['locations'] = location_ids

      result = collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    # quoterequests
    collection = db[:quoterequests]
    qreq_keys = QuoteRequest.new.attributes.keys
    QuoteRequest.all.each do |object|
      doc = {}
      qreq_keys.each do |key|
        newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
        if newKey == 'businessId'
          begin
          doc[newKey] = db[:businesses].find({id: object[key]}).first[:_id]
          rescue
          end

          doc[key] = object[key]
        elsif newKey == 'projectId'
          begin
          doc[newKey] = db[:projects].find({id: object[key]}).first[:_id]
          rescue
          end

          doc[key] = object[key]
        elsif newKey == 'userId'
          begin
          doc[newKey] = db[:users].find({id: object[key]}).first[:_id]
          rescue
          end

          doc[key] = object[key]
        else
          doc[newKey] = object[key]
        end
      end
      result = collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    # quote
    collection = db[:quotes]
    quote_keys = Quote.new.attributes.keys
    Quote.all.each do |object|
      doc = {}
      quote_keys.each do |key|
        newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
        if newKey == 'businessId'
          begin
          doc[newKey] = db[:businesses].find({id: object[key]}).first[:_id]
          rescue
          end

          doc[key] = object[key]
        elsif newKey == 'projectId'
          begin
          doc[newKey] = db[:projects].find({id: object[key]}).first[:_id]
          rescue
          end

          doc[key] = object[key]
        else
          doc[newKey] = object[key]
        end
      end
      result = collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    # reviews
    collection = db[:reviews]
    review_keys = Review.new.attributes.keys
    Review.all.each do |object|
      doc = {}
      review_keys.each do |key|
        newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
        if newKey == 'businessId'
          newKey = 'business'
          begin
          doc[newKey] = db[:businesses].find({id: object[key]}).first[:_id]
          rescue
          end

          doc[key] = object[key]
        elsif newKey == 'projectId'
          newKey = 'project'
          begin
          doc[newKey] = db[:projects].find({id: object[key]}).first[:_id]
          rescue
          end

          doc[key] = object[key]
        elsif newKey == 'userId'
          newKey = 'user'
          begin
          doc[newKey] = db[:users].find({id: object[key]}).first[:_id]
          rescue
          end

          doc[key] = object[key]
        else
          doc[newKey] = object[key]
        end
      end
      result = collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    # selfaddedproejct
    collection = db[:selfaddedprojects]
    sap_keys = SelfAddedProject.new.attributes.keys
    SelfAddedProject.all.each do |object|
      doc = {}
      sap_keys.each do |key|
        newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
        if newKey == 'businessId'
          begin
          doc[newKey] = db[:businesses].find({id: object[key]}).first[:_id]
          rescue
          end

          doc[key] = object[key]
        else
          doc[newKey] = object[key]
        end
      end
      if object.image_one.exists?
        doc['ImageOneFileUrl'] = object.image_one.url
      end
      if object.image_two.exists?
        doc['ImageTwoFileUrl'] = object.image_two.url
      end
      if object.image_three.exists?
        doc['ImageThreeFileUrl'] = object.image_three.url
      end
      result = collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    # subsidiaries
    collection = db[:subsidiaries]
    bs_keys = BrandSubsidiary.new.attributes.keys
    BrandSubsidiary.all.each do |object|
      doc = {}
      bs_keys.each do |key|
        newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
        if newKey == 'businessId'
          begin
          doc[newKey] = db[:businesses].find({id: object[key]}).first[:_id]
          rescue
          end

          doc[key] = object[key]
        elsif newKey == 'brandId'
          begin
          doc[newKey] = db[:brands].find({id: object[key]}).first[:_id]
          rescue
          end

          doc[key] = object[key]
        else
          doc[newKey] = object[key]
        end
      end
      result = collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    # teammembers
    collection = db[:teammembers]
    tm_keys = TeamMember.new.attributes.keys
    TeamMember.all.each do |object|
      doc = {}
      tm_keys.each do |key|
        newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
        if newKey == 'businessId'
          newKey = 'business'
          begin
          doc[newKey] = db[:businesses].find({id: object[key]}).first[:_id]
          rescue
          end

          doc[key] = object[key]
        else
          doc[newKey] = object[key]
        end
      end

      if object.profile_image.exists?
        doc['ProfileImageFileUrl'] = object.profile_image.url
      end

      result = collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    # usercallbacks
    collection = db[:usercallbacks]
    uc_keys = UserCallback.new.attributes.keys
    UserCallback.all.each do |object|
      doc = {}
      uc_keys.each do |key|
        newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
        if newKey == 'businessId'
          begin
          doc[newKey] = db[:businesses].find({id: object[key]}).first[:_id]
          rescue
          end

          doc[key] = object[key]
        elsif newKey == 'userId'
          begin
          doc[newKey] = db[:users].find({id: object[key]}).first[:_id]
          rescue
          end

          doc[key] = object[key]
        else
          doc[newKey] = object[key]
        end
      end
      result = collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    # verifications
    collection = db[:verifications]
    vr_keys = Verification.new.attributes.keys
    Verification.all.each do |object|
      doc = {}
      vr_keys.each do |key|
        newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
        doc[newKey] = object[key]
      end
      result = collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    # applications
    collection = db[:applications]
    ap_keys = AppliedToProject.new.attributes.keys
    AppliedToProject.all.each do |object|
      doc = {}
      ap_keys.each do |key|
        newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
        if newKey == 'businessId'
          begin
          doc[newKey] = db[:businesses].find({id: object[key]}).first[:_id]
          rescue
          end

          doc[key] = object[key]
        elsif newKey == 'projectId'
          begin
          doc[newKey] = db[:projects].find({id: object[key]}).first[:_id]
          rescue
          end

          doc[key] = object[key]
        else
          doc[newKey] = object[key]
        end
      end
      result = collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    # attachments
    collection = db[:attachments]
    ap_keys = Attachment.new.attributes.keys
    Attachment.all.each do |object|
      doc = {}
      ap_keys.each do |key|
        newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
        if newKey == 'ownerId'
          if object.owner_type == 'Quote'
            begin
            doc[newKey] = db[:quotes].find({id: object[key]}).first[:_id]
            rescue
            end

          else
            begin
            doc[newKey] = db[:projects].find({id: object[key]}).first[:_id]
            rescue
            end

          end
          doc[key] = object[key]
        else
          doc[newKey] = object[key]
        end
        if object.attachment.exists?
          doc['AttachementFileUrl'] = object.attachment.url
        end
      end
      result = collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    # message
    collection = db[:messages]
    messages_keys = Message.new.attributes.keys
    Message.all.each do |object|
      doc = {}
      messages_keys.each do |key|
        newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
        if newKey == 'sendingUserId'
          if object.sending_user_type == 'Business'
            begin
            doc[newKey] = db[:businesses].find({id: object[key]}).first[:_id]
            rescue
            end

          else
            begin
            doc[newKey] = db[:users].find({id: object[key]}).first[:_id]
            rescue
            end

          end
          doc[key] = object[key]
        elsif newKey == 'receivingUserId'
          if object.receiving_user_type == 'Business'
            begin
            doc[newKey] = db[:businesses].find({id: object[key]}).first[:_id]
            rescue
            end

          else
            begin
            doc[newKey] = db[:users].find({id: object[key]}).first[:_id]
            rescue
            end

          end
          doc[key] = object[key]
        elsif newKey == 'conversationId'
          begin
          doc[newKey] = db[:conversations].find({id: object[key]}).first[:_id]
          rescue
          end

          doc[key] = object[key]
        elsif newKey == 'projectId'
          begin
          doc[newKey] = db[:projects].find({id: object[key]}).first[:_id]
          rescue
          end

          doc[key] = object[key]
        else
          doc[newKey] = object[key]
        end
      end
      result = collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    # notification
    collection = db[:notifications]
    notifications_keys = Notification.new.attributes.keys
    Notification.all.each do |object|
      doc = {}
      notifications_keys.each do |key|
        newKey = key.gsub(/(_.)/) {|m| m.upcase}.gsub('_', '')
        if newKey == 'sendingUserId'
          if object.sending_user_type == 'Business'
            begin
            doc[newKey] = db[:businesses].find({id: object[key]}).first[:_id]
            rescue
            end

          else
            begin
            doc[newKey] = db[:users].find({id: object[key]}).first[:_id]
            rescue
            end

          end
          doc[key] = object[key]
        elsif newKey == 'receivingUserId'
          if object.receiving_user_type == 'Business'
            begin
            doc[newKey] = db[:businesses].find({id: object[key]}).first[:_id]
            rescue
            end

          else
            begin
            doc[newKey] = db[:users].find({id: object[key]}).first[:_id]
            rescue
            end

          end
          doc[key] = object[key]
        elsif newKey == 'businessId'
          begin
          doc[newKey] = db[:businesses].find({id: object[key]}).first[:_id]
          rescue
          end

          doc[key] = object[key]
        elsif newKey == 'projectId'
          begin
          doc[newKey] = db[:projects].find({id: object[key]}).first[:_id]
          rescue
          end

          doc[key] = object[key]
        elsif newKey == 'quoteId'
          begin
          doc[newKey] = db[:quotes].find({id: object[key]}).first[:_id]
          rescue
          end

          doc[key] = object[key]
        else
          doc[newKey] = object[key]
        end
      end
      result = collection.replace_one({id: doc['id']}, doc, {upsert: true})
    end

    # gallerycontents
    collection = db[:gallerycontents]
    Attachment.project_images.each do |attachment|
      doc = {}
      doc['id'] = attachment.id
      doc['from'] = 'attachments.attachment'
      doc['ownerType'] = 'projects'
      doc['owner_id'] = attachment.owner_id
      begin
        doc['ownerId'] = db[:projects].find({id: attachment.owner_id}).first[:_id]
      rescue
      end

      doc['createdAt'] = attachment.created_at
      doc['ImageConentType'] = 'image'
      if attachment.attachment.exists?
        doc['ImageUpdatedAt'] = attachment.attachment_updated_at
        doc['ImageFileUrl'] = attachment.attachment.url
      end
      result = collection.replace_one({id: doc['id'], from: doc['from']}, doc, {upsert: true})
    end

    SelfAddedProject.has_photos.distinct.each do |sap|
      doc = {}
      doc['id'] = sap.id
      doc['ownerType'] = 'businesses'
      doc['owner_id'] = sap.business_id
      doc['createdAt'] = sap.created_at
      doc['ImageConentType'] = 'image'
      begin
        doc['ownerId'] = db[:businesses].find({id: sap.business_id}).first[:_id]
      rescue
      end

      if sap.image_one.exists?
        doc['from'] = 'selfaddedprojects.image_one'
        doc['ImageUpdatedAt'] = sap.image_one_updated_at
        doc['ImageFileUrl'] = sap.image_one.url
        result = collection.replace_one({id: doc['id'], from: doc['from']}, doc, {upsert: true})
      end
      
      if sap.image_two.exists?
        doc['from'] = 'selfaddedprojects.image_two'
        doc['ImageUpdatedAt'] = sap.image_two_updated_at
        doc['ImageFileUrl'] = sap.image_two.url
        result = collection.replace_one({id: doc['id'], from: doc['from']}, doc, {upsert: true})
      end

      if sap.image_three.exists?
        doc['from'] = 'selfaddedprojects.image_three'
        doc['ImageUpdatedAt'] = sap.image_three_updated_at
        doc['ImageFileUrl'] = sap.image_three.url
        result = collection.replace_one({id: doc['id'], from: doc['from']}, doc, {upsert: true})
      end

      if sap.video_link
        doc['from'] = 'selfaddedprojects.video_link'
        doc['videoLink'] = sap.video_link
        doc['ImageConentType'] = 'video'
        doc['ImageUpdatedAt'] = ''
        doc['ImageFileUrl'] = ''
        result = collection.replace_one({id: doc['id'], from: doc['from']}, doc, {upsert: true})
      end
    end

    Business.active.has_banner.each do |business|
      doc = {}
      doc['id'] = business.id
      doc['from'] = 'businesses.banner'
      doc['ownerType'] = 'businesses'
      doc['owner_id'] = business.id
      begin
        doc['ownerId'] = db[:businesses].find({id: business.id}).first[:_id]
      rescue
      end
      doc['createdAt'] = business.created_at
      doc['ImageConentType'] = 'image'
      if business.banner.exists?
        doc['ImageUpdatedAt'] = business.banner_updated_at
        doc['ImageFileUrl'] = business.banner.url
      end
      result = collection.replace_one({id: doc['id'], from: doc['from']}, doc, {upsert: true})
    end
  end
end