rm(list = ls())

library(LDA)
library(jsonlite)
library(googlesheets4)
wd()

options(gargle_oauth_cache = 'secrets')
gs4_auth(email = 'caiogcg.mobilidade@gmail.com')


sheet <- read_sheet('https://docs.google.com/spreadsheets/d/1GlBK3u-CFrc361fOSknqt_z45tg-4CPjj6-4u2BszJ0/edit?gid=0#gid=0')


sheet[1,] %>% 
  as.vector() %>% 
  toJSON()

json <- sheet %>% 
  apply(1,function(x){
    paste0('"',names(x),'":"',x,'"') %>% paste0(collapse = ',')
  })

json <- paste0('{',json,'}') %>% paste0(collapse = ',')

json <- paste0('[',json,']')

writeLines(json,'noticias_conteudos.json')


library(gh)

owner <- "cgmobility"
repo <- "pmf_portal_bike_for"
path <- "Not%C3%ADcias%20e%20conte%C3%BAdos/noticias_conteudos.json"
branch <- "main"
token <- Sys.getenv("GITHUB_PAT")


# 1. pegar sha atual
resp <- gh("GET /repos/{owner}/{repo}/contents/{path}",
           owner = owner, repo = repo, path = path, ref = branch)
sha <- resp$sha

# 2. preparar novo conteúdo
novo_base64 <- base64enc::base64encode(charToRaw(json))

# 3. enviar atualização
gh("PUT /repos/{owner}/{repo}/contents/{path}",
   owner = owner, repo = repo, path = path,
   message = "Atualização via API",
   content = novo_base64,
   sha = sha,
   branch = branch)



