class MetricCalculator
  def self.average_of_values(values)
    total = values.inject(0.0) { |sum, el| sum + el }
    average = 0
    average = total / values.count if values.count > 0
    average
  end

  def self.average_arrival_rate_for_list(list_id = 'list_not_set')
    values = CardActivity.select("count(id) as time_in_list").group("grouping_year, grouping_week").where(list_id: list_id).where.not(exit_date: nil).map(&:time_in_list)
    average = average_of_values values
    average
  end

  def self.average_cycle_time_for_list(list_id = 'list_not_set')
    values = CardActivity.select("sum(time_in_list) as time_in_list").group("grouping_year, grouping_week").where(list_id: list_id).map(&:time_in_list)
    average = average_of_values values
    average
  end

  def self.average_wip_for_list(list_id = 'list_not_set')
    average_cycle_time_for_list(list_id) * average_arrival_rate_for_list(list_id)
  end
end
