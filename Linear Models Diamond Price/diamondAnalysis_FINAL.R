##############################################
# WORKING R FILE # 
# LAST MODIFIED : 7/17/19 
##############################################

install.packages("car")

#setwd("~/Desktop/proj_1")
getwd()

diamonds <- read.csv("clean_diamond_data.csv",sep = ',',header = TRUE,na.strings=c(""," ","NA"))

summary(diamonds)
data(diamonds)
head(diamonds)
tail(diamonds)


price_model <- lm(formula = price ~ carat, data = diamonds)

diamonds$carat_t <- log(diamonds$carat)
diamonds$price_t <- log(diamonds$price)

library(MASS)
model <- lm(price_t ~ carat_t + cut + color + clarity , data = diamonds)
summary(model)

vif(model)
X <- model.matrix(model)
cor(X[,-1])
pairs(X[,-1])

extern_s_resids <-studres(model)
qqnorm(extern_s_resids)
qqline(extern_s_resids)
plot(fitted.values(model), extern_s_resids, main = "Residuals vs. Fitted Values for Transformed Model", ylab = "Externally Studentized Residuals", xlab = "Fitted Values")



model_t <- lm(price_t ~ carat_t + cut + color + clarity + carat_t:cut + carat_t:color + carat_t:clarity, data = diamonds)
summary(model_t)



# Histograms/Scatterplots/Graphs(BEFORE TRANSFORMATION) ------------------------------------------
#added a normal distribution line in histogram


hist(diamonds$price, freq=FALSE, col="gray", xlab="Price", main="The frequency distribution of the price of diamonds")
curve(dnorm(x, mean=mean(diamonds$price), sd=sd(diamonds$price)), add=TRUE, col="red")


hist(diamonds$carat, freq=FALSE, col="gray", xlab="Carat", main="The frequency distribution of carats")
curve(dnorm(x, mean=mean(diamonds$carat), sd=sd(diamonds$carat)), add=TRUE, col="red")


## TWO MOST SIGNIFICANT FACTORS ON THE X AND Y - 
#scatterplot3d(formula, y=carat, z=price)

#scatterplot3d(diamonds[,1:3],
            # main="3D Scatter Plot",
              #xlab = "test",
              #ylab = "price",
              #zlab = "carat")

library(car)


# Scatter Plot plot(diamonds$price,diamonds$carat)

plot(diamonds$price, diamonds$carat,
     col = "black", 
     pch = 8, 
     main = "Price VS Carat - Scatter Plot", 
     xlab = "Carat", 
     ylab = "Price", 
     las = 1)



#code to make av plot for carat and price
avPlots((lm(price~carat, data=diamonds)), main="AV Plot For Carat")

plot(diamonds$price,diamonds$carat)

#model of price based on all four regressors before any transformation
#dimmod <- lm(price~cut_scale+carat+color_scale+clar_scale, data=diamonds)

#Get the residuals of the mod
extern_s_resids <- studres(dimmod)

#qq plot of the model with all four predicters
qqstuff<- c(qqnorm(extern_s_resids), qqline(extern_s_resids))
print(qqstuff)


#model of price based on just price and carat
dimmodcarprice <- lm(price~carat, data=diamonds)

#Get the residuals of the mod
extern_s_resids2 <- studres(dimmodcarprice)

#qq plot of the model with only carat as the predicter
qqstuff<- c(qqnorm(extern_s_resids2), qqline(extern_s_resids2))
print(qqstuff)


# Models ------------------------------------------
                                            
#price_colorscale_model <- lm(formula = price ~ color_scale, data = diamonds)
#summary(price_colorscale_model)
#anova(price_colorscale_model)                                          
                                            
                                            
### price & cut scale model 

#price_cutScale_model <- lm(formular = price ~ cut_scale, data=diamonds)
#summary(price_cutScale_model)
#anova(price_cutScale_model)


multiple_model <- lm(formula = price ~ carat + cut_scale + color_scale, data = diamonds)
modprice_cut_color <- lm(price~cut_scale+color_scale, data=diamonds)
summary(modprice_cut_color)


## price carat  cut scale multiple regression 
multiple_model_price_cutScale <- lm(formula = price ~ carat +  cut_scale, data = diamonds)
summary(multiple_model_price_cutScale)
anova(multiple_model_price_cutScale)


multiple_model <- lm(formula = price ~ carat + cut_scale + color_scale, data = diamonds)
summary(multiple_model)
anova(multiple_model)

