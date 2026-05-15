#setwd
setwd("D:/Masters/Studies/Summer Sem/SDI/Data/Processed/AOI")
#install.packages("rgbif")
library(rgbif)
library(dplyr)

#set up credentials
Sys.setenv(GBIF_USER  = "marymuthee",
           GBIF_PWD   = "MaQueen/KE2721",
           GBIF_EMAIL = "queenwangari.m@gmail.com")

# Get GBIF taxon keys for each species
chamois_key <- name_backbone("Rupicapra rupicapra")$usageKey
red_deer_key <- name_backbone("Cervus elaphus")$usageKey
golden_eagle_key <- name_backbone("Aquila chrysaetos")$usageKey

# Check the keys
chamois_key
red_deer_key
golden_eagle_key

# Bounding box around Berchtesgaden region
# Define bounding box as WKT POLYGON instead
bbox_wkt <- "POLYGON((12.5 47.4, 13.2 47.4, 13.2 47.8, 12.5 47.8, 12.5 47.4))"

# Pull occurrences for each species
chamois_occ <- occ_search(
  taxonKey      = 5220170,
  geometry      = bbox_wkt,
  hasCoordinate = TRUE,
  limit         = 1100
)

red_deer_occ <- occ_search(
  taxonKey      = 2440958,
  geometry      = bbox_wkt,
  hasCoordinate = TRUE,
  limit         = 500
)

golden_eagle_occ <- occ_search(
  taxonKey      = 2480506,
  geometry      = bbox_wkt,
  hasCoordinate = TRUE,
  limit         = 650
)

# Quick check - how many records did we get?
nrow(chamois_occ$data)
nrow(red_deer_occ$data)
nrow(golden_eagle_occ$data)

# Check total records available (not just the 500 we pulled)
chamois_occ$meta$count
red_deer_occ$meta$count
golden_eagle_occ$meta$count

# Preview the data structure
head(chamois_occ$data[, c("species", "decimalLongitude", 
                          "decimalLatitude", "year", 
                           "country", "stateProvince")])

# Select relevant columns from each species
cols <- c("species", "decimalLongitude", "decimalLatitude", 
          "year", "month", "country", "stateProvince",
          "coordinateUncertaintyInMeters")

chamois_df     <- chamois_occ$data[, cols]
red_deer_df    <- red_deer_occ$data[, cols]
golden_eagle_df <- golden_eagle_occ$data[, cols]

# Add a species label column for clarity
chamois_df$common_name      <- "Chamois"
red_deer_df$common_name     <- "Red Deer"
golden_eagle_df$common_name <- "Golden Eagle"

# Combine all into one dataframe
species_all <- bind_rows(chamois_df, red_deer_df, golden_eagle_df)

# Quick check
nrow(species_all)
head(species_all)
summary(species_all)


######Clean NA#####
species_clean <- species_all %>%
  # Remove records with missing coordinates
  filter(!is.na(decimalLongitude), !is.na(decimalLatitude)) %>%
  # Keep only records from 2010 onwards
  filter(!is.na(year), year >= 2010) %>%
  # Remove records with high coordinate uncertainty (>5km)
  filter(is.na(coordinateUncertaintyInMeters) | 
           coordinateUncertaintyInMeters <= 5000) %>%
  # Remove records with missing month
  filter(!is.na(month))

# Check how many records remain
nrow(species_clean)
table(species_clean$common_name)  # breakdown by species
table(species_clean$country)      # breakdown by country

# Remove the Sweden record
species_clean <- species_clean %>%
  filter(country %in% c("Austria", "Germany"))

# Verify
nrow(species_clean)
table(species_clean$common_name)
table(species_clean$country)

# Also check the year range we now have
range(species_clean$year)


#######Harmonization#########
library(sf)

# Convert to sf spatial object
# Data is currently in WGS84 (EPSG:4326) — standard for GBIF
species_sf <- st_as_sf(species_clean,
                       coords = c("decimalLongitude", "decimalLatitude"),
                       crs    = 4326)

# Reproject to ETRS89 / UTM zone 32N (EPSG:25832)
# Consistent with other datasets
species_sf <- st_transform(species_sf, crs = 25832)

# Verify
st_crs(species_sf)$epsg        # should print 25832
nrow(species_sf)                # should still be 1627
print(species_sf[1:3, ])        # preview first 3 rows

# Save as GeoPackage (recommended for SDI — open standard, single file)
st_write(species_sf, 
         "species_berchtesgaden.gpkg",
         layer   = "species_occurrences",
         delete_layer = TRUE)

# Also save as Shapefile (in case other tools need it)
st_write(species_sf,
         "species_berchtesgaden.shp",
         delete_layer = TRUE)

# Confirm files saved
file.exists("species_berchtesgaden.gpkg")
file.exists("species_berchtesgaden.shp")
