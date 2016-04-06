//Run Some Image Helper Methods for testing
let productImageURLString = "https://example.com/testimage.jpg"

//get some Image frum URL
ImageHelper.sharedLoader.getImageFromURL(productImageURLString, completionHandler: {
    (completeImage :UIImage?, imageUrlString: String) -> Void in
    if let image = completeImage {
        let filename = NSString(string: productImageURLString).lastPathComponent
        //Display the Image in some Image view so save it
		
        //Save Image
        //ImageHelper.sharedLoader.setImageWithName(filename, image: image, completionHandler: {
        //    (imageUrlString: String) -> Void in
        //    print ("Image saved \(image.debugDescription)")
        })
    }
})

//Save Image
ImageHelper.sharedLoader.setImageWithName(filename, image: image, completionHandler: {
    (imageUrlString: String) -> Void in
	//called after Image is saved. The imageUrlString can be used to store Information about all saved Images. 
})

//load some local Image
ImageHelper.sharedLoader.getImageWithFilename("testimage.jpg") { 
	(completeImage, filename) in
    //Display the Image in some Image view
	//print ("Image loaded \(completeImage.debugDescription)")
}