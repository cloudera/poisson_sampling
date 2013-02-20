# Join transaction and machine tables
library(stringr)

na.values <- c("", "None or Unspecified", "Unspecified")

# set up some facilities for parsing different columns
parse.height <- function(from) {
  data <- lapply(str_extract_all(from, "[0-9]+"), as.numeric)
  sapply(data, function(x) {x[1] * 12 + x[2]})
}

setAs("character", "custom.date.1", function(from) {as.Date(from, format="%Y")})
setAs("character", "custom.date.2", function(from) {as.Date(from, format="%m/%d/%Y %H:%M")})
setAs("character", "tire.size", function(from) {as.numeric(gsub("[ \"]*$", "", from))})
setAs("character", "undercarriage", function(from) {as.numeric(gsub("[ a-zA-Z\"]*$", "", from))})
setAs("character", "stick.length", parse.height)

transactions <- read.table(file="~/Downloads/Train.csv",
                           header=TRUE,
                           sep=",",
                           quote="\"",
                           row.names=1,
                           fill=TRUE,
                           colClasses=c(MachineID="factor",
                                        ModelID="factor",
                                        datasource="factor",
                                        YearMade="character",
#                                         SalesID="character",
                                        auctioneerID="factor",
                                        UsageBand="factor",
                                        saledate="custom.date.2",
                                        Tire_Size="tire.size",
                                        Undercarriage_Pad_Width="undercarriage",
                                        Stick_Length="stick.length"),
                           na.strings=na.values)

machines <- read.table(file="~/Downloads/Machine_Appendix.csv",
                       header=TRUE,
                       sep=",",
                       quote="\"",
                       fill=TRUE,
                       colClasses=c(MachineID="character",
                                    ModelID="factor",
                                    fiManufacturerID="factor"),
                       na.strings=na.values)

# add a few features to the transaction data
transactions$saledatenumeric <- as.numeric(transactions$saledate)
transactions$ageAtSale <- as.numeric(transactions$saledate - as.Date(transactions$YearMade, format="%Y"))
transactions$saleYear <- as.numeric(format(transactions$saledate, "%Y"))
transactions$saleMonth <- as.factor(format(transactions$saledate, "%B"))
transactions$saleDay <- as.factor(format(transactions$saledate, "%d"))
transactions$saleWeekday <- as.factor(format(transactions$saledate, "%A"))
transactions$YearMade <- as.integer(transactions$YearMade)
transactions$MedianModelPrice <- unsplit(lapply(split(transactions$SalePrice, transactions$ModelID), median), transactions$ModelID)
transactions$ModelCount <- unsplit(lapply(split(transactions$SalePrice, transactions$ModelID), length), transactions$ModelID)

# join the transaction and machine data
training.data <- merge(x=transactions, y=machines, by="MachineID")

# write denormalized data out
write.table(x=training.data,
            file="~/temp/training.csv",
            sep=",",
            quote=TRUE,
            row.names=FALSE,
            eol="\n",
            col.names=FALSE)
