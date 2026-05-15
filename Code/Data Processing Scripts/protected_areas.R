setwd("D:/Masters/Studies/Summer Sem/SDI/Data/Processed/AOI")
library(sf)
# Create a folder for the data
dir.create("protected_areas", showWarnings = FALSE)

# Increase timeout to 30 minutes (1800 seconds)
options(timeout = 1800)

# Try download again
download.file(
  url      = "https://sdi.eea.europa.eu/datashare/s/mwzs9eNsJ9Sn4Q4/download",
  destfile = "protected_areas/natura2000_2024.zip",
  mode     = "wb"
)
# Check file downloaded successfully
file.exists("protected_areas/natura2000_2024.zip")
file.size("protected_areas/natura2000_2024.zip")  # should be large

# Unzip the file
unzip("protected_areas/natura2000_2024.zip", 
      exdir = "protected_areas/natura2000_2024")

# See what files are inside
list.files("protected_areas/natura2000_2024", 
           recursive = TRUE)


############Shepfile########
# Load the Shapefile
natura2000 <- st_read("protected_areas/natura2000_2024/eea_v_3035_100_k_natura2000_p_2024_v01_r00/SHP/Natura2000_end2024_epsg3035.shp")

# Quick inspection
st_crs(natura2000)$epsg     # confirm CRS (should be 3035)
nrow(natura2000)             # total protected areas in Europe
names(natura2000)            # column names


# Create bounding box in WGS84 first
bbox_wgs84 <- st_sfc(
  st_polygon(list(matrix(c(
    12.5, 47.4,
    13.2, 47.4,
    13.2, 47.8,
    12.5, 47.8,
    12.5, 47.4
  ), ncol = 2, byrow = TRUE))),
  crs = 4326
)

# Check both CRS in detail
st_crs(natura2000)
st_crs(bbox_3035)
# Force match the CRS of bbox to exactly match natura2000
bbox_3035 <- st_transform(bbox_wgs84, crs = st_crs(natura2000))

# Clip natura2000 to Berchtesgaden area
natura2000_berchtesgaden <- st_intersection(natura2000, bbox_3035)

# Check how many protected areas we have
nrow(natura2000_berchtesgaden)
print(natura2000_berchtesgaden)

# Reproject to 25832 to match our other datasets
natura2000_berchtesgaden <- st_transform(natura2000_berchtesgaden, crs = 25832)

# Verify CRS
st_crs(natura2000_berchtesgaden)$epsg   # should be 25832

# Save as Shapefile
st_write(natura2000_berchtesgaden,
         "protected_areas/natura2000_berchtesgaden.shp",
         delete_layer = TRUE)

# Confirm
file.exists("protected_areas/natura2000_berchtesgaden.shp")
nrow(natura2000_berchtesgaden)
table(natura2000_berchtesgaden$MS)   # breakdown by country