multiple_model2 <- lm(formula = price ~ carat +  color_scale, data = diamonds)
summary(multiple_model2)
anova(multiple_model2)

multiple_model3 <- lm(price ~ cut_scale + color_scale, data = diamonds)
summary(multiple_model3)
anova(multiple_model3)

multiple_model4 <- lm(formula = price ~ carat +  cut_scale, data = diamonds)
summary(multiple_model4)
anova(multiple_model4)

install.packages("MASS")
library(MASS)
extern_s_resids <- studres(price_carat_model)
hist(extern_s_resids)
qqnorm(extern_s_resids)
qqline(extern_s_resids)

price_carat_modelSubset1 <- lm(formula = price ~ carat, subset = price <= 698, data = diamonds)
summary(price_carat_modelSubset1)
price_carat_modelSubset2 <- lm(formula = price ~ carat, subset = 698 < price & price <= 1432, data = diamonds)
summary(price_carat_modelSubset2)
price_carat_modelSubset3 <- lm(formula = price ~ carat, subset = 1432 < price & price <= 4235, data = diamonds)
summary(price_carat_modelSubset3)
price_carat_modelSubset4 <- lm(formula = price ~ carat, subset = 4235 < price, data = diamonds)
summary(price_carat_modelSubset4)

price_cutScale_modelSubset1 <- lm(formula = price ~ cut_scale, subset = price <= 698, data = diamonds)
summary(price_cutScale_modelSubset1)
price_cutScale_modelSubset2 <- lm(formula = price ~ cut_scale, subset = 698 < price & price <= 1432, data = diamonds)
summary(price_cutScale_modelSubset2)
price_cutScale_modelSubset3 <- lm(formula = price ~ cut_scale, subset = 1432 < price & price <= 4235, data = diamonds)
summary(price_cutScale_modelSubset3)
price_cutScale_modelSubset4 <- lm(formula = price ~ cut_scale, subset = 4235 < price, data = diamonds)
summary(price_cutScale_modelSubset4)

price_colorScale_modelSubset1 <- lm(formula = price ~ color_scale, subset = price <= 698, data = diamonds)
summary(price_colorScale_modelSubset1)
price_colorScale_modelSubset2 <- lm(formula = price ~ color_scale, subset = 698 < price & price <= 1432, data = diamonds)
summary(price_colorScale_modelSubset2)
price_colorScale_modelSubset3 <- lm(formula = price ~ color_scale, subset = 1432 < price & price <= 4235, data = diamonds)
summary(price_colorScale_modelSubset3)
price_colorScale_modelSubset4 <- lm(formula = price ~ color_scale, subset = 4235 < price, data = diamonds)
summary(price_colorScale_modelSubset4)

multiple_modelSubset1 <- lm(formula = price ~ carat + cut_scale + color_scale, subset = price <= 698, data = diamonds)
summary(multiple_modelSubset1)
multiple_modelSubset2 <- lm(formula = price ~ carat + cut_scale + color_scale, subset = 698 < price & price <= 1432, data = diamonds)
summary(multiple_modelSubset2)
multiple_modelSubset3 <- lm(formula = price ~ carat + cut_scale + color_scale, subset = 1432 < price & price <= 4235, data = diamonds)
summary(multiple_modelSubset3)
multiple_modelSubset4 <- lm(formula = price ~ carat + cut_scale + color_scale, subset = 4235 < price, data = diamonds)
summary(multiple_modelSubset4)

multiple_model2Subset1 <- lm(formula = price ~ carat +  color_scale, subset = price <= 698, data = diamonds)
summary(multiple_model2Subset1)
multiple_model2Subset2 <- lm(formula = price ~ carat +  color_scale, subset = 698 < price & price <= 1432, data = diamonds)
summary(multiple_model2Subset2)
multiple_model2Subset3 <- lm(formula = price ~ carat +  color_scale, subset = 1432 < price & price <= 4235, data = diamonds)
summary(multiple_model2Subset3)
multiple_model2Subset4 <- lm(formula = price ~ carat +  color_scale, subset = 4235 < price, data = diamonds)
summary(multiple_model2Subset4)

multiple_model3Subset1 <- lm(formula = price ~ cut_scale + color_scale, subset = price <= 698, data = diamonds)
summary(multiple_model3Subset1)
multiple_model3Subset2 <- lm(formula = price ~ cut_scale + color_scale, subset = 698 < price & price <= 1432, data = diamonds)
summary(multiple_model3Subset2)
multiple_model3Subset3 <- lm(formula = price ~ cut_scale + color_scale, subset = 1432 < price & price <= 4235, data = diamonds)
summary(multiple_model3Subset3)
multiple_model3Subset4 <- lm(formula = price ~ cut_scale + color_scale, subset = 4235 < price, data = diamonds)
summary(multiple_model3Subset4)

