
public class Hydra {

    public enum Result<T> {
        case success(T)
        case failure(Error)
    }

    let endpoint: String
    let urlSession: URLSessionProtocol

    public init(endpoint: String, urlSession: URLSessionProtocol) {
        self.endpoint = endpoint
        self.urlSession = urlSession
    }

    public convenience init (endpoint: String) {
        self.init(endpoint: endpoint, urlSession: URLSession.shared)
    }

    public func get<T:HydraObject>(_ hydraObject:T.Type, parameters: [String:Any] = [:], completion: @escaping (Result<[T]>) -> ()) {
        var urlComponents = URLComponents(string: endpoint + hydraObject.hydraPoint())
        urlComponents?.queryItems = []
        for (key,value) in parameters {
            urlComponents?.queryItems?.append(URLQueryItem(name: key, value: (value as! String)))
        }
        let task = urlSession.dataTask(with: urlComponents!.url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                var members: [T] = []
                for member in json["hydra:member"] as! [[String:Any]] {
                    members.append(hydraObject.init(hydra: member))
                }
                completion(Result.success(members))
            } catch let errorjson {
                print(errorjson)
            }
        }

        task.resume()
    }

    public func get<T:HydraObject>(_ hydraObject:T.Type, id: Int,  completion: @escaping (Result<T>) -> ()) {
        let url = URL(string: endpoint + hydraObject.hydraPoint() + "/" + String(id))
        let task = urlSession.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                let result = Result.success(hydraObject.init(hydra: json))
                completion(result)
            } catch let errorjson {
                completion(Result.failure(errorjson))
                print(errorjson)
            }
        }

        task.resume()
    }
}
