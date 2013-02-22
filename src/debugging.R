a <- mapreduce(input="~/temp/training.small.csv",
               input.format="text",
               #                output.format="text",
               map=poisson.subsample,
               reduce=fit.trees,
               output=NULL)

b <- from.dfs(a)


training.data <- read.table("~/temp/training.csv",
                            header=FALSE,
                            sep=",",
                            quote="\"",
                            row.names=NULL,
                            col.names=column.names,
                            fill=TRUE,
                            na.strings=c("NA"),
                            colClasses=c(MachineID="NULL",
                                         SalePrice="numeric",
                                         YearMade="numeric",
                                         MachineHoursCurrentMeter="numeric",
                                         ageAtSale="numeric",
                                         saleYear="numeric",
                                         ModelCount="numeric",
                                         MfgYear="numeric",
                                         ModelID.x="factor",
                                         ModelID.y="factor",
                                         fiManufacturerID="factor",
                                         datasource="factor",
                                         auctioneerID="factor",
                                         saledatenumeric="numeric",
                                         saleDay="factor",
                                         Stick_Length="numeric"))

a <- randomForest(formula=model.formula, data=training.data, na.action=na.roughfix, ntree=10)



# Figure
library(ggplot2)
x <- seq(0, 10, len=10000)
y <- exp(-x) * 100
p <- qplot(x, y, geom="line", xlab=expression(KM/N), ylab="Percent of initial data set missed")
p + geom_line(mapping=aes(x=c(0, 1, 1), y=c(exp(-1)*100, exp(-1)*100, 0)), color="gray") + 
  geom_point(mapping=aes(x=1, y=exp(-1)*100), color="gray")