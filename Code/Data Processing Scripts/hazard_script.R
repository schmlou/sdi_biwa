#setwd
setwd("D:/Masters/Studies/Summer Sem/SDI/Data/Processed/AOI")
getwd()
dir()
#libraries
library(terra)
library(sf)

#set proj path
Sys.setenv(PROJ_DATA = "C:/Users/MARY/AppData/Local/R/win-library/4.4/sf/proj")
Sys.setenv(PROJ_LIB  = "C:/Users/MARY/AppData/Local/R/win-library/4.4/sf/proj")

#import data
dem<-rast("dem_berchtesgaden_merged.tif")

#vrify
dem
plot(dem,
     main="Berchtesgadem DEM",
     col=terrain.colors(100))

#derive terrain layers from the DEM
#slope
slope<-terrain(dem,
               v="slope",
               unit="degrees")
#aspect
aspect<-terrain(dem,
                v="aspect",
                unit="degrees")
#hillshade
hillshade<-shade(slope,
                 aspect,
                 angle = 45, #sun elevation angle
                 direction = 315 #sun direction(NW)
                 )

# Plot all three
par(mfrow = c(1, 3))

plot(slope,
     main = "Slope (degrees)",
     col  = heat.colors(100))

plot(aspect,
     main = "Aspect (degrees)",
     col  = rainbow(100))

plot(hillshade,
     main = "Hillshade",
     col  = grey(0:100/100))

#convert slope to radians
# Fix hillshade - convert slope to radians first
slope_rad <- terrain(dem, v = "slope", unit = "radians")
aspect_rad <- terrain(dem, v = "aspect", unit = "radians")

hillshade <- shade(slope_rad, aspect_rad,
                   angle     = 45,    
                   direction = 315)   

# Reset and replot hillshade only
par(mfrow = c(1, 1))
plot(hillshade,
     main = "Hillshade (fixed)",
     col  = grey(0:100/100))

#classify slope into hazzard zones
hazard_zones<-classify(
  slope,
  matrix(c(
    0,15,1, #low risk
    15,30,2, #moderate risk
    30,45,3,  #high risk
    45,90,4#extreme risk
  ), ncol = 3, byrow = TRUE)
)

#plot
par(mfrow = c(1, 1))
plot(hazard_zones,
     main   = "Slope-based Hazard Zones",
     col    = c("green", "yellow", "orange", "red"),
     legend = FALSE)

legend("bottomright",
       legend = c("Low (0-15°)", "Moderate (15-30°)", 
                  "High (30-45°)", "Extreme (>45°)"),
       fill   = c("green", "yellow", "orange", "red"))

# Save all derived layers as GeoTIFF
writeRaster(slope,
            "slope_berchtesgaden.tif",
            overwrite = TRUE)

writeRaster(aspect,
            "aspect_berchtesgaden.tif",
            overwrite = TRUE)

writeRaster(hillshade,
            "hillshade_berchtesgaden.tif",
            overwrite = TRUE)
writeRaster(hazard_zones,
            "hazard_zones_berchtesgaden.tif",
            overwrite = TRUE)

# Confirm all saved
file.exists("slope_berchtesgaden.tif")
file.exists("aspect_berchtesgaden.tif")
file.exists("hillshade_berchtesgaden.tif")
file.exists("hazard_zones_berchtesgaden.tif")
