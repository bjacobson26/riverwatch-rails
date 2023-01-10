class PagesController < ApplicationController
  def index
  end

  def lagoon
    @lagoon_data = RiverData.new(
      'Lagoon',
      'https://water.weather.gov/ahps2/hydrograph_to_xml.php?gage=crmc1&output=xml',
    ).pretty_data

    @more_data_url = 'https://water.weather.gov/ahps2/hydrograph.php?gage=CRMC1&wfo=mtr'
  end

  def highway
    @highway_data = RiverData.new(
      'Highway 1',
      'https://water.weather.gov/ahps2/hydrograph_to_xml.php?gage=cmrc1&output=xml',
    ).pretty_data

    @more_data_url = 'https://water.weather.gov/ahps2/hydrograph.php?gage=CMRC1&wfo=mtr'
  end
end
