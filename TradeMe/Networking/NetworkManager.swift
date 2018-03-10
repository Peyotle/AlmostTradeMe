//  Created by Oleg Chernyshenko on 10/03/18.

import Foundation

class NetworkManager {
    typealias ListingSearchCompletion = (SearchResult?) -> ()

    func updateCategory(_ categoryId: Int, completion: @escaping ListingSearchCompletion) {
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
