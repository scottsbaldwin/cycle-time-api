class MetricCalculator
  def self.long_term_average(data, key)
    average = 0
    total = data.inject(0.0) do |sum, el|
      el.symbolize_keys!
      sum + el[key].to_f
    end
    average = total / data.count if data.count > 0
    average
  end
end
