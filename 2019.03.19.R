# file을 zip으로 만들어주는 함수
# skill
# 1. list.files를 이용하여 해당 directory의 file list 저장
# 2. zip::zip()를 이용하여 zip 
# 3. 필요하다면 file.remove() 를 이용하여 zip 된 file을 삭제

install.packages("zip")
require(zip)
zip_files <- list.files(path = "./", pattern = ".R")
zip::zip(zipfile = "Zip_files", files = zip_files)
# file.remove(paste0(zip_files))

# ggplot 살짝 정리 
#' 내가 왜 헤멨는가? 
#' ggplot이 RSERVER에 저장되는 원리를 이해하지 못함
#' 1. png(filename, width, height)
#' 2. ggplot 생성 
#' 3. print(g) 생성된 plot 객체를 print를 통해서 화면에 출력 -> 내 생각에는, png 함수가 화면에 출력된 함수를 가져가는 듯
#' 4. def.off() : 화면 닫기

# 회귀 분석 : LASSO, RIDGE, elasticnet ->  cv.glmnet 함수 사용하고, alpha -> 1, 0.5, 0 값에 따라서 달라짐

# 회귀 분석
# OLS 회귀의 가정 고려
# 1. 정규성:  종속 변수의 정규성 가정이 성립해야 함
# 2. 독립성:  종속 변수의 독립성 가정이 성립해야 함
# - 종속변수의 독립성을 평가하는 가장 좋은 지표는 자료를 수집한 방법으로부터 독립적인지
# 평가하는 것
# - Durbin-Watson 검정을 통한 독립성 검정 -> p-value < 0.05 : 독립성 가정 기각 
# 
# 3. 선형성:  종속 변수와 독립 변수의 선형성이 성립하려면, 잔차와 예측 변수간의
# 특정 형태가 띄면 안된다 . ex) 2차 함수
# - component plus residual plot(partial residual plot) 사용
# -> 선형을 띄지 않으면 선형성 위배 -> 다항회귀를 이용해야 함. log, ^2 형태
# 
# 4. 등분산성: fitted value에 대한 등분산성이 가정되어야 한다.
# - ncvTest() : p-value < 0.05 : 등분산성 위배
# - spreadLevelPlot() : nonhorizontal 하다면, 등분산성 위배
# Suggested power transformation : 적절한 람다 값 제공
# 
# ** library(gvlma)
# gvmodel <- gvlma(fit)
# summary(gvmodel) 를 이용해서 전반적인 검증을 한꺼번에 할 수 있음
# 
# 5. outlier
# -  car::outlierTest()
# 
# '6 high leverage point : 예측 변수(fitted value)의 관측치. -> 이상치가 있는지 확인
# 일반적으로 평균치의 2배 3배의 선을 계산하여 확인
# - 
# 
# 7. influential observation: 영향 관측치 -> 회귀 모형 계수에 영향을 미치는 값을 확인 시켜 줌
# 8. 다중 공선성(multicolinearity)
# - 독립 변수들 간의 강한 상관 관계가 나타나는 것을 의미
# - VIF ^2 > 4 이면 다중공선성이 있다고 판단
# - 통계모형 계수들에 대한 신뢰구간이 커짐. : why ? 
# 
# ** 회귀 변수의 교정 방법
# 1. 관측치 제거
# - 이상치나 영향 관측치를 계속 제거해 가면서 모형 적합을 수행
# - 관측치 제거시 매우 주의 : 이상치나 영향 관측치는 큰 정보를 제공해 줄 수 있기 때문
# 2. 변수의 변환
# - lambda transformation
# - boxTidwell() : 예측 변수의 가장 적합한 람다 값 제공
# -> p-value <- 0.05 변환하는 것이 유의함
# - spreadLevelPlot() : 등분산성 개선을 위한 자료의 변환 제시
# 
# 3. 변수의 추가 또는 제거
# - 다중공선성의 변수 하나를 제거 -> 해석에 도움 
# 
# 4. 다른 회귀 방법의 사용
# - 다중공선성 문제    -> 능형 회귀 사용
# - 이상치, 영향관측치 -> robust regression
# - 정규성 가정 위배   -> 비모수회귀모형
# - 선형성 문제          -> 비선형회귀모형  
# - 독립성 가정 위반   -> 시계열 모형, 다수준 회귀모형
# - 일반화선형모형 사용
# 
# **  "최선의" 회귀모형 고르기
# 1. 모형 선택 시 anova 분석을 통해 두 모형의 차이가 유의한지를 확인
# -> 유의하지 않으면, 변수를 제거한 모형을 선택해도 무방하다는 의미!
# anova(fit1, fit2)
# 
# 2. adjusted R^2 : 실제로 단순 R^2 를 선택하게 되면 예측 변수의 개수가
# 증가 할 수록 무조건 값이 증가하므로,  adjusted R^2 를 보면서 적절한
# 예측 변수 조합을 판단해 내자
# 
# 3. AIC 이용
# - AIC가 작을수록, 적합한 모형 판단 가능(AIC=???2logL+2K(전체 모수의 수)
# - stepwise regression 을 통해 자동으로 변수를 찾게 할 수 있음(AIC가 가장 작고, 더이상 작아지지 않는 순간까지)
# -> but 완전 모든 경우의 수의 최적의 모형을 찾아 주지는 않는다.
# - 모든 부분집합 회귀(all subset regression) : 가능한 모든 모형 조사
# 부분 집합 크기를 지정해줘서 최적의 모형을 판단할 수도 있음
# - leaps::regsubsets() 이용 -> R2, adjusted R2(R2a), 또는 Mallows Cp statistic 중 선택
