# ApiConnector
Framework for convenient Connection to Api.

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
        case .auth: return "auth"
        case .me: return "me"
        case .posts(_): return "posts"
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
