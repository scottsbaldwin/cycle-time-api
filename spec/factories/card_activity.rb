FactoryGirl.define do
  factory :entry_only_card, class: CardActivity do
    card_id '53ea45e3d990b61c765dd8f3'
    list_id '52ceaa77156434cc72450c72'
    entry_date Date.parse('2014-08-12')
    grouping_year 2014
    grouping_month 8
    grouping_week 33
  end
end
