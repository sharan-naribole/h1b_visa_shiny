## Helper file
word_match <- function(input, record) {
  record <- trimws(tolower(record))
  #print(paste("input:",input))
  print(paste("record: ",record))
  pos <- regexpr(input,record)
  pos <- pos[1]
  #print(paste("position: ",pos))
  
  if(pos == -1) {
    return(FALSE)
  } else {
    before <- substr(record, pos -1, pos -1)
    #print(paste("before:",before))
    after <- substr(record, pos + nchar(input), pos + nchar(input))
    #print(paste("after: ",after))
    
    if((before != "" & before != " ") | (after != "" & after != " ")) {
      return(FALSE)
    }
    return(TRUE)
  }
}


job_filter <- function(df,value_list) {
  if(length(value_list) == 0) {
    return(df %>%
             mutate(JOB_INPUT_CLASS = JOB_TITLE))
  }
  
  new_df <- data.frame()
  
  for(value in value_list){
    new_df <- rbind(new_df, df %>% 
                      filter(word_match(value,JOB_TITLE) == TRUE) %>%
                      mutate(JOB_INPUT_CLASS = value))
  }
  return(new_df)
}

employer_filter <- function(df, value_list) {
  if(length(value_list) == 0) {
    return(df)
  }
  
  new_df <- data.frame()
  
  for(value in value_list){
    new_df <- rbind(new_df, df %>% 
                      filter(word_match(value,EMPLOYER_NAME) == TRUE))
  }
  return(new_df)
}
  
plot_input <- function(df, x_feature, fill_feature, metric,filter = FALSE, ...) {
  
  #Finding out the top across the entire range independent of the fill_feature e.g. Year
  top_x <- unlist(find_top(df,x_feature,metric, ...))
  
  filter_criteria <- interp(~x %in% y, .values = list(x = as.name(x_feature), y = top_x))
  arrange_criteria <- interp(~ desc(x), x = as.name(metric))

  if(filter == TRUE) {
    df %>%
      filter_(filter_criteria) -> df
  }
  
  #Grouping by not just x_feature but also fill_feature
  return(df %>% 
    group_by_(.dots=c(x_feature,fill_feature)) %>% 
    mutate(certified =ifelse(CASE_STATUS == "CERTIFIED",1,0)) %>%
      summarise(TotalApps = n(),CertiApps = sum(certified), Wage = median(PREVAILING_WAGE)))
}
  
plot_output <- function(df, x_feature,fill_feature,metric, xlabb,ylabb) {  
  options(scipen = 999)
  
  g <- ggplot(df, aes_string(x=x_feature,y=metric)) +
    geom_bar(stat = "identity", aes_string(fill = fill_feature), position = "dodge") + 
    coord_flip() + xlab(xlabb) + ylab(ylabb) + get_theme()
  
  return(g)
}

find_top <- function(df,x_feature,metric, Ntop) {
  
  arrange_criteria <- interp(~ desc(x), x = as.name(metric))
  
  df %>% 
    group_by_(x_feature) %>% 
    mutate(certified =ifelse(CASE_STATUS == "CERTIFIED",1,0)) %>%
    summarise(TotalApps = n(),
              Wage = median(PREVAILING_WAGE), 
              CertiApps = sum(certified)) %>%
      arrange_(arrange_criteria) -> top_df
  
  top_len <- min(dim(top_df)[1],Ntop)
  
  return(top_df[1:top_len,1])
}

map_gen <- function(df,metric,USA,...) {
  # Map Dataframe
  df %>%
    mutate(certified =ifelse(CASE_STATUS == "CERTIFIED",1,0)) %>%
    group_by(WORKSITE,lat,lon) %>%
    summarise(TotalApps = n(),CertiApps = sum(certified), Wage = median(PREVAILING_WAGE)) -> map_df
  # 
  # # Lat-Long Limits
  # df %>%
  #   summarise(lat_min = min(lat,na.rm=TRUE),
  #             lat_max = max(lat,na.rm=TRUE),
  #             long_min = min(lon,na.rm=TRUE),
  #             long_max = max(lon,na.rm=TRUE)) -> geo_coord


  # Finding top Locations
  top_locations <- unlist(find_top(df,"WORKSITE",metric, ...))
  
  g <- ggplot(USA, aes(x=long, y=lat)) + 
    geom_polygon() + xlab("Longitude (deg)") + ylab("Latitude(deg)") + 
    geom_point(data=map_df, aes_string(x="lon", y="lat", alpha = metric, size = metric), color="yellow") + 
    geom_label_repel(data=map_df %>% filter(WORKSITE %in% top_locations),aes_string(x="lon", y="lat",label = "WORKSITE"),
                     fontface = 'bold', color = 'black',
                     box.padding = unit(0.0, "lines"),
                     point.padding = unit(1.0, "lines"),
                     segment.color = 'grey50',
                     force = 3) +
    #coord_map(ylim = c(max(geo_coord$lat_min - 5,23), min(geo_coord$lat_max - 5,50)),xlim=c(max(geo_coord$long_min - 5,-130),min(geo_coord$long_max + 5,-65))) +
    coord_map(ylim = c(23,50),xlim=c(-130,-65)) +
    get_theme()
  
  return(g)
}

get_theme <- function() {
  return(
    theme(axis.title = element_text(size = rel(1.5)),
          legend.position = "right",
          legend.text = element_text(size = rel(1.5)),
          legend.title = element_text(size=rel(1.5)),
          axis.text = element_text(size=rel(1.5))) 
  )
}
