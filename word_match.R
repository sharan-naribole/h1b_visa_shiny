word_matches <- function(input, record) {
  record <- trimws(tolower(record))
  input <- trimws(tolower(input))
  print(paste("input:",input))
  print(paste("record: ",record))
  pos <- regexpr(input,record)
  pos <- pos[1]
  print(paste("position: ",pos))
  
  if(pos == -1) {
    return(FALSE)
  } else {
    before <- substr(record, pos -1, pos -1)
    print(paste("before:",before))
    if(trimws(before) != "") {
      return(FALSE)
    }
    after <- substr(record, pos + nchar(input), pos + nchar(input))
    print(paste("after: ",after))
    if(!(trimws(after) %in% c("",",","."))) {
      return(FALSE)
    }
  }
  return(TRUE)
}

job_filteres <- function(df,value_list) {
  if(length(value_list) == 0) {
    return(df %>%
             mutate(JOB_INPUT_CLASS = JOB_TITLE))
  }
  
  new_df <- data.frame()
  
  for(value in value_list){
    df$value_filt <- sapply(df$JOB_TITLE, function(x,y) {return(word_matches(x,y))}, x = value)
    
    new_df <- rbind(new_df, df %>% 
                      filter(value_filt == TRUE) %>%
                      select(- value_filt) %>%
                      mutate(JOB_INPUT_CLASS = value))
  }
  return(unique(new_df))
}

employer_filteres <- function(df, value_list) {
  if(length(value_list) == 0) {
    return(df)
  }
  
  new_df <- data.frame()
  
  for(value in value_list){
    df$value_filt <- sapply(df$EMPLOYER_NAME, function(x,y) {return(word_matches(x,y))}, x = value)
    
    new_df <- rbind(new_df, df %>% 
                      filter(value_filt == TRUE) %>%
                      select(- value_filt))
  }
  return(unique(new_df))
}