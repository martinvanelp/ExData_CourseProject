##
## Exploratory Data Analysis: Course project
## Goal: The overall goal of this assignment is to explore
##       the National Emissions Inventory database and see 
##       what it say about fine particulate matter pollution
##       in the United states over the 10-year period 1999-2008.
##

#  fetch data
if (!file.exists("emissions.zip")) { 
        fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
        download.file(fileUrl, destfile = "./emissions.zip")
}

unzip("./emissions.zip")

# Reading data: this first line will likely take a few seconds.
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# subset NEI for Baltimore
ssNEI <- subset(NEI, fips == "24510")
zeroEmissions <- ssNEI$Emissions == 0
ssNEI$logEmissions <- 0
ssNEI$logEmissions[!zeroEmissions] <- log(ssNEI$Emissions[!zeroEmissions])

# analysis and plot
library(ggplot2)

png("plot3.png", width = 480, height = 480)

qplot(year, logEmissions, data = ssNEI, color = type, 
      geom = c("point", "smooth"), method = "lm")

dev.off()
