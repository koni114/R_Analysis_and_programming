## 로지스틱 회귀 분석

a         <- iris %>% filter(Species == 'setosa' | Species == 'versicolor')
a$Species <- as.factor(a$Species)
b         <- glm(Species ~ Sepal.Length, data = a, family = binomial)
summary(b)

# 회귀계수 검정에서 p-값이 거의 0 이므로, Sepal.Length가 매우 유의한 변수이며,
# Sepal.Length가 한 단위 증가함에 따라 Versicolor일 오즈가 exp(5.140) := 170배 증가함을 알 수 있음

# Residual deviance는 예측변수 Sepal.Length가 추가된 적합 모형의 이탈도를 나타냄
# Null deviance에 비해 자유도 1 기준에 이탈도의 감소가 74.4 정도의 큰 감소를 보이며, 
# 귀무가설이 기각되지 않으며 적합값이 관측된 자료를 잘 적합하고 있다고 말할 수 있음 

# 로지스틱 회귀 계수
coef(b)

# 오즈의 증가량 exp(B)
exp(coef(b)["Sepal.Length"])

# 회귀계수 beta와 오즈의 증가량 exp(B)에 대한 신뢰구간
confint(b, parm = "Sepal.Length")
exp(confint(b, parm = "Sepal.Length"))

# fitted() 함수를 통해 적합 결과 확인
fitted(b)[c(1:5, 96:100)]
predict(b, newdata = a[c(1, 50, 51, 100), ], type = "response")

# 적합된 로지스틱 회귀 모형의 그래프
plot(a$Sepal.Length, a$Species, xlab = "Sepal.Length")
x = seq(min(a$Sepal.Length), max(a$Sepal.Length), 0.1)
lines(x, 1+(1/(1+(1/exp(-27.831 +5.140*x)))), col = "red")



