##################
# Load Libraries #
##################
library(dplyr)
library(data.table)
library(ggplot2)

#########################
# Set general variables #
#########################
dataDir = "./data"
url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
fileName = "DataSet.zip"
filePath = paste(dataDir,"/",fileName,sep = "")

summarySCCLocation = paste(dataDir,"/","summarySCC_PM25.rds",sep = "")
sccLocation = paste(dataDir,"/Source_Classification_Code.rds",sep = "")

###################################
# Create data directory if needed #
###################################
if (!file.exists(dataDir)) {
  dir.create(file.path(dataDir))
}

#################
# Doenload data #
#################
download.file(url = url,destfile = filePath)

unzip(zipfile = filePath,overwrite = TRUE,exdir = dataDir)

#############
# Load data #
#############
sumSCC <- tbl_df(readRDS(summarySCCLocation))

scc <- tbl_df(readRDS(sccLocation))

###################################
# Get the total emissions by Year #
###################################

coalSCC <- select(scc[which(grepl("Coal",scc$EI.Sector)),],1,EI.Sector)

coalSumSCC <- filter(sumSCC,SCC %in% coalSCC$SCC)

coalSumSCC$yearfac <- factor(coalSumSCC$year)

sccByTypeYear <- ddply(coalSumSCC,.(yearfac),summarise, Total.Emissions = sum(Emissions))

#Open PNG Graphic Device
png("plot4.png");


# Make plot
ggplot(sccByTypeYear, aes(yearfac,Total.Emissions)) +
  geom_point(size = I(4),color="blue") +
  ggtitle("Total emissions of coal combustion in the US") +
  labs(x = "Year",y = "PM25 Emission")

#Close Graphic Device
dev.off()
