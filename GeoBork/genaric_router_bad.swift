
import Foundation
import Alamofire

enum ApiType{
   case Accounts
    
    var route: String {
        switch self {
        case .Accounts: return "acounts"
        }
    }

    var path: NSURL {
        switch self {
        case .Accounts: return NSURL(fileURLWithPath: "https:\\geobork.org")
        }

    }
}

// MARK: - Router
protocol RouterProtocol {
    var apiType: ApiType { get set }
    func post() -> String
    func get(identifier: String) -> String
    func update(identifier: String) -> String
    func destroy(identifier: String) -> String
}

struct AccountsRouter: RouterProtocol {
    var apiType = ApiType.Accounts
    func post() -> String { return apiType.route }
    func get(identifier: String) -> String { return "\(apiType.route)/\(identifier)" }
    func update(identifier: String) -> String { return "\(apiType.route)/\(identifier)" }
    func destroy(identifier: String) -> String { return "\(apiType.route)/\(identifier)" }
}


enum RouterBad<T>: URLRequestConvertible where T: RouterProtocol {
    
    case post(T, [String: AnyObject])
    case get(T, String)
    case update(T, String, [String: AnyObject])
    case destroy(T, String)
    
    var method: HTTPMethod {
        switch self {
        case .post:
            return .post
        case .get:
            return .get
        case .update:
            return .put
        case .destroy:
            return .delete
        }
    }
    
    var path: NSURL {
        switch self {
        case .post(let object, _):
            return object.apiType.path
        case .get(let object):
            return object.0.apiType.path
        case .update(let object):
            return object.0.apiType.path
        case .destroy(let object):
            return object.0.apiType.path
        }
    }
    
    var route: String {
        switch self {
        case .post(let object, _):
            return object.post()
        case .get(let object, let identifier):
            return object.get(identifier: identifier)
        case .update(let object, let identifier, _):
            return object.update(identifier: identifier)
        case .destroy(let object, let identifier):
            return object.destroy(identifier: identifier)
        }
    }
    
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: path.appendingPathComponent(route)!)
        urlRequest.httpMethod = method.rawValue
 
        
        switch self {
        case .post(_, let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .update(_, _, let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            break;
        }
        return urlRequest
    }
}
//RouterBad.get(AccountsRouter(), "").asURLRequest()
