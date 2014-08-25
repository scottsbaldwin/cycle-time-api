require 'spec_helper'

describe MetricCalculator do
  it "should calculate the long term average" do
    data = [10, 2, 2]

    long_term_average = MetricCalculator.average_of_values(data)
    expect(long_term_average.round(1)).to eq(4.7)
  end
end
