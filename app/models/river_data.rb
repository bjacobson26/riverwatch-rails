class RiverData
  attr_reader :name, :data_url

  def initialize(name, data_url)
    @name = name
    @data_url = data_url
  end

  def raw_data
    @raw_data ||= begin
      resp = Faraday.get(data_url)
      Hash.from_xml(resp.body)
    end
  end

  def flood_threshold
    @flood_threshold ||= (raw_data['site']['sigstages']['flood'] || raw_data['site']['sigstages']['moderate']).to_f
  end

  def action_threshold
    @action_threshold ||= raw_data['site']['sigstages']['action'].to_f
  end

  def pretty_data
    first_node = raw_data['site']['observed']['datum'].first
    last_checked_at = first_node['valid']
    current_level = first_node['primary'].to_f

    second_node = raw_data['site']['observed']['datum'].second
    previous_level_checked_at = second_node['valid']
    previous_level = second_node['primary'].to_f


    status = if current_level > flood_threshold
      :flood
    elsif current_level > action_threshold
      :action
    else
      :ok
    end

    trend = if previous_level.round(1) == current_level.round(1)
      :steady
    elsif previous_level > current_level
      :down
    else
      :up
    end

    {
      name: name,
      longname: raw_data['site']['name'],
      flood_threshold: flood_threshold,
      action_threshold: action_threshold,
      current_level: current_level,
      last_checked_at: last_checked_at,
      status: status,
      trend: trend,
      previous_level: previous_level,
      previous_level_checked_at: previous_level_checked_at,
      link_url: data_url,
      graph_data: graph_data,
      max: max,
      trend_percentage: rate_of_change(previous_level, current_level).round(3)
    }
  end

  def max
    @max ||= raw_data['site']['observed']['datum'].max_by do |d|
      d['primary'].to_f
    end
  end

  def graph_data
    result = [
      {
        name: "Current Level",
        data: [],
        points: false,
        color: '#3b82f6'
      },
      {
        name: "Action",
        data: [],
        points: false,
        color: '#eab308'
      },
      {
        name: "Flood",
        data: [],
        points: false,
        color: '#f43f5e'
      }
    ]

    raw_data['site']['observed']['datum'].each do |datum|
      result[0][:data] << [datum['valid'], datum['primary'].to_f]
      result[1][:data] << [datum['valid'], action_threshold]
      result[2][:data] << [datum['valid'], flood_threshold]
    end

    result
  end

  private

  def rate_of_change(old_value, new_value)
    return (((new_value - old_value) / old_value) * 100).round(2)
  end
end
