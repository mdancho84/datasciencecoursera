## The functions create an inverse of a matrix using a caching method in order
## to avoid performing computations that are intensive multiple times. To 
## accomplish, a caching method performs the inverse once and then uses
## the cached inverted matrix for future calls.

## makeCacheMatrix creates a list of four functions that:
## 1. set the value of the matrix
## 2. get the value of the matrix
## 3. set the value of inverse of the matrix
## 4. get the value of inverse of the matrix

makeCacheMatrix <- function(x = matrix()) {
        inv <- NULL
        set <- function(y) {
                x <<- y
                inv <<- NULL
        }
        get <- function() x
        setinv <- function(solve) inv <<- solve
        getinv <- function() inv
        list(set = set, get = get,
             setinv = setinv,
             getinv = getinv)
}


## Computes the inverse of the cached matrix one time. If the inverse exists, 
## the inverse is pulled from memory rather than performing again.

cacheSolve <- function(x, ...) {
        inv <- x$getinv()
        if(!is.null(inv)) {
                message("getting cached data")
                return(inv)
        }
        data <- x$get()
        inv <- solve(data, ...)
        x$setinv(inv)
        inv
}
