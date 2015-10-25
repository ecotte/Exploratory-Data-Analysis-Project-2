##################
# Load Libraries #
##################
library(dplyr)
library(data.table)

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

sumSCC$yearfac <- factor(sumSCC$year)

sccByYear <- ddply(sumSCC,.(year),summarise, Total.Emissions = sum(Emissions))

#Open PNG Graphic Device
png("plot1.png");

# Make plot
plot(sccByYear$year,sccByYear$Total.Emissions,type="l",main = "Total PM2.5 emission from all sources",xlab="Year",ylab="PM2.5 Emission")

#Close Graphic Device
dev.off()
