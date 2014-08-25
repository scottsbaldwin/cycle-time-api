require 'spec_helper'

describe MetricCalculator do
  it "should calculate the long term average" do
    data = [
      {"grouping_year"=>"2014", "grouping_week"=>"32", "total"=>"30"},
      {"grouping_year"=>"2014", "grouping_week"=>"33", "total"=>"35"},
      {"grouping_year"=>"2014", "grouping_week"=>"34", "total"=>"40"},
      {"grouping_year"=>"2014", "grouping_week"=>"35", "total"=>"45"}
    ]

    long_term_average = MetricCalculator.long_term_average(data, :total)
    expect(long_term_average).to eq(37.5)
  end
end
