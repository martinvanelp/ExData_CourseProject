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

# describe SCC
NEIplus <- merge(NEI, SCC, by = "SCC")

# subset NEI for coal combustion
coal <- grep("Coal", NEIplus[,"Short.Name"])
comb <- grep("Comb", NEIplus[,"Short.Name"])
coalcomb <- intersect(coal, comb)

ssNEI <- NEIplus[coalcomb, ]

# analysis and plot
years <- c(1999, 2002, 2005, 2008)
plotData <- with(ssNEI, tapply(Emissions, year, sum))

png("plot4.png", width = 480, height = 480)

plot(plotData, pch = 20, xaxt = "n", ylim = c(0, 0.8*10^6),
     main = "United States", xlab = "Year", ylab = "Coal combustion PM25")
axis(1, at = c(1, 2, 3, 4), labels = years)
abline(lm(plotData ~ c(1:4)), lwd = 2, col = "green")

dev.off()
