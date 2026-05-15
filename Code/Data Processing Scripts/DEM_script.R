setwd("D:/Masters/Studies/Summer Sem/SDI/Data/Processed/AOI")

library(terra)

#list files in the folders
list.files("D:/Masters/Studies/Summer Sem/SDI/Data/Rasters/Rasters/germnay_alps", recursive = TRUE)
list.files("D:/Masters/Studies/Summer Sem/SDI/Data/Rasters/Rasters/salzburg", recursive = TRUE)

# Load ArcGIS Grid format using the folder path
# terra recognizes the w001001.adf as the main raster file
dem_germany <- rast("D:/Masters/Studies/Summer Sem/SDI/Data/Rasters/Rasters/germnay_alps/w001001.adf")
dem_salzburg <- rast("D:/Masters/Studies/Summer Sem/SDI/Data/Rasters/Rasters/salzburg/w001001.adf")

# Inspect both
crs(dem_germany)
crs(dem_salzburg)
res(dem_germany)
res(dem_salzburg)
ext(dem_germany)
ext(dem_salzburg)

# Plot both DEMs side by side
par(mfrow = c(1, 2))  # side by side

plot(dem_germany, 
     main = "Germany Alps DEM",
     col  = terrain.colors(100))

plot(dem_salzburg, 
     main = "Salzburg DEM",
     col  = terrain.colors(100))


# Set PROJ data path to the sf proj.db
Sys.setenv(PROJ_DATA = "C:/Users/MARY/AppData/Local/R/win-library/4.4/sf/proj")
Sys.setenv(PROJ_LIB  = "C:/Users/MARY/AppData/Local/R/win-library/4.4/sf/proj")

# Verify it's set
Sys.getenv("PROJ_DATA")

# Now try reprojecting again
dem_salzburg_reproj <- project(dem_salzburg, 
                               "EPSG:25832",
                               method = "bilinear")

#quick checks
crs(dem_salzburg_reproj, describe = TRUE)
res(dem_salzburg_reproj)
ext(dem_salzburg_reproj)

#plot
# Plot both to confirm same coordinate space
par(mfrow = c(1, 2))

plot(dem_germany,
     main = "Germany Alps (25832)",
     col  = terrain.colors(100))

plot(dem_salzburg_reproj,
     main = "Salzburg reprojected (25832)",
     col  = terrain.colors(100))


############Resampling##########
# Resample Germany DEM to 5m resolution to match Salzburg
dem_germany_5m <- resample(dem_germany,
                           rast(ext(dem_germany), 
                                resolution = 5,
                                crs = "EPSG:25832"),
                           method = "bilinear")

# Resample Salzburg to exactly 5m too
dem_salzburg_5m <- resample(dem_salzburg_reproj,
                            rast(ext(dem_salzburg_reproj),
                                 resolution = 5,
                                 crs = "EPSG:25832"),
                            method = "bilinear")

# Verify both are 5m
res(dem_germany_5m)
res(dem_salzburg_5m)


########merging#############
# Merge both DEMs into one
dem_merged <- merge(dem_germany_5m, dem_salzburg_5m)

# Check the result
res(dem_merged)
ext(dem_merged)
crs(dem_merged, describe = TRUE)
par(mfrow=c(1,1))
# Plot the merged DEM
plot(dem_merged,
     main = "Merged Cross-Border DEM (25832)",
     col  = terrain.colors(100))

# Save the merged DEM as GeoTIFF
writeRaster(dem_merged,
            "dem_berchtesgaden_merged.tif",
            overwrite = TRUE)

# Confirm
file.exists("dem_berchtesgaden_merged.tif")
file.size("dem_berchtesgaden_merged.tif")
