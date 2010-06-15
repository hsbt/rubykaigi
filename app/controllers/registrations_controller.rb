class RegistrationsController < LocaleBaseController
  layout_for_latest_ruby_kaigi

  def index
    @individual_sponsor = ProductItem.find_by_item_code('rk10_individual_sponsor')
    @kaigi = ProductItem.find_by_item_code("rk10")
    @party = ProductItem.find_by_item_code("rk10_party")
  end
end
