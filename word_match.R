word_matches <- function(input, record) {
  record <- trimws(tolower(record))
  #print(paste("input:",input))
  print(paste("record: ",record))
  pos <- regexpr(input,record)
  pos <- pos[1]
  print(paste("position: ",pos))
  
  if(pos == -1) {
    return(FALSE)
  } else {
    before <- substr(record, pos -1, pos -1)
    print(paste("before:",before))
    after <- substr(record, pos + nchar(input), pos + nchar(input))
    print(paste("after: ",after))
    
    if((before != "" & before != " ") | (after != "" & after != " ")) {
      return(FALSE)
    }
    return(TRUE)
  }
}

job_filteres <- function(df,value_list) {
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

job_filteres(kk %>% filter(regexpr('data scientist', JOB_TITLE) != -1),c("data scientist"))
