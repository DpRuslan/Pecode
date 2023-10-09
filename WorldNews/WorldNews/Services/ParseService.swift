//
//  ParseService.swift
//

import Foundation

enum Status {
    case success
    case failure(error: CustomError)
    case empty
}

final class ParseService {
    static let shared = ParseService()
    
    private init() { }
    
// MARK: Generic parse func
    
    func parseResponse<T: Decodable, Y>(res: Result<Data, CustomError>, myData: inout Y, decodeStruct: T.Type, completion: @escaping(Status)->Void) {
        switch res {
        case .success(let data):
            do {
                myData = try JSONDecoder().decode(T.self, from: data) as! Y
                completion(.success)
            } catch {
                completion(.failure(error: .uknown))
            }
        case .failure(let error):
            completion(.failure(error: error))
        }
    }
}
