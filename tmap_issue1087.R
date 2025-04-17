setwd('./download/tmap_issue1087/')

pts = sf::read_sf(system.file('extdata/pts.gpkg',package = 'sdsfun'))

qgisprocess::qgis_run_algorithm(
  algorithm = "qgis:heatmapkerneldensityestimation",
  INPUT = pts,
  RADIUS = 2000,
  PIXEL_SIZE = 100
) |> 
  qgisprocess::qgis_as_terra() -> p.kde

terra::plot(p.kde)

terra::writeRaster(p.kde,'./p.kde.tif')

library(tmap)

p.kde = terra::rast('./p.kde.tif')

fig1 = tm_shape(p.kde) +
  #tm_basemap(server = "CartoDB.PositronNoLabels", zoom = 10, alpha = 0.5) +
  tm_raster(col.scale = tm_scale_continuous(values = c("#9fb4cf",
                                                       "#fbfcd3",
                                                       "#ee9682",
                                                       "#df6e6a")), 
            col_alpha = 0.65) +
  tm_shape(pts) +
  tm_dots(fill = "red")
fig1

fig2 = tm_shape(p.kde) +
  tm_basemap(server = "CartoDB.PositronNoLabels", zoom = 10, alpha = 0.5) +
  tm_raster(col.scale = tm_scale_continuous(values = c("#9fb4cf",
                                                       "#fbfcd3",
                                                       "#ee9682",
                                                       "#df6e6a")), 
            col_alpha = 0.65) +
  tm_shape(pts) +
  tm_dots(fill = "red")
fig2

bbox = terra::ext(p.kde)
bbox = terra::vect(bbox)
terra::crs(bbox) = terra::crs(p.kde)
bb = sf::st_as_sf(bbox)
fig3 = tm_shape(bb) +
  tm_basemap(server = "CartoDB.PositronNoLabels", zoom = 10, alpha = 0.5) +
  tm_shape(p.kde) +
  tm_raster(col.scale = tm_scale_continuous(values = c("#9fb4cf",
                                                       "#fbfcd3",
                                                       "#ee9682",
                                                       "#df6e6a")), 
            col_alpha = 0.65) +
  tm_shape(pts) +
  tm_dots(fill = "red")
fig3

sessionInfo()