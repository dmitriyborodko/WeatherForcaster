# WeatherForcaster

As we didn't have any restrictions about the version number - I've implemented brand new collectionn layout. If we had to support iOS 12 - we would have used UICollectionView with cells containing inner UICollectionViews. Maybe it could be done with UICollectionFlowLayout, but my experience says that it is a bad idea to use such complicated layout because of performance issues.

I didn't cover my code with tests, but everything in `Services` and `Utils` folders is testable and easy to mock and cover.

You may notice that I have 3 "layers" of Weather model:
* DTO - it is segregated to support codegen firstly, and also I like to segregate server and local models.
* Local models, it's just a handy way to store and manage those models
* View Models. Local models devided by days and converted to what we will actually use in views.

