# ApiConnector
Framework for convenient Connection to Api.


[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) 
[![Build Status](https://travis-ci.org/wearereasonablepeople/ApiConnector.svg?branch=master)](https://travis-ci.org/wearereasonablepeople/ApiConnector)
[![codecov](https://codecov.io/gh/wearereasonablepeople/ApiConnector/branch/master/graph/badge.svg)](https://codecov.io/gh/wearereasonablepeople/ApiConnector)

## Table of contents
1. [Router](#router)
2. [API Connection](#api-connection)
3. [Mocking Requests](#mocking-requests)

## Router
ApiConnector uses [SweetRouter](https://github.com/alickbass/SweetRouter) as a dependency to declare routes for the back-end

## API Connection

The framework provides a convenient way for making requests to API with given Router. You can use the completion handler of the created requests but framework also provides observables that create `JSON` or models that conforms to Codable protocol.

**Example of possible ApiConnector:**

```swift
//Here is our Post Model
struct Post: Codable {
    let title: String
    let description: String
}

// And here is our ApiConnection Type
class ApiConnection<Provider: DataRequestType>: ApiConnectionType {
    typealias RouterType = Api
    typealias RequestType = Provider

    var defaultHeaders: HTTP.Headers? {
        return [.accept: .applicationJson, .contentType: .charsetUtf8, .acceptLanguage: .languageEnUS]
    } 

    func allPosts(for date: Date) -> Observable<[Post]> {
        return requestObservable(at: .posts(for: date))
    }
}

//Convenient typealias to save space :)
typealias Connection = ApiConnection<URLSessionDataTask>

//The to get all posts
let postsDisposable = Connection().allPosts(for: Date()).subscribe(onNext: { posts in
    print(posts)
}, onError: { error in
    print(error)
})
```

### Default Network Connector

If you don't really want to create your own `APIConnectionType` class, you can use the default `NetworkConnector` type for making requests

**Example of getting posts with `NetworkConnector`:**

```swift
typealias Connection = NetworkConnector<URLSessionDataTask, Api>

let posts: Observable<[Post]> = Connection().requestObservable(at: .posts(for: Date()))
let disposable = posts.subscribe(onNext: { posts in
    print(posts)
}, onError: { error in
    print(error)
})
```

## Mocking Requests
The most powerfull feature of this framework is that it is really easy to mock requests for the purpose of `Unit Testing` without running any external processes and changing any code base.

The reason why `ApiConnection<Provider: DataRequestType>` is generic is to allow plugging in mock `Connection Provider`. As we saw above, for the real requests we would use `URLSessionDataTask` as a `Provider` for `ApiConnection`. URLSessftaTask would make the real requests to the real servers.

For `Unit Test` requests, we can use provided by the Framework `TestConnector` provider type. The only thing it does, is asks you for `Response` for the given `Request` and returns it to the `APIConnectionType`.

**Example of mocking same posts request:**

```swift
// Convenience typealias to save space :)
typealias TestConnection<T: ResponseProvider> = ApiConnection<TestConnector<T>>

// This is our type that provides reponse for given request
struct PostsResponseProvider: ResponseProvider {
    static func response(for request: URLRequest) -> Observable<Response> {
        let posts: [Post] = //Here we create mock list of posts
        
        return .just(Response(for: request, with: 200, jsonObject: posts))
    }
}

// We provide TestConnector with our PostsResponseProvider and wait for the magic to happen )))
let postsDisposable = TestConnection<PostsResponseProvider>().allPosts(for: Date()).subscribe(onNext: { posts in
    print(posts)
}, onError: { error in
    print(error)
})
```
