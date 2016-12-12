require(pacman)
p_load(rgdal, tidyr, dplyr)
tl <- readOGR("I:\\Research\\samba\\gisdata\\PortlandRLIS\\Current\\TAXLOTS", "taxlots")

#remove few extraneous columns and subset to residential PDX properties
tl2 <- tl[,-(1|20|22|26:27|32:33)] 
tl2 <- subset(tl2, tl2$LANDUSE == "SFR"| tl2$LANDUSE == "MFR"| tl2$LANDUSE == "VAC")
tl2 <- subset(tl2, tl2$SITECITY == "PORTLAND")

#creating owner and tlid table
owner1 <- tl2@data %>% select(1,4)
owner2 <- tl2@data %>% select(1,5)
owner3 <- tl2@data %>% select(1,6)
owner.list <- as.list(owner1, owner2, owner3)

ownerID <- bind_rows(owner.list)

require(stringr)
ownerID$TLID <- as.character(ownerID$TLID)
ownerID$OWNER1 <- as.character(ownerID$OWNER1)

#remove special characters from owner1 column
ownerID$OWNER1 <- gsub("[[:punct:]]", " ", ownerID$OWNER1)

ownerID$TLID <- str_trim(ownerID$TLID, side = "both")
ownerID$OWNER1 <- str_trim(ownerID$OWNER1, side = "both")

#ownerID$TLID <- gsub(" ", "", ownerID$TLID, fixed = TRUE)
#ownerID$OWNER1 <- gsub(" ", "", ownerID$OWNER1, fixed = TRUE)
require(foreign)

write.dbf(tl2, "taxlot_sub.dbf")

