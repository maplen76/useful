# package name mapping is stored on JSON: http://10.196.19.107/rabbids/gen/metadata.json
library(dplyr)
library(jsonlite)
library(xlsx)
rm(list = ls())

package_jason<- fromJSON("http://10.196.19.107/rabbids/gen/metadata.json",simplifyDataFrame = T)

pks <- names(package_jason$events$packages)
i = 1
pk_list <- data.frame()

for (i in 1:length(pks)) {
    pk_id <- pks[i]
    pk_title <- package_jason$events$packages[[i]]$title$en
    # gey package content
    pk_can <- paste('can:', package_jason$events$packages[[i]]$can, sep = "", collapse = "")
    pk_plunger <- paste('plunger:', package_jason$events$packages[[i]]$plunger, sep = "", collapse = "")
    pk_suits <- paste('suit:', package_jason$events$packages[[i]]$suits, sep = "", collapse = ", ")
    pk_content <- paste(pk_can, pk_plunger, pk_suits, sep = ', ', collapse = "")
    
    pk_price <- package_jason$events$packages[[i]]$price
    pk_valid_date <- paste(package_jason$events$packages[[i]]$beginDate, package_jason$events$packages[[i]]$endDate, sep = ",", collapse = "")
    
    pk <- data.frame(itemType = 'package', itemId = pk_id, itemName = pk_content, validDate = pk_valid_date, price = pk_price, title = pk_title)
    pk_list <- rbind(pk_list, pk)
}

pk_list %>% 
    tbl_df() %>% 
    arrange(itemId)

print(pk_list)

filePath <- paste("F:/Mobile - Rabbids/data tracking/itemMapping/PackageMapping/", format(Sys.Date(), format="%Y.%m.%d"), " - ", "package_mapping.xlsx", collapse = "", sep = "")

write.xlsx(as.data.frame(pk_list), filePath, showNA = FALSE, row.names = F)
