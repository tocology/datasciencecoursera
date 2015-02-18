## Reading data from APIs
![sample_api](https://github.com/tocology/datasciencecoursera/blob/master/sample_api.JPG?raw=true)

<u><https://dev.twitter.com/rest/reference/get/blocks/blocking></u>

API를 통해 데이터를 읽어오는 방법을 알아보자.
특정한 url을 `GET()`함수를 통해 데이터를 구할 수 있는데, httr package를 사용하면 된다.

### Creating an application
![sample_app](https://github.com/tocology/datasciencecoursera/blob/master/sample_app.JPG?raw=true)

<u><https://apps.twitter.com/></u>

일단 application을 만들어 보자.
위에 그림에서 app을 쉽게 생성할 수 있다.
중요하지 않으니 설명은 pass

### Accessing Twitter from R
```r
myapp = oauth_app("twitter",
									key="yourConsumerKeyHere", secret="yourConsumerSecretHere")
sig = sign_oauth1.0(myapp, 
								token = "yourTokenHere",
								token_secret="yourTokenSecretHere")
homeTL = GET("https://api.twitter.com/1.1/statuses/home_timeline.json", sig)
```
`oauth_app()`함수는 해당 application에 인증 프로세스를 시작하는 것이다. 첫번째 인자로 해당 application의 이름을 정하는 것인데, 편리를 위해 여기서는 "twitter"로 하였다. 두번째와 세번째 모두 사전에 얻은 Consumer Key와 Secret이다. 다음 `sign_oauth1.0()`함수는 token을 이용하여 sign in을 한다. 마지막으로 해당 application이 제공하는 api의 url구조를 맞춰 `GET()`함수를 호출한다.

### Converting the json object
```r
json1 = content(homeTL)
json2 = jsonlite::fromJSON(toJSON(json1))
json2[1,1:4]
```
JSON 데이터를 뽑기위해 `content()`함수를 이용한다. 정렬된 R Object 목록을 돌려준다. `jsonlite()`를 이용하여 해당 내용을 reformat해준다.

### How did I know what url to use?
 
 <u><https://dev.twitter.com/docs/api/1.1/get/search/tweets></u> 로 들어가 document를 확인해보자.
GET url 등 확인할 수 있다.

### In general look at the documentation
* httr allows `GET`, `POST`, `PUT`, `DELETE` requests if you are authorized
* You can authenticate with a user name or a password
* Most modern APIs use something like oauth
* httr works well with Facebook, Google, Twitter, Github, etc.
