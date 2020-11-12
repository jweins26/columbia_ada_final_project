library(lubridate)
library(DataCombine)

setwd("~/Documents/School/Columbia/Fall 2018/ADA/Group Project")
df = read.csv("Fantasy Basketball Dataset - Full Dataset.csv")
rank = read.csv("team_ranking.csv", header = F)
colnames(rank) = c("Ranking", "Long_Team", "Team")

# home and away variables
df$home = as.numeric(grepl("vs", df$Opponent))
df$away = as.numeric(grepl("@", df$Opponent))

# rankings
df$Opponent_Team = gsub("vs |@ ", "", df$Opponent)
df$team_ranking = rank$Ranking[match(df$Team, rank$Team)]
df$opponent_ranking = rank$Ranking[match(df$Opponent_Team, rank$Team)]

## Get date and month
df$Date = gsub("-", " ", df$Date)
date_format1 = as.Date(df$Date, "%d %b")
date_format2 = as.Date(df$Date, "%b %d")
date_format1[is.na(date_format1)] = date_format2[!is.na(date_format2)]
df$Processed_Date = date_format1
df$Month = month(df$Processed_Date)

## Lag variables

all_teams_df = list()
unique_teams = unique(df$Team)
lag_var = c("AST", "BLK", "STL", "PTS", "TO", "REB")

for (i in 1:length(unique_teams)) {
      team_df = df[df$Team == unique_teams[i],]
      for (j in 1:3) {
            for (v in lag_var) {
                  team_df = slide(team_df, Var = v, slideBy = -j)
            }
      }
      all_teams_df[[i]] = team_df
}

all_teams_df = data.frame(do.call(rbind, all_teams_df))







