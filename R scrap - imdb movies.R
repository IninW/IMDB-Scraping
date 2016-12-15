# load data
library(rvest)
movie_info<-read.csv("movie.csv", header = T)

# preparation for for loop
total_movies<-length(movie_info[,1])
full.info<-NULL

# use for loop to get info one by one
for (i in 1:total_movies)
{
  print(paste("Film=",i))
  name<-as.vector(movie_info[i,2])
  year<-as.numeric(movie_info[i,1])
  url<-as.vector(movie_info[i,3])
  movie <- read_html(url, encoding = "UTF-8")
  website<-html_nodes(movie,"a")
  release<-html_text(website)
  release<-release[grep("[0-9]{1,2}[ ][A-Z][a-z]{2,8}[ ][0-9]{4}",release)]
  if (length(release)==0)
  {
    release = NA
  } else
  {
    release<-gsub('\n',' ',release) #replace \n with space
    release<-as.list(strsplit(release," ")[[1]]) #split string based on space 
    release<-release[nchar(release)>0] #Remove zero length strings
    year<-release[grep("[0-9]{4}",release)]
    release<-release[grep("[0-9]{4}",release)-1]
    release<-unlist(release) #Flatten release
  }
  imdb<-cbind(name,year,release)
  full.info<-rbind(full.info,imdb)
}
write.csv(full.info,file="release.csv",row.names = FALSE)
write.table(full.info,file="release.txt",row.names = FALSE,sep="\t")