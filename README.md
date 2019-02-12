# MemberSample

## Synopsis

This is a sample iOS app, written in swift, that demonstrates core-data syncing with a remote database and server api. It demonstrates how one might load a JSON response directly into instances of NSManagedObject (and it's subclasses). This sync is done in the background with a private NSManagedObjectContext. Duplicate object issues are avoided through DispatchQueues serialization.

There are a few protocols that provide the backend magic to the sync mechanism...

[Fetchable](https://github.com/jjamminjim/MemberSample/blob/master/MemberSample/Data%20Sync/Fetchable.swift)  : a Utility protocol for custom NSManagedObjects context querying. Inspired by [this intial work here.](https://gist.github.com/capttaco/adb38e0d37fbaf9c004e)

[FetchableDecodable](https://github.com/jjamminjim/MemberSample/blob/master/MemberSample/Data%20Sync/FetchableDecodable.swift) : decodes JSON data directly into NSManagedObject instances. Existing objects are first queried from the data-store, and if not present, the object is created. The object is then updated with the JSON data. Duplicate objects created on multiple threads are avoided by synchronizing through a DispatchQueue supplied by a [DispatchQueueDictionary](https://github.com/jjamminjim/MemberSample/blob/master/MemberSample/Utilities/DispatchQueueDictionary.swift) keyed by NSManagedObject class names.  This is inspired by the article [Codable CoreData.](http://ffried.codes/2017/10/20/codable-coredata/).

[Syncable](https://https://github.com/jjamminjim/MemberSample/blob/master/MemberSample/Data%20Sync/Syncable.swift)  :  provides a simple syncing ability between backing-server and local core-data store. Note that the implementation is quick and dirty, simply supporting the requirements for this coding sample. It gives a good starting point to develop your own syncing mechanism.

You can extend your own NSManagedObjects to use this mechanism by extending your subclasses in terms of the above protocols. If the default implementations are sufficient for your needs you simply need to implement the following method of the **FetchableDecodable** protocol...

```
func update(with json: [String: Any], in context: NSManagedObjectContext) throws -> Self
```

For an example see [Member+Syncable.swift.](https://github.com/jjamminjim/MemberSample/blob/master/MemberSample/Data%20Sync/Member%2BSyncable.swift). 

## Installation
This iOS app requires Cocoapods to be installed before the project can be built and ran. 

If you have not installed Cocoapods previously please follow the instructions [here](https://guides.cocoapods.org/using/getting-started.html).

Once Cocoapods is installed...

* Clone this repository to your Macintosh computer.
* Run `$ pod install` in your project directory.
* Open MemberSample.xcworkspace and build.


## Acknowledments

The following third party libraries where used in this project ...

[AlamoFire](https://github.com/Alamofire/Alamofire) : Used to retrieve JSON date from a sample server api call.

[AlamofireImage](https://github.com/Alamofire/AlamofireImage) : Used to retrieve cloud based images via url.

[DBC](https://github.com/busybusy/DBC-Apple) : [Eiffle like Design by Contract Assertions](http://www.eiffel.com/developers/design_by_contract_in_detail.html) for swift.

