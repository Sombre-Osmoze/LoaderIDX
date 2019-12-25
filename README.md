# LoaderIDX

## A Swift package to load `IDX` files.

This package is now used for loading training files of [THE MNIST DATABASE](http://yann.lecun.com/exdb/mnist/)


The testing data are take from [here](http://yann.lecun.com/exdb/mnist/)

### Usage

First include the package in your **Swift** package, then  import  `IDX`  in the files where you want to use it.
```Swift
import IDX
```

To load a IDX file, juste create a `IDX` object,
```Swift
let file = try Data(contentsOf: <#T##URL#>)
	
let dataset = try IDX(file)
```
The initializer will parse the file and extract data information from it, then will verify the data length.


To get the number of data check the `count` property.

To access a vector, matrice or image data use the subscript.
```Swift
// Access the first image in the data set 
let image = dataset[0]
```

> If you ever want to get the file raw data use the `data` property


### Contribution

If you find a bug or would like a particuliar feature open a isssue.
Pull request are more than accepted.


### License

You can use the project for commercial purposes, but you're not allowed to sell it as is.
I will not be responsible for any of your usage of this package.