multiple_model4Subset1 <- lm(formula = price ~ carat + cut_scale, subset = price <= 698, data = diamonds)
summary(multiple_model4Subset1)
multiple_model4Subset2 <- lm(formula = price ~ carat + cut_scale, subset = 698 < price & price <= 1432, data = diamonds)
summary(multiple_model4Subset2)
multiple_model4Subset3 <- lm(formula = price ~ carat + cut_scale, subset = 1432 < price & price <= 4235, data = diamonds)
summary(multiple_model4Subset3)
multiple_model4Subset4 <- lm(formula = price ~ carat + cut_scale, subset = 4235 < price, data = diamonds)
summary(multiple_model4Subset4)


#The transformations for the the price and carat variables
diamonds$pricetrans <- log(diamonds$price)
diamonds$carattrans <- log(diamonds$carat)
## Added two new columns after our transformation 


#Here is the boxcox on the not transformed data
library(MASS)
bc_res <- boxcox(diamonds$price~diamonds$carattrans + diamonds$clarity + diamonds$color + diamonds$cut, data = diamonds)
lambda <- bc_res$x[bc_res$y == max(bc_res$y)]
print(lambda)
# Lambda Value -0.02020202


#the boxplots 
boxplot(pricetrans ~ color, data = diamonds, 
        ylab = "y", xlab = "color")

boxplot(pricetrans ~ cut, data = diamonds, 
        ylab = "y", xlab = "cut")
boxplot(pricetrans ~ clarity, data = diamonds, 
        ylab = "y", xlab = "price")



# Partial F tests show that all the variables are significant 
big_mod <- lm(pricetrans~carattrans + color_scale + cut_scale + clar_scale, data=diamonds)

lil_modnoclar<- lm(pricetrans~carattrans + color_scale + cut_scale, data=diamonds)

lil_modnocut<- lm(pricetrans~carattrans + color_scale + clar_scale, data=diamonds)

lil_modnocol<- lm(pricetrans~carattrans + clar_scale + cut_scale, data=diamonds)

lil_modnocar<- lm(pricetrans~color_scale + clar_scale + cut_scale, data=diamonds)

anova(lil_modnoclar, big_mod)
anova(lil_modnocut, big_mod)
anova(lil_modnocol, big_mod)
anova(lil_modnocar, big_mod)


# We used f tests instead of t tests because every t - test could potentially introduce false rejection of the null hypothesis 

#To test for collinearity in other regressors: 

mod <- lm(diamonds$price_t~diamonds$carat_t+diamonds$cut_scale+diamonds$color_scale+diamonds$clar_scale, data = diamonds)
vif(mod)
X <- model.matrix(mod)
print(X)


# summary(aov)
# QUESTION WHICH MOD are we using 
#cor(X[,-1]) (highest correlation is cut and carat and that is still -0.18, so it doesn’t seem like we will have predictors correlated with each other.
            
#Residuals vs. values 


plot(diamonds$carat_t,diamonds$price_t)

multiple_model <- lm(formula = price_t ~ carat_t + cut_scale + color_scale + clar_scale, data = diamonds)

vif(multiple_model)
X <- model.matrix(multiple_model)
cor(X[,-1])

bc_res <- boxcox(diamonds$price~diamonds$carat_t + diamonds$clarity + diamonds$color + diamonds$cut, data = diamonds)
lambda <- bc_res$x[bc_res$y == max(bc_res$y)]


# Partial F tests show that all the variables are significant 

#Big mod including all regressors and all interaction terms with carat
big_mod <- lm(pricetrans~carattrans + color + cut + clarity + carattrans:color + carattrans:cut + carattrans:clarity, data=diamonds)

#Chekcing out big mod
summary(big_mod)


#Little mods for interaction terms
lil_modnocolint <- lm(pricetrans~carattrans + cut + color + clarity + carattrans:cut + carattrans:clarity, data=diamonds)
lil_modnocutint <- lm(pricetrans~carattrans + color + cut + clarity + carattrans:color + carattrans:clarity, data=diamonds)
lil_modnoclarint <- lm(pricetrans~carattrans + color + cut + clarity + carattrans:cut + carattrans:color, data=diamonds)

