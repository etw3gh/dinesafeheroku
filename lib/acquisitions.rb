require 'singleton'

# copied from old dinesafe app. includes regions beyond Toronto
class Acquisitions
  include Singleton


  """
    downloads
    ├── dinesafe
    │   ├── xml
    │   └── zip
    │       └── dinesafe.xml
    └── geo
        ├── shp
        ├── json
        └── zip
  """

  def initialize
    @assets_root = 'downloads/'
  end

  # OPEN DATA REGIONS

  #TODO combine shapefiles into toronto
  #toronto
  def shapefiles
    geo_root = "#{@assets_root}geo/",
    {
      url: 'http://opendata.toronto.ca/gcc/address_points_wgs84.zip',
      filename: 'ADDRESS_POINT_WGS84.shp',
      archives: "#{geo_root}zip/",
      textfiles: "#{geo_root}json/",
      shapefiles: "#{geo_root}shp/",
      category: 'shapefile',
      region: 'Toronto'
    }
  end

  def dinesafe
    ds_root = "#{@assets_root}dinesafe/"
    {
      url: 'http://opendata.toronto.ca/public.health/dinesafe/dinesafe.zip',
      filename: 'dinesafe.xml',
      archives: "#{ds_root}zip/",
      textfiles: "#{ds_root}xml/",
      category: 'dinesafe',
      region: 'Toronto'
    }
  end

  def waterloo
    {
      url: 'http://www.regionofwaterloo.ca/en/regionalGovernment/FoodPremiseDataset.asp',
      path: "#{@assets_root}waterloo",
      filename: nil,
      subpaths: {
        :shp =>  'http://www.regionofwaterloo.ca/opendatadownloads/FoodFacilities.zip',
        :kml => 'http://www.regionofwaterloo.ca/opendatadownloads/FoodFacilities_kmz.zip',
        :inspections => 'http://www.regionofwaterloo.ca/opendatadownloads/Inspections.zip'
     },
     category: 'waterloo',
     region: 'Waterloo'
    }
  end

  def peel
    {
      todo: ''
    }
  end

  def ottawa
    {
      url: 'http://app01.ottawa.ca/inspections-opendata/yelp_ottawa_healthscores.zip',
      path: "#{@assets_root}ottawa",
      filename: nil,
      archive: "#{@assets_root}ottawa/archives",
      contents: {
        :businesses => 'businesses.csv',
        :feed_info => 'feed_info.csv',
        :inspections => 'inspections.csv',
        :legend => 'legend.csv',
        :violations => 'violations.csv'
      },
      category: 'ottawa',
      region: 'Ottawa'
    }
  end

  # WEB SCRAPE REGIONS

  def durham
    {
      url: 'http://www.durham.ca/dineSafe/DineSafeInspectionSearch.aspx',
      path: "#{@assets_root}dinesafe_durham",
      prefix: 'http://www.durham.ca/dineSafe/',    # TODO please standardize this stuff
      archive: "#{@assets_root}dinesafe_durham/archives",
      category: 'durham',
      region: 'Durham'
    }
  end

  def infodine
    {
      url: 'http://www.niagararegion.ca/living/health_wellness/inspect/infodine/',
      path: "#{@assets_root}infodine",
      filename: nil,
      archive: "#{@assets_root}infodine/",
      category: 'infodine',
      region: 'Niagara'
    }
  end

  def halton
    {
      url: 'http://webaps.halton.ca/health/services/foodsafety/',
      # keep search size at 25000 to get all results
      search_term: 'page1_size25000.aspx',
      path: "#{@assets_root}halton",
      filename: nil,
      category: 'dinewise',
      region: 'Halton'
    }
  end

  def bc
    {
      todo: ''
    }
  end

  # Faciltiy type sites

  def timiskaming
    {
      path: "#{@assets_root}timiskaming",
      url: 'http://tihu.hedgerowsoftware.com/',
      search_term: 'Facility?alpha=&search-term=&submit-search=&page-size=-1',
      category: '',
      region: 'timiskaming'
    }
  end

  def guelph
    {
      path: "#{@assets_root}guelph",
      url: 'http://www.checkbeforeyouchoose.ca',
      # keep search size at -1 to get all results
      search_term: '/Facility?search-term=&report-type=ffffffff-ffff-ffff-ffff-fffffffffff1&area=&style=&infractions=&sort-by=Name&alpha=&page=0&page-size=-1',
      category: 'checkbeforeyouchoose',
      region: 'Guelph'
    }
  end

  def york
    {
      url: 'http://disclosure.york.ca',
      # keep search size at -1 to get all results
      search_term: '/Facility?search-term=&report-type=ffffffff-ffff-ffff-ffff-fffffffffff1&area=&style=&infractions=&sort-by=Name&alpha=&page=0&page-size=-1',
      path: "#{@assets_root}york",
      filename: nil,

      category: 'yorksafe',
      region: 'York'
    }
  end

  # vancouver coastal health
  def van
    {
      url: 'http://www.inspections.vcha.ca',
      search_term: '/Facility?search-term=&report-type=ffffffff-ffff-ffff-ffff-fffffffffff1&area=&style=&infractions=&sort-by=Name&alpha=&page=0&page-size=-1',
      path: "#{@assets_root}van",
      category: 'van',
      region: 'Vancouver'
    }
  end

end