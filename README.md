# ApiConnector
Framework for convenient Connection to Api.


[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) 
[![Build Status](https://travis-ci.org/wearereasonablepeople/ApiConnector.svg?branch=master)](https://travis-ci.org/wearereasonablepeople/ApiConnector)
[![codecov](https://codecov.io/gh/wearereasonablepeople/ApiConnector/branch/master/graph/badge.svg)](https://codecov.io/gh/wearereasonablepeople/ApiConnector)

## Table of contents
1. [Router](#router)
2. [API Connection](#api-connection)
3. [Mocking Requests](#mocking-requests)

##Router
Framework allows to create routers to describe the endpoints used for API connection.

**Example of Router:**

```swift
import ApiConnector
import Alamofire

enum Environment: String, ApiEnvironment {
    case localhost
    case test = "mytestserver.com"
    case production = "myproductionserver.com"
}

enum Router: ApiRouter {
    typealias EnvironmentType = Environment
    
    case auth, me
    case posts(for: Date)
    
    var path: String {
        switch self {
        case .auth: return "/auth"
        case .me: return "/me"
        case .posts(_): return "/posts"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case let .posts(for: date):
            return [URLQueryItem(name: "date", value: date.convertToString)]
        default:
            return nil
        }
    }

    var method: HTTPMethod {
        switch self {
        case .auth: return .post
        default: return .get
        }
    }
}
```

And then we can get the url for specific `endpoint` like this:

```swift
let url = Router.me.url(for: .test)
print(url.absoluteString) //prints http://mytestserver.com:80/me
```

##API Connection

The framework provides a convenient way for making requests to API with given Router. You can use the completion handler of the created requests but framework also provides observables that create `JSON` or models that that conform to [SwiftyJSONModel](https://github.com/alickbass/SwiftyJSONModel) protocols.

**Example of possible ApiConnector:**

```swift
//Here is our Post Model
struct Post: JSONModelType {
    enum PropertyKey: String {
        case title, description
    }
    
    let title: String
    let description: String
    
    init(object: JSONObject<PropertyKey>) throws {
        title = try object.value(for: .title)
        description = try object.value(for: .description)
    }
    
    var dictValue: [PropertyKey : JSONRepresentable] {
        return [.title: title, .description: description]
    }
}

// And here is our ApiConnection Type
class ApiConnection<Provider: DataRequestType>: ApiConnectionType {
    typealias RouterType = Router
    typealias RequestType = Provider
    
    let environment: Environment = .test
    
    func allPosts(for date: Date) -> Observable<[Post]> {
        return requestObservable(at: .posts(for: date))
    }
}

//Convenient typealias to save space :)
typealias Connection = ApiConnection<Alamofire.DataRequest>

//The to get all posts
let postsDisposable = Connection().allPosts(for: Date()).subscribe(onNext: { posts in
    print(posts)
}, onError: { error in
    print(error)
})
```

###Default Network Connector

If you don't really want to create your own `APIConnectionType` class, you can use the default `NetworkConnector` type for making requests

**Example of getting posts with `NetworkConnector`:**

```swift
typealias Connection = NetworkConnector<Alamofire.DataRequest, Router>

let posts: Observable<[Post]> = Connection(environment: .test).requestObservable(at: .posts(for: Date()))
let disposable = posts.subscribe(onNext: { posts in
    print(posts)
}, onError: { error in
    print(error)
})
```

##Mocking Requests
The most powerfull feature of this framework is that it is really easy to mock requests for the purpose of `Unit Testing` without running any external processes and changing any code base.

The reason why `ApiConnection<Provider: DataRequestType>` is generic is to allow plugging in mock `Connection Provider`. As we saw above, for the real requests we would use `Alamofire.DataRequest` as a `Provider` for `ApiConnection`. Alamofire would make the real requests to the real servers.

For `Unit Test` requests, we can use provided by the Framework `TestConnector` provider type. The only thing it does, is asks you for `Response` for the given `Request` and returns it to the `APIConnectionType`.

**Example of mocking same posts request:**

```swift
// Convenience typealias to save space :)
typealias TestConnection<T: ResponseProvider> = ApiConnection<TestConnector<T>>

// This is our type that provides reponse for given request
struct PostsResponseProvider: ResponseProvider {
    static func response(for request: URLRequest) -> TestConnectorResponse {
        let posts: [Post] = //Here we create mock list of posts
        
        return successResponse(for: request, with: 200, jsonObject: posts.jsonRepresantable)
    }
}

// We provide TestConnector with our PostsResponseProvider and wait for the magic to happen )))
let postsDisposable = TestConnection<PostsResponseProvider>().allPosts(for: Date()).subscribe(onNext: { posts in
    print(posts)
}, onError: { error in
    print(error)
})
```
