class PagesController < ApplicationController
  def index
    set_lagoon_data
    set_highway_data
  end

  def set_lagoon_data
    resp = Faraday.get('https://water.weather.gov/ahps2/hydrograph_to_xml.php?gage=crmc1&output=xml')
    xml = Nokogiri::XML(resp.body)

    first_node = xml.at_css("observed").children[0]
    last_checked_at = first_node.children[0].children.text
    current_level = first_node.children[1].children.text.to_f

    second_node = xml.at_css("observed").children[1]
    previous_level_checked_at = second_node.children[0].children.text
    previous_level = second_node.children[1].children.text.to_f


    flood_threshold = 12.5
    action_threshold = 10.0
    status, color = if current_level > flood_threshold
      [:flood, 'text-red-500']
    elsif current_level > action_threshold
      [:action, 'text-orange-500']
    else
      [:ok, 'text-green-500']
    end

    trend = if previous_level == current_level
      :steady
    elsif previous_level > current_level
      :down
    else
      :up
    end

    @lagoon_data = {
      name: "Lagoon",
      flood_threshold: flood_threshold,
      action_threshold: action_threshold,
      current_level: current_level,
      last_checked_at: last_checked_at,
      status: status,
      color: color,
      trend: trend,
      previous_level: previous_level,
      previous_level_checked_at: previous_level_checked_at,
      link_url: "https://water.weather.gov/ahps2/hydrograph.php?gage=CRMC1&wfo=mtr",
      graph_url: "https://water.weather.gov/resources/hydrographs/crmc1_hg.png"
    }
  end

  def set_highway_data
    resp = Faraday.get('https://water.weather.gov/ahps2/hydrograph_to_xml.php?gage=cmrc1&output=xml')
    xml = Nokogiri::XML(resp.body)
    first_node = xml.at_css("observed").children[0]
    last_checked_at = first_node.children[0].children.text
    current_level = first_node.children[1].children.text.to_f

    second_node = xml.at_css("observed").children[1]
    previous_level_checked_at = second_node.children[0].children.text
    previous_level = second_node.children[1].children.text.to_f


    flood_threshold = 12.5
    action_threshold = 10.0
    status = if current_level > flood_threshold
      :flood
    elsif current_level > action_threshold
      :action
    else
      :ok
    end

    trend = if previous_level == current_level
      :steady
    elsif previous_level > current_level
      :down
    else
      :up
    end

    @highway_data = {
      name: "Highway 1",
      flood_threshold: flood_threshold,
      action_threshold: action_threshold,
      current_level: current_level,
      last_checked_at: last_checked_at,
      status: status,
      trend: trend,
      previous_level: previous_level,
      previous_level_checked_at: previous_level_checked_at,
      link_url: "https://water.weather.gov/ahps2/hydrograph.php?gage=CMRC1&wfo=mtr",
      graph_url: "https://water.weather.gov/resources/hydrographs/cmrc1_hg.png"
    }
  end
end
