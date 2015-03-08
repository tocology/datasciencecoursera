# Creating new variables

데이터를 `R`에 불러오더라도 찾고자하는 변수가 없을 수 있다.  따라서, 원하는 값을 얻기 위해 데이터를 변환할 필요가 있다.

### Why create new variables?
* Often the raw data won't have a value you are looking for
* You will need to transform the data to get the values you would like
* Usually you will add those values to the data frames you are working with
* Common variables to create
 - Missingness indicators
 - "Cutting up" quantitative variables
 - Applying transforms

### Example data set
![Example](https://github.com/tocology/tocology.github.io/blob/master/screenshot/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202015-02-22%20%EC%98%A4%ED%9B%84%208.58.32.png?raw=true)
<u><https://data.baltimorecity.gov/Community/Restaurants/k5ry-ef3g></u>

### Getting the data from the web
```r
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl,destfile="./data/restaurants.csv",method="curl")
restData <- read.csv("./data/restaurants.csv")
```
이전과 동일하게 데이터를 다운받는다.

### Creating sequences
데이터를 분석하기전 먼저 시퀀스를 다루는 법을 알아보자. 시퀀스는 때때로 데이터의 접근할 때 index로 사용된다.

```r
s1 <- seq(1,10,by=2); s1
s2 <- seq(1,10,length=3); s2
x <- c(1,3,8,25,100); seq(along = x)
```
예제 중 마지막과 같이 데이터셋이 있을때 `seq(along=x)`을 이용하면 `x`와 동일한 길이의 시퀀스가 만들어진다. 이 경우 해당 데이터셋의 index로 사용될 수 있다.

### Subsetting variables
```r
restData$nearMe = restData$neighborhood %in% c("Roland Park", "Homeland")
table(restData$nearMe)
```
다른 변수로 부터 Subsetting을 구할 수 있다. 위의 예는 조건을 이용해서 구해진 vector가 데이터셋에 추가된다.


### Creating binary variables
```r
restData$zipWrong = ifelse(restData$zipCode <0, TRUE, FALSE)
table(restData$zipWrong, restData$zipCode <0)
```
binary 변수를 생성하는 것도 어렵지 않다. (binary가 boolean을 의미하는지는 모르겠다.)

### Creating categorical variables
```r
restData$zipGroups = cut(restData$zipCode,breaks=quantile(restData$zipCode))
table(restData$zipGroups)
table(restData$zipGroups, restData$zipCode)
```
quantitative 변수로 categorical 값을 얻고 싶을 경우, `cut()`을 이용하면 된다.  `breaks`매개변수로 분류하게 된다.

### Easier cutting
```r
library(Hmsic)
restData$zipGroups = cut2(restData$zipCode,g=4)
table(restData$zipGroups)
```
`Hmisc` 패키지를 로드하여 `cut2()`함수로 쉽게 분류할 수 있다. `g`매개변수로 group의 수를 정의할 수 있다.

### Creating factor variables
```r
restData$zcf <- factor(restData$zipCode)
restData$zcf[1:10]
class(restData$zcf)
```
`factor()`를 이용해 factor변수를 만들 수 있다. 

### Levels of factor variables
```r
yesno <- sample(c("yes","no"),size=10,replace=TRUE)
yesnofac = factor(yesno, levels=c("yes","no"))
relevel(yesnofac,ref="yes")
as.numeric(yesnofac)
```
`yesno`의 경우 chr타입 vector로 생성된다. 따라서 `factor()`을 통해 factor변수로 변환하며, 이때 `levels`를 통해 factor level을 정의한다.  `relevel()`을 이용하면 해당 factor 변수의 level을 재정의할 수 있는데, `ref` 매개변수가 우선으로 바뀐다. 예제의 경우는 동일한 결과를 보이지만, `ref="no"`와 같이 매개변수를 넘겨줬다면 level 순서가 바뀌게 된다.

### Cutting produces factor variables
```r
library(Hmisc)
restData$zipGroups = cut2(restData$zipCode,g=4)
table(restData$zipGroups)
```
방금 cut예제와 동일하다.

### Using the mutate function
```r
library(Hmisc); library(plyr)
restData2 = mutate(restData,zipGroups=cut2(zipCode,g=4))
table(restData2$zipGroups)
```
`mutate()`를 이용하여 새로운 version의 데이터셋을 만들 수 있다.  첫 번째 매개변수로 변경할 데이터셋을 넘겨주며, 다음으로 새로운 변수를 정의하면 된다. 

### Common transforms
* `abs(x)`  abolute value
* `sqrt(x)` square root
* `ceiling(x)` ceiling(3.475) is 4
* `floor(x)` floor(3.475) is 3
* `round(x,digits=n)` round(3.475,digits=2) is 3.48
* `signif(x,digits=n)` signif(3.475,digits=2) is 3.5
* `cos(x), sin(x)` etc.
* `log(x)` natural logarithm
* `log2(x), log10(x)` other common logs
* `exp(x)` exponentiation x

<u><http://www.biostat.jhsph.ecu/~ajaffe/lec_winterR/Lecture%202.pdf></u>
<u><http://statmethods.net/management/functions.html></u>

### Notes and further reading
* A tutorial from the developer of plyr - <u><http://plyr.had.co.nz/09-user/></u>
* Andrew Jaffe's R notes <u><http://www.biostat.jhsph.edu/~ajaffe/lec_winterR/Lecture%202.pdf></u>


# Reshaping data
`R`에 로드해오는 데이터가 필수적으로 정돈되어 있지는 않다. 따라서, 데이터를 원하는 방향으로 재정돈해야한다.

### The goal is tidy data
1. Each variable forms a column
2. Each  observation forms a row
3. Each table/file stores data about one kind of observation (e.g. people/hostpitals).

### Start with reshaping
```r
library(reshape2)
head(mtcars)
```
`R` 표준 데이터인 mtcars를 이용하자.

### Melting data frames
```r
mtcars$carname <- rownames(mtcars)
carMelt <- melt(mtcars,id=c("carname","gear","cyl"),measure.vars=c("mpg","hp"))
head(carMelt,n=3)
tail(carMelt,n=3)
```
`melt()`함수를 이용해서 데이터셋을 녹인다(melt)(?). `id`를 통해 id변수를 정의하고, `measure.vars`를 통해 measurable 변수를 정의한다. 
이럴 경우 melt된 데이터 셋의 measure변수가 생기면서 데이터셋의 row 수가 두배로 증가한다. 한마디로 데이터셋이 길어지며 얇아진다고 볼 수 있다.

### Casting data frames
```r
cylData <- dcast(carMelt, cyl ~ variable)
cylData <- dcast(carMelt, cyl ~ variable, mean)
```

melt한 후 다른 포멧으로 다시 케스팅할 수 있다. 이때 `dcast()`함수를 사용하면 되고, `~` 왼쪽에 오른쪽 변수로 분류하여 보고자 하는 column을 넣으면 된다. 이때 오른쪽 변수는 사전에 melt할 때 measure값으로 지정했던 변수여야 한다. 위의 예의 경우 cyl에 따른 measure값의 수가 나온다. 3번째에 각 measure값에 적용할 함수를 지정할 수도 있다.

### Averaging values
특정한 factor에 대한 평균값을 구해보자.
```r
tapply(InsectSpray$count, InsectSpray$spray,sum)
```
`tapply()`를 이용해서 구할 수 있다. 첫 번째는 vector값, 두 번째는 Index, 세 번째는 index된 vector에 적용할 함수이다.

### Another way - split
```r
spIns = split(InsectSprays$count, InsectSprays$spray)
```
`split()`을 이용하면 두 번째 index 매개변수에 따라 첫 번째 값을 분류하여 나눈다. 리턴 타입은 list이다.

### Another way - apply
```r
sprCount = lapply(spIns, sum)
```
`split()`을 통해 구해진 리스트를 `lapply()`를 이용해서 리스트 내 vector값의 합을 구할 수 있다.

### Another way - combine
```r
unlist(sprCount)
sapply(spIns,sum)
```
`unlist()`를 하면, 해당 list를 vector로 변환한다. `lapply()`대신 `sapply()`를 이용했다면, 결과는 단일값으로만 이루어진 경우 vector를 돌려주며, 아닐 경우 matrix를 돌려 준다.

### Another way - plyr package
```r
ddply(InsectSpray,.(spray),summarize,sum=sum(count))
```
`plyr` 패키지내 `ddply()`함수를 이용하는 방법도 있다. 

### Creating a new variable
```r
spraySums <- ddply(InsectSprays,.(spray),summarize,sum=ave(count,FUN=sum))
```
`ave()`와 함께쓰는 방법도 적용 가능하다.

### Moree information
* A tutorial from the developer of plyr - <u><http://plyr.had.co.nz/09-user/></u>
* A nicee reshape tutorial <u><http://www.slideshare.net/jeffreybreen/reshaping-data-in-r></u>
* A good plyr primer - <u><http://www.r-bloggers.com/a-quick-primer-on-split-apply-combine-problems/></u>
* See also the functions
	- acast - for casting as multi-dimensional arrays
	- arrange - for faster reordering without using order() commands
	- mutate - adding new variables.

# Managing Data Frames with dplyr

### dplyr Verbs
> `select`: return a subset of the columns of a data frame
> `filter`: extrract a subset of rows from a data frame based on logical conditions
> `arrange`: reorder rows of a data frame
> `rename`: rename variables in a data frame
> `mutate`: add new variables/columns or transform existing variables
> `summarise` / `summarize`: generate summary statistics of different variables in the data frame, possibly within strata

There is also a handy print method that prevents you from printing a lot of data to the console.

### dplyr Properties
>* The first argument is a data frame.
>* The subsequent arguments describe what to do with it, and you can refer to columns in the data frame directly without using the $ operator (just use the names).
>* The result is **a new data frame**
>* Data frames must be properly formatted and annotated for this to all be useful

