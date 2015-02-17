## Reading from HDF5
`HDF5`는 익숙한 데이터 타입은 아니니 한번 집고 넘어가자
##HDF5
* Used for storing large data sets
* Supports storing a range of data types
* Heirarchical data format
* groups containing zero or more data sets and metadata
    - Have a group header with group name and list of attributes
    - have a group symbol table with a list of objects in group
* datasets multidemensional array of data elements with emtadata
 - Hava a header with name, datatype, dataspace, and storage layout
 - Have a data array with the data

<u><http://www.hdfgroup.org/></u>


### RHDF5 package
RHDF5는 bioconductor로부터 설치할 수 있다.
`bioLite()`를 통해 RHDF5 package를 로드한다.
```r
source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")
```
```r
library(rhdf5)
created = h5createFile("example.h5")
created
```
```r
[1] TRUE
```

### Create groups
```r
created = h5createGroup("example.h5","foo")
created = h5createGroup("example.h5","baa")
created = h5createGroup("example.h5","foo/foobaa")
h5ls("example.h5")
```
위에서 만든 HDF5파일은 하나의 group으로 내부에 여러 `H5I_GROUP`을 동시에 생성할 수 있다. 처음 설명된 것과 같이 계층 구조로 되어있다.


### Write to groups
```r
A = matrix(1:10,nr=5,nc=2)
h5write(A,"example.h5","foo/A")
B = array(seq(0.1,2.0,by=0.1),dim=(5,2,2))
attr(b, "scale") <- "liter"
h5write(B, "example.h5","foo/foobaa/B")
h5ls("example.h5")
```
이 경우 A, B는 `H5I_DATASET`으로 추가된다. (dclass, dim 정보도 함께 추가된다.)


### Write a data set
```r
df = data.frame(1L:5L, seq(0,1,length.out=5),
	c("ab","cde","fghi","a","s"), stringAsFactors=FALSE)
h5write(df, "example.h5","df")
h5ls("example.h5")
```

이 경우 dclass가 `COMPOUND`로 저장된다.

### Reading data
```r
readA = h5read("example.h5","foo/A")
readB = h5read("example.h5","foo/foobaa/B")
readdf= h5read("example.h5","df")
readA
```

### Writing and reading chunks
```r
h5write(c(12,13,14),"example.h5","foo/A",index=list(1:3,1))
h5read("example.h5","foo/A")
```
기존에 저장되어있는 데이터에 값을 덮어쓴다. index는 list형태로 첫번째 값은 row의 자리, 두번째 값은 col의 자리를 나타낸다.

### Notes and further resources
* hdf5 can be used to optimize reading/writing from disc in R
* The rhdf5 tutorial:
 * <u><http://www.bioconductor.org/packages/release/bioc/vignettes/rhdf5/inst/doc/rhdf5.pdf></u>
* The HDF group has information on HDF5 in general <u><http://www.hdfgroup.org/HDF5/></u>