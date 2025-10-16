rm(list = ls())

library(LDA)
library(jsonlite)
library(googlesheets4)
wd()

options(gargle_oauth_cache = 'secrets')
gs4_auth(email = 'caiogcg.mobilidade@gmail.com')


sheet <- read_sheet('https://docs.google.com/spreadsheets/d/1GlBK3u-CFrc361fOSknqt_z45tg-4CPjj6-4u2BszJ0/edit?gid=0#gid=0')


toJSON(sheet) %>% 
  write_json('')




