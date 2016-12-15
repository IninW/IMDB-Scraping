library(rvest)
movie_info<-read.csv("gross_movie3.csv", header = T)
total_movies<-length(movie_info[,1])
full.info<-NULL
for (i in 1:total_movies)
{
  print(paste("Film=",i))
  name<-as.vector(movie_info[i,1])
  budget<-as.numeric(movie_info[i,2])
  gross<-as.numeric(movie_info[i,3])
  url<-as.vector(movie_info[i,4])
  movie <- read_html(url, encoding = "UTF-8")
  website<-html_nodes(movie,"div")
  business<-html_text(website)
  business<-business[48]
  business<-gsub('\n',' ',business) #replace \n with space
  business<-as.list(strsplit(business," ")[[1]]) #split string based on space 
  business<-business[nchar(business)>0] #Remove zero length strings
  if (length(business[grep("Gross",business)])==0)
  {
    gross1 = NA
    region = NA
  } else
  {
    gross1<-business[grep("Gross",business)[1]+1]
    region<-business[grep("Gross",business)[1]+2]
  }
  if (length(business[grep("Budget",business)])==0)
  {
    budget1 = NA
  } else
  {
    budget1<-business[grep('Budget', business)+1]
  }
  imdb<-cbind(name,budget,gross,budget1,gross1,region)
  full.info<-rbind(full.info,imdb)
}
write.csv(full.info,file="budget.csv",row.names = FALSE)
write.table(full.info,file="gross.txt",row.names = FALSE,sep="\t")
