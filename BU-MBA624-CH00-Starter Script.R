# MBA/MSF 624 - A starter script

# Somes Notes
# 1) Use the "#" key for commenting in your script. This can be used at the beginning of the line or at the end of command lines, like in the library(Deducer) command line
# 2) This script file provides a basis for building more advanced scripts. Pick and choose pieces when you start new script files.
# 3) Like any tool, R possesses areas of strength, but it is not the end-all. You may find your own preferences, such as using Excel for visuals and graphics, forecasting, etc. 
# 4) This script will walk you through some basic functions of R, such as simple commands, reading and writing data, exploring data, and performing some analytical techniques.
# 5) You can run commands by selecting the commands and clicking the Run button above or using the <CNTRL><ENTER> keys simultaneously 
# 6) There are many ways to accomplish tasks, as shown in the LOOPS section below.
# 7) The R Interpreter, like all languages, is very picky. Command must follow precise expectations. Be patient as you learn.

# Clear Out Environment if desired. Removes all entries in the Global Environment.
rm(list=ls())

# Set a working Directory
#setwd("C:/Users/Joe/Documents")  # Notice the "/" instead of a "\" like windows uses.

# Load packages -Many R features and capabilities reside in packages, which you will leverage heavily as you learn the language 
library(Hmisc)         # General statistical analysis and data management functions
library(Deducer)       # for Descriptive Table

################################
# A SIMPLE COMMAND             #           
################################

# What type of tutorial would this be without a "Hello World" command.
print("Hello World")                                        # Notice the results appear in the Console below. You can also run single commands in the console, if you like


################################
# LOOPS                        #            
################################

# Let's move on to a loop, which are commonly used in programming
# While AIs such as CHATGPT are not allowed to write your work in my class, it is a good source for code.
# try prompting "how do I write a loolk in R" and get a starting point for your code.

vLoop <- TRUE   # You define variables using the <- command. I like naming variables with a "v" then descriptive. In this base, I've set the boolean variable vLoop to TRUE
vCnt  <- 1      # Here, i've defined the variable vCnt as a numeric which will provide a counter for a loop
while (vCnt <=10) {
  print(vCnt)
  vCnt = vCnt + 1
}

# Another way
vLoop <- TRUE   # You define variables using the <- command. I like naming variables with a "v" then descriptive. In this base, I've set the boolean variable vLoop to TRUE
vCnt  <- 1      # Here, i've defined the variable vCnt as a numeric which will provide a counter for a loop
while (vLoop==TRUE) {                          # Notice when checking the value of a variable, the "==" double equal sign is used.
  print(vCnt)
  vCnt = vCnt + 1
  if (vCnt >10) {
    vLoop = FALSE
   }
}

# Another way
vCnt  <- 1      # Here, i've defined the variable vCnt as a numeric which will provide a counter for a loop
repeat {
  print(vCnt)
  vCnt = vCnt + 1
  if (vCnt >10) {
    break
  }
}


################################
# Exploring R internal Dataset #             
################################

# R comes pre-loaded with some datasets. Here we will use the mtcars dataset
#data()                                       # this command shows you the available datasets to explore and work with.
# Loading
data(mtcars)
# Print the first 6 rows
head(mtcars, 6)

# Number of rows (observations)
nrow(mtcars)

# Look at some Descriptive Information
descriptive.table(vars=d(mpg, cyl, hp,gear,wt),
                  data=mtcars,func.names = c("Mean","Median","St. Deviation","Valid N","Max","Min","Skew","Kurtosis"))

# review a few histograms of the data elements
hist(mtcars$hp)                                    # mtcars is a dataframe. We reference fields in the dataframe using "$"
hist(mtcars$disp)
hist(mtcars$cyl)
hist(mtcars$mpg)


################################
# Exploring an external Dataset#             
################################


# Read in a file (CH01-Diabetes.csv)  Your can directly refernece 

# Your can directly reference the file by providing the specific folder location and filename.
#df <- read.csv("C:/Users/JohnDoes//MBA624/Interim/CH01-Diabetes.csv", header = TRUE)

# or use the file.choose() function to allow you to select the file from your computer. 
# Below, we define the dataframe "df"
df <- read.csv(file.choose(),header = TRUE)      # look for a pop-up window from which to select the file.

# Explore the data 
head(df,10)
# Descriptives...
descriptive.table(vars=d(Pregnancies, Glucose, BloodPressure,SkinThickness,Insulin,BMI,DiabetesPedigreeFunction,Age,Outcome),
                  data=df,func.names = c("Mean","Median","St. Deviation","Valid N","Max","Min","Skew","Kurtosis"))

hist(df$BMI)
hist(df$Glucose)
hist(df$BloodPressure)

# Correlation
cor(df, use="complete.obs", method="pearson")
rcorr(as.matrix(df))              # used Hmisc library

# Add a variable for individuals above and below the median BMI
vBMIMedian <- median(df$BMI)
df$BMICategory <- ifelse(df$BMI >= vBMIMedian, 1,0)
# Now review the descriptives by BMICategory
descriptive.table(vars=d(Pregnancies, Glucose, BloodPressure,SkinThickness,Insulin,BMI,DiabetesPedigreeFunction,Age,Outcome),
                  data=df,strata=df$BMICategory,func.names = c("Mean","Median","St. Deviation","Valid N","Max","Min","Skew","Kurtosis"))
# Compare the mean glucose for individuals above vs below BMI using an ANOVA (you'll learn this later)
model1 <- aov(Glucose ~ BMICategory,data = df)
summary(model1)                                              # A significant different exists between the groups. (you'll learn about this later)

# Now conduct a univariate regression to compare the same mean values by category
model2 <- lm(Glucose ~ BMICategory,data = df)
summary(model2)                                                # Same results, but shown differently. Individuals with BMI great than mean will on average have a 10.549 point higher Glucose level.

# Now write the df dataframe to a csv file, where you and review the file with the BMICategory field added.
write.csv(df, "CH01-Diabetes-Modified.csv",row.names = FALSE)
# Now go find this file and see the output.  (Mine was in the Documents folder, since I didn't set a working directory)


