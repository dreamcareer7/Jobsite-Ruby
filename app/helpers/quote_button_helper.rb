module QuoteButtonHelper

  def appropriate_button(category)
    case category.name

    when "Suppliers"
      {
        link: "supplier",
        blurb: I18n.t("main_nav.get_supplies")
      }
    when "Machinery"
      {
        link: "machinery",
        blurb: I18n.t("main_nav.buy_rent")
      }
    else
      {
        link: "default",
        blurb: I18n.t("main_nav.hire_professional")
      }
    end
  end


end
