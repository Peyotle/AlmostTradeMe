//  Created by Oleg Chernyshenko on 10/03/18.

import Foundation
import OAuthSwift

protocol NetworkManager {
    typealias ListingSearchCompletion = (SearchResult?) -> ()
    func getCategory(_ categoryId: Int, completion: @escaping ListingSearchCompletion)
}

class NetworkManagerImpl: NSObject, NetworkManager, URLSessionDelegate {
    let consumerKey = "A1AC63F0332A131A78FAC304D007E7D1"
    let oauthSignature = "EC7F18B17A062962C6930A8AE88B16C7"
    var oauthswift: OAuth1Swift!
    
    func getCategory(_ categoryId: Int, completion: @escaping ListingSearchCompletion) {
        let path = "https://api.tmsandbox.co.nz/v1/Search/General.json?rows=20&category=\(categoryId)"

        oauthswift = OAuth1Swift(
            consumerKey:    consumerKey,
            consumerSecret: oauthSignature
        )
        _ = oauthswift.client.get(path,
                                  success: { [weak self] response in
                                    print("Got response =====================")
                                    guard let result = self?.decodeJSON(from: response.data) else {
                                        completion(nil)
                                        return
                                    }
                                    completion(result)
        },
                                  failure: { error in
                                    print("Error: \(error)")
                                    completion(nil)
        })
    }

    func decodeJSON(from data: Data) -> SearchResult? {
        do {
            let decoder = JSONDecoder()

            let result = try decoder.decode(SearchResult.self, from: data)
            return result
        } catch {
            print("JSON parsing error: \(error.localizedDescription)")
            return nil
        }
    }
}

class NetworkManagerLocal: NetworkManager {

    func getCategory(_ categoryId: Int, completion: @escaping ListingSearchCompletion) {
        guard let jsonData = loadSampleJSON("SearchResults") else {
            print("Can't parse JSON data")
            completion(nil)
            return
        }
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(SearchResult.self, from: jsonData)
            completion(result)
        } catch {
            print("JSON parsing error: \(error.localizedDescription)")
            completion(nil)
        }
    }

    func loadSampleJSON(_ name: String) -> Data? {
        if let fileURL = Bundle.main.url(forResource: name, withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileURL)
                return data
            } catch {
                print("Cant load JSON: \(error.localizedDescription)")
            }
        }
        return nil
    }
}
