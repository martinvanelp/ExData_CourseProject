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
motor <- grep("Motor", NEIplus[,"Short.Name"])
ssNEI_BT <- subset(NEIplus[motor, ], fips == "24510")
ssNEI_LA <- subset(NEIplus[motor, ], fips == "06037")

# analysis and plot
years <- c(1999, 2002, 2005, 2008)
plot_BT <- with(ssNEI_BT, tapply(Emissions, year, sum))
plot_LA <- with(ssNEI_LA, tapply(Emissions, year, sum))

png("plot6.png", width = 480, height = 480)

plot(plot_BT, pch = 20, xaxt = "n", ylim = c(0, 100), col = "purple",
     main = "Baltimore v Los Angeles",
     xlab = "Year", ylab = "Motor Vehicle PM25")
axis(1, at = c(1, 2, 3, 4), labels = years)
abline(lm(plot_BT ~ c(1:4)), lwd = 2, col = "purple")
points(plot_LA, pch = 20, col = "yellow4")
abline(lm(plot_LA ~ c(1:4)), lwd = 2, col = "yellow4")
legend("topleft", pch = 20, col = c("purple", "yellow4"),
       legend = c("Baltimore", "Los Angeles"))

dev.off()