#little mods for regressors
lil_modnoclar<- lm(pricetrans~carattrans + color + cut, data=diamonds)

lil_modnocut<- lm(pricetrans~carattrans + color + clarity, data=diamonds)

lil_modnocol<- lm(pricetrans~carattrans + clarity + cut, data=diamonds)

lil_modnocar<- lm(pricetrans~color + clarity + cut, data=diamonds)


#removing the interaction terms in the lil mod
anova(lil_modnoclarint, big_mod)
anova(lil_modnocutint, big_mod)
anova(lil_modnocolint, big_mod)

#remoiving the regressors in the lil mod
anova(lil_modnoclar, big_mod)
anova(lil_modnocut, big_mod)
anova(lil_modnocol, big_mod)



#Here is the boxcox on the not transformed data
boxcoxdim <- boxcox(price~carat, data=diamonds)

best_lambda <- diamonds$carat[diamonds$price == max(diamonds$price)]

cat(best_lambda)

#Here are the transformations for the the price and carat variables
diamonds$pricetrans <- log(diamonds$price)

diamonds$carattrans <- log(diamonds$carat)


summary(diamonds$clarity)
summary(diamonds$carat)
summary(diamonds$cut)
summary(diamonds$color)

summary(diamonds$price)
str(diamonds)

diamonds$carat_t <- log(diamonds$carat)
diamonds$price_t <- log(diamonds$price)
summary(diamonds$carat_t)

model <- lm(price_t ~ carat_t + cut + color + clarity + carat_t:cut + carat_t:color + carat_t:clarity, data = diamonds)
summary(model)

vif(model)
X <- model.matrix(model)
cor(X[,-1])
pairs(X[,-1])

extern_s_resids <-studres(model)
qqnorm(extern_s_resids)
qqline(extern_s_resids)
plot(fitted.values(model), extern_s_resids, main = "Residuals vs. Fitted Values for Transformed Model", ylab = "Externally Studentized Residuals", xlab = "Fitted Values")

new_df1 <- data.frame(carat_t = -0.9943, cut = "Good", color = "J", clarity = "SI2")
predict(model, new_df1, interval = "prediction", level = 0.95)
# fit: 399.6743
# lower: 291.3878
# upper: 548.2026
predict(model, new_df1, interval = "confidence", level = 0.95)

new_df2 <- data.frame(carat_t = -0.6733, cut = "Very Good", color = "H", clarity = "VS2")
predict(model, new_df2, interval = "prediction", level = 0.95)
# fit: 1145.11
# lower: 834.8892
# upper: 1570.602
predict(model, new_df2, interval = "confidence", level = 0.95)

new_df3 <- data.frame(carat_t = 0.0000, cut = "Ideal", color = "F", clarity = "VVS1")
predict(model, new_df3, interval = "prediction", level = 0.95)
# fit: 6949.417
# lower: 5066.73
# upper: 9531.677
predict(model, new_df3, interval = "confidence", level = 0.95)

new_df4 <- data.frame(carat_t = 3.0180, cut = "Astor Ideal", color = "D", clarity = "FL")
predict(model, new_df4, interval = "prediction", level = 0.95)
# fit: 3973071
# lower: 2882965
# upper: 5475368
predict(model, new_df4, interval = "confidence", level = 0.95)

#Here are the boxplots 
boxplot(pricetrans ~ color, data = diamonds, 
        ylab = "y", xlab = "color", main="Color")

boxplot(pricetrans ~ cut, data = diamonds, 
        ylab = "y", xlab = "cut", main="Cut")
boxplot(pricetrans ~ clarity, data = diamonds, 
        ylab = "y", xlab = "price", main= "Clarity")



#ggplots on transformed data
library(ggplot2)

#color
ggplot(diamonds, aes(x = carattrans, y = pricetrans)) + geom_point(aes(color= color))

#cut
ggplot(diamonds, aes(x = carattrans, y = pricetrans)) + geom_point(aes(color= cut))

#clarity
ggplot(diamonds, aes(x = carattrans, y = pricetrans)) + geom_point(aes(color= clarity))


#same thing but not transformed

#color
ggplot(diamonds, aes(x = carat, y = price)) + geom_point(aes(color= color))

#cut
ggplot(diamonds, aes(x = carat, y = price)) + geom_point(aes(color= cut))

#clarity
ggplot(diamonds, aes(x = carat, y = price)) + geom_point(aes(color= clarity))


