# Data Science - Machine Learning - Quiz 4

# Problem 1 --------------------------------------------------------------------

library(ElemStatLearn)
library(caret)

data(vowel.train)
data(vowel.test)

vowel.train$y <- factor(vowel.train$y)
vowel.test$y <- factor(vowel.test$y)

# Fit models and Predict
set.seed(33833)
modfit.rf <- train(y ~ ., data=vowel.train, method="rf")
modfit.gbm <- train(y ~ ., data=vowel.train, method="gbm")
pred.rf <- predict(modfit.rf, vowel.test)
pred.gbm <- predict(modfit.gbm, vowel.test)

# Random Forest Accuracy
confusionMatrix(pred.rf, vowel.test$y)

# Boosting Accuracy
confusionMatrix(pred.gbm, vowel.test$y)

# Agreement Accuracy
agreement <- which(pred.rf == pred.gbm)
agr.conf.table <- table(pred.rf[agreement], vowel.test[agreement, 1])
agr.accuracy <- sum(diag(agr.conf.table))/sum(agr.conf.table)
agr.accuracy

# Answers: RF Accuracy = 0.6082, GBM Accuracy = 0.5152, Agreement Accuracy = 0.6361


# Problem 2 --------------------------------------------------------------------

library(caret)
library(gbm)
library(AppliedPredictiveModeling)

data(AlzheimerDisease)

# Get training and testing sets
set.seed(3433)
adData <- data.frame(diagnosis, predictors)
inTrain <- createDataPartition(adData$diagnosis, p=0.75)[[1]]
training <- adData[inTrain, ]
testing <- adData[-inTrain, ]

# Fit models and predict
set.seed(62433)
modfit2.rf <- train(diagnosis ~ ., data=training, method="rf")
modfit2.gbm <- train(diagnosis ~ ., data=training, method="gbm")
modfit2.lda <- train(diagnosis ~ ., data=training, method="lda")
pred2.rf <- predict(modfit2.rf, testing)
pred2.gbm <- predict(modfit2.gbm, testing)
pred2.lda <- predict(modfit2.lda, testing)

# Create ensemble model using random forest
pred2.DF <- data.frame(pred2.rf, pred2.gbm, pred2.lda, testing$diagnosis)
combModFit2.rf <- train(testing.diagnosis ~ ., data=pred2.DF, method="rf")
combPred2.rf <- predict(combModFit2.rf, pred2.DF)

# Random Forest Accuracy
confusionMatrix(pred2.rf, testing$diagnosis)$overall[1]

# Boosting Accuracy
confusionMatrix(pred2.gbm, testing$diagnosis)$overall[1]

# LDA accuracy
confusionMatrix(pred2.lda, testing$diagnosis)$overall[1]

# Ensemble Model Accuracy
confusionMatrix(combPred2.rf, testing$diagnosis)$overall[1]

# Answer: Accuracy is 0.80 nad is same as Boosting but better than LDA and RF


# Problem 3 --------------------------------------------------------------------

library(AppliedPredictiveModeling)
library(caret)
library(elasticnet)

data(concrete)

set.seed(3523)
inTrain <- createDataPartition(concrete$CompressiveStrength, p=0.75)[[1]]
training <- concrete[inTrain, ]
testing <- concrete[-inTrain, ]

# Fit Lasso model
set.seed(233)
modfit3.lasso <- train(CompressiveStrength ~ ., data=concrete, method="lasso")

# Plot the variables
plot.enet(modfit3.lasso$finalModel, xvar = "penalty", use.color = TRUE)

# Answers: Cement


# Problem 4 --------------------------------------------------------------------

library(lubridate) # For year() function below
library(forecast)

dat <- read.csv("C:/Users/mdancho/Downloads/gaData.csv")

training = dat[year(dat$date) < 2012,]
testing = dat[(year(dat$date)) > 2011,]
tstrain = ts(training$visitsTumblr)

# Fit model using bats()
mod_ts <- bats(tstrain)

# Forecast
fcast <- forecast(mod_ts, level = 95, h = dim(testing)[1])

# Accuracy within 95% prediction bounds
accuracy(fcast, testing$visitsTumblr)
above.forecast <- length(testing$visitsTumblr[testing$visitsTumblr > fcast$upper])
below.forecast <- length(testing$visitsTumblr[testing$visitsTumblr < fcast$lower])
total.forecast <- length(testing$visitsTumblr)
(total.forecast - above.forecast - below.forecast) / total.forecast

# Answer: 96%


# Problem 5 --------------------------------------------------------------------

library(AppliedPredictiveModeling)
library(e1071)

data(concrete)

set.seed(3523)
inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training = concrete[ inTrain,]
testing = concrete[-inTrain,]

set.seed(325)
mod.svm <- svm(CompressiveStrength ~ ., data = training)
pred.svm <- predict(mod.svm, testing)
accuracy(pred.svm, testing$CompressiveStrength)

# Answer: RMSE = 6.72
