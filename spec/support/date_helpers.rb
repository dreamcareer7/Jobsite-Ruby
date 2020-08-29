module DateHelpers
  def select_date(date, options = {})
    field = options[:from]
    select date.strftime('%Y'), from: "#{field}_1i"
    select date.strftime('%-B'), from: "#{field}_2i"
    select date.strftime('%-d'), from: "#{field}_3i"
  end
end
