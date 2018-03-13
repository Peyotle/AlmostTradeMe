//  Created by Oleg Chernyshenko on 10/03/18.

import Foundation
import OAuthSwift

enum NetworkError: Error {
    case loadingError
}

protocol NetworkManager {
    typealias CategorySearchCompletion = (SearchResult?) -> ()
    typealias CategoryCompletion = (Category?) -> ()
    func getListings(_ categoryNumber: String, completion: @escaping CategorySearchCompletion)
    func getCategory(_ number: String, completion: @escaping CategoryCompletion)
}

protocol ImageLoader {
    func loadImage(url: URL, completion: @escaping (UIImage?, Error?) -> ())
}

protocol ListingLoader {
    typealias ListingSearchCompletion = (Listing?) -> ()
    func getListing(_ listingId: Int, completion: @escaping ListingSearchCompletion)
}

class NetworkManagerImpl: NetworkManager {

    typealias OAuthRequestCompletion = (OAuthSwiftResponse?) -> ()
    let consumerKey = "A1AC63F0332A131A78FAC304D007E7D1"
    let oauthSignature = "EC7F18B17A062962C6930A8AE88B16C7"
    let rootPath = "https://api.tmsandbox.co.nz/v1"
    var oauthswift: OAuth1Swift!
    
    func getListings(_ categoryNumber: String, completion: @escaping CategorySearchCompletion) {
        let numberOfRows = 20
        let path = "\(rootPath)/Search/General.json?rows=\(numberOfRows)&category=\(categoryNumber)"
        oauthRequest(path: path) { [weak self] (response) in
            guard let response = response,
                let result = self?.decodeJSON(from: response.data, ofType: SearchResult.self) else {
                    completion(nil)
                    return
            }
            completion(result)
        }
    }

    func getCategory(_ number: String, completion: @escaping CategoryCompletion) {
        let path = "\(rootPath)/Categories/\(number).json?depth=1&with_counts=true"

        oauthRequest(path: path) { [weak self] (response) in
            guard let response = response,
                let result = self?.decodeJSON(from: response.data, ofType: Category.self) else {
                    completion(nil)
                    return
            }
            completion(result)
        }
    }
}

extension NetworkManagerImpl: ListingLoader {
    func getListing(_ listingId: Int, completion: @escaping ListingSearchCompletion) {
        let path = "\(rootPath)/Listings/\(listingId).json"

        oauthRequest(path: path) { [weak self] (response) in
            guard let response = response,
                let result = self?.decodeJSON(from: response.data, ofType: Listing.self) else {
                    completion(nil)
                    return
            }
            completion(result)
        }
    }
}

extension NetworkManagerImpl: ImageLoader {
    func loadImage(url: URL, completion: @escaping (UIImage?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            let httpResponse = response as! HTTPURLResponse
            guard httpResponse.statusCode == 200 else {
                print("Image liading error. Response: ", httpResponse.statusCode)
                completion(nil, NetworkError.loadingError)
                return
            }
            guard let data = data, error == nil else {
                print("Error loading image: ", error as Any)
                completion(nil, error)
                return
            }
            let image = UIImage(data: data)
            completion(image, nil)
            }
            .resume()
    }
}

extension NetworkManagerImpl {
    func oauthRequest(path: String, completion: @escaping OAuthRequestCompletion) {
        oauthswift = OAuth1Swift(
            consumerKey:    consumerKey,
            consumerSecret: oauthSignature
        )
        DispatchQueue.global().async { [weak self] in
            _ = self?.oauthswift.client.get(path,
                                            success: { response in
                                                let httpResponse = response.response
                                                guard httpResponse.statusCode == 200 else {
                                                    print("Category loading error. Response: ", httpResponse.statusCode)
                                                    ErrorPresenter.present(error: NetworkError.loadingError)
                                                    completion(nil)
                                                    return
                                                }
                                                completion(response)},
                                            failure: { error in
                                                if let error = error as? OAuthSwiftError,
                                                    (error.underlyingError != nil) {
                                                    ErrorPresenter.present(error: error.underlyingError!)
                                                }
                                                print("Error: \(error)")
                                                completion(nil)
            })
        }
    }

    func decodeJSON<T: Decodable>(from data: Data, ofType: T.Type) -> T? {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(T.self, from: data)
            return result
        } catch {
            print("JSON parsing error: \(error.localizedDescription)")
            return nil
        }
    }
}
