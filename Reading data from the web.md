## Reading data from the web
![google_scholar](https://github.com/tocology/datasciencecoursera/blob/master/google_scholar.JPG?raw=true)

<u><https://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en></u>

web으로 부터 데이터를 얻어오는 API를 알아보자.

### Webscraping
**Webscraping**: Progamatically extracting data from the HTML code of websites.

* It can be a great way to get data 
<u>[How Netflix reverse engineered Hollywood](http://www.theatlantic.com/technology/archive/2014/01/how-netflix-reverse-engineered-hollywood/282679/)</u>
* Many websites have information you may want to progamaticaly read
* In some cases this is against the terms of service for the website
* Attempting to read too many pages too quickly can get your IP address blocked

<u><http://en.wikipedia.org/wiki/Web_scraping></u>

### Getting data off webpages - readLines()
```r
con = url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode = readLines(con)
close(con)
htmlCode
```
`url()`함수를 통해 해당 url주소로 접속(open connection) 후, `readLines()`함수를 이용해 해당 connection으로 부터 데이터를 읽어온다. (한 줄의 긴 string값이 담겨진다.)

※ 다른 database와 마찬가지로 `close()`함수를 잊지않는다.

`readLines()`에 일정한 수를 넘겨 읽어오는 줄의 수를 조절할 수 있다. 여튼 아직은 읽기에는 다소 무리가 있다.

### Parsing with XML
```r
library(XML)
url <- "http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
html <- htmlTreeParse(url, useInternalNodes=T)
xpathSApply(html, "//title", xmlValue)
```
```r
[1] "Jeff Leek - Goole Scholar Citations"
```
```r
xpathSApply(html, "//td[@id='col-citedby']", xmlValue)
```
이전에 살펴봤던 XML 라이브러리를 이용한다.

## Get from the httr package
```r
library(httr); html2 = GET(url)
content2 = content(html2, as="text")
parsedHTML = htmlParse(content2,asText=TRUE)
xpathSApply(parsedHtml, "//title", xmlValue)
```
```r
[1] "Jeff Leek - Google Scholar Citations"
```
web에서 데이터를 얻어오는 다른 방식으로는 httr package를 이용한 `GET()`함수가 있다. `content()`함수를 통해 해당 페이지의 내용을 text방식(긴 string)으로 저장한다. 이후 `htmlParse()`함수를 통해 해당 text를 파싱한다. 이렇게 하면 위에서 살펴봤던 XML package를 이용한 방식과 동일한 데이터를 얻을 수 있다.

### Accessing websites with passwords
때로는 조금 더 복잡한 일이 필요할 지도 모른다.
```r
pg1 = GET("http://httpbin.org/basic-auth/user/passwd")
pg1
```
```r
Response [http://httpbin.org/basic-auth/user/passwd]
  Status: 401
  Content-type:

```
<u><http://cran.r-project.org/web/packages/httr/httr.pdf></u>

위와 같이 username과 password가 필요한 경우가 있을 수 있다.

이런 경우 `authenticate()`리턴 결과를 이용하여 접근 할 수 있다.

```r
pg2 = GET("http://httpbin.org/basic-auth/user/passwd",
	authenticate("user","passwd"))
pg2
```
```r
Response [http://httpbin.org/basic-auth/user/passwd]
  Status: 200
  Content-type: application/json
{
  "authenticated": true,
  "user": "user"
}
```
```r
names(pg2)
```
실제 로그인한 결과와 동일한 결과를 얻을 수 있다.

### Using handles
```r
google = handle("http://google.com")
pg1 = GET(handle=google,path="/")
pg2 = GET(handle=google,path="search")
```
<u><http://cran.r-project.org/web/packages/httr/httr.pdf></u>
`handle()`함수를 사용하면, 접속 정보를 여러 website에 적용할 수 있다.

### Notes and further resources
* R Bloggers has a number of examples of web scraping <u><http://www.r-bloggers.com/?s=Web+Scraping></u>
* The httr help file has useful examples <u><http://cran.r-project.org/web/packages/httr/httr.pdf></u>
* See later lectures on APIs
