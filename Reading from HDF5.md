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
RHDF5는 bioconductor에 의해 설치가 되어있다.

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
