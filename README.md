# BDTests

[![CI Status](http://img.shields.io/travis/bytedissident/BDTests.svg?style=flat)](https://travis-ci.org/bytedissident/BDTests)
[![Version](https://img.shields.io/cocoapods/v/BDTests.svg?style=flat)](http://cocoapods.org/pods/BDTests)
[![License](https://img.shields.io/cocoapods/l/BDTests.svg?style=flat)](http://cocoapods.org/pods/BDTests)
[![Platform](https://img.shields.io/cocoapods/p/BDTests.svg?style=flat)](http://cocoapods.org/pods/BDTests)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

BDTests is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "BDTests"
```

## What is this for?
This is a framework that is intended to simplify stubbing of network requests when performing UITests for iOS projects written in Swift. The second thing BDTests takes care of is creating an interface to help set up your app for the UITest you are trying to perform. For example, if your app requires login or you need your app in a certain state. BDTests creates a way for you to easily set up your state for the system under test. 

## Set Up
In your AppDelegate you need to import BDtests and add the testEnv method to your AppDelegate.

```ruby
import BDTests
```

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //CHECK AND SET UP TESTS 
        _ = BDTestsEnv().testEnv()

        return true
}
```

## Network Tests 
Create an instance of BDTests: 
```ruby
let test = BDTests(enviornment:nil)
```
If you pass nil in the initializer BDTests will use a default name (String) as your enviornment name. This is usually fine.
next create a test: 

```ruby
test.createTest(jsonString:nil, jsonFile:"stub-file",httpCode:200)
```

createTest will either accept a JSON string or the name of a file that needs to live in the main bundle of your app. In either case this will be the JSON that is stubbed as a response from the call that your app will make to your server. Finally provide the HTTP Response code you desire to test.

This test will intercept the call made by your app to a server and return the JSON payload you used when you created the test. `


## How to stub multiple requests
In cases where you want to do multiple requests simply create a 2nd test with a different enviornment name:

```ruby
//TEST 1
let sut = BDTests(enviornment:nil)
let test = sut.createTest(jsonString: "{\"key\":\"value\"}" , jsonFile: nil, httpCode: 400)

//TEST 2
sut.enviornmentName = "test-2
let test2 = sut.createTest(jsonString: "{\"key2\":\"value2\"}" , jsonFile: nil, httpCode: 200)
```

## Setting up your app's state for a test
If you want to to some set up prior to running your test that is not related to networking, for example seeding your database with some specific data follow these steps:

  1. In your apps code create an extension of BDTestsHelper and add a method to do whatever set up you need doen here.

```ruby
import BDTests 

extension BDTestsHelper {

	func setUpMethod(){

		//DO SOME SET UP HERE

	}
}
```

2. In your test code call the seedDatabase method and pass the name of your method that you want to call as a String value. GOTCHA!! You must do this prior to XCUIApplication().launch() being called or it will be ignored.

```ruby
let seeded =  sut.seedDatabase(ref: "setUpMethod")
```

## Author

bytedissident, dbronston@me.com

## License

BDTests is available under the MIT license. See the LICENSE file for more info.
