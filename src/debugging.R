a <- mapreduce(input="~/temp/training.small.csv",
               input.format="text",
               #                output.format="text",
               map=poisson.subsample,
               reduce=fit.trees,
               output=NULL)

b <- from.dfs(a)


training.data <- read.table("~/temp/training.small.csv",
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