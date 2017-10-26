class AddPointIndexToZones < ActiveRecord::Migration[5.1]
  def up
    execute %{
      create index index_on_zones_polygon ON zones using gist (
          ST_GeographyFromText(zones.polygon) ) }
  end
end

