##The following code helps to reap benefits of caching time consuming computations
##Matrix inversion is usually a costly computation and there may be some benefit to caching
##the inverse of a matrix rather than compute it repeatedly.Here we will 
##take advantage of the scoping rules of the R language and how they can be manipulated to preserve state inside of an R object.

#The following functions can compute and cache the inverse of a matrix.
#makeCacheMatrix(): creates a special “matrix” object that can cache its inverse.
#cacheSolve(): computes the inverse of the “matrix” returned by makeCacheMatrix().If the inverse has already been calculated and 
#the matrix has not changed, it’ll retrieves the inverse from the cache directly.

## Write a short comment describing this function

makeCacheMatrix <- function(x = matrix()) {
## @x: a square invertible matrix
        ## return: a list containing functions to
        ##              1. set the matrix
        ##              2. get the matrix
        ##              3. set the inverse
        ##              4. get the inverse
        ##         this list is used as the input to cacheSolve()
inv = NULL
set = function(y) {
 # use `<<-` to assign a value to an object in an environment 
                # different from the current environment. 
x <<- y
inv <<- NULL
}
get = function() x
setinv = function(inverse) inv <<- inverse 
getinv = function() inv
list(set=set, get=get, setinv=setinv, getinv=getinv)
}
cacheSolve <- function(x, ...) {
## @x: output of makeCacheMatrix()
## return: inverse of the original matrix input to makeCacheMatrix()

inv = x$getinv()
# if the inverse has already been calculated
if (!is.null(inv)){
 # get it from the cache and skips the computation.otherwise, calculates the inverse 
message("getting cached data")
return(inv)
}
mat.data = x$get()
        inv = solve(mat.data, ...)
        
        # sets the value of the inverse in the cache via the setinv function.
        x$setinv(inv)
        
        return(inv)
}