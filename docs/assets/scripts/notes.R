# notes

#-> Todo: decide whether to keep or not

txt<-"Bonjour la planète! Moi c'est Tania"

for(col in 40:47){ 
  cat(paste0("\033[0;", col, "m",txt,"\033[0m","\n"))
}

# ANSI colors: https://gist.github.com/JBlond/2fea43a3049b38287e5e9cefc87b2124
# https://stackoverflow.com/questions/10802806/is-there-a-way-to-output-text-to-the-r-console-in-color

# A tester:
#  https://github.com/marcosvital/teach-r-fun/blob/master/The%20ultimate%20list%20of%20cool%20and%20unorthodox%20examples%20in%20R.md
# (eg pokemon colors?)