//
//  APIClient.swift
//  combine-demo
//
//  Created by Abhishek Ravi on 20/01/23.
//

import Foundation

protocol APIClientDelegate: AnyObject {
    func onAPISuccess(_ data: [UserModel]) //TODO: Bear this Coupled Code :/
    func onAPIFailure(_ error: Error)
}

class APIClient {
    
    weak var delegate: APIClientDelegate?
    
    func get(_ url: URL) {
        URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
            
            //onFailure
            if let err = error {
                self?.delegate?.onAPIFailure(err)
                return
            }
            
            // onSuccess
            if let data = data,
               let decodedType = try? JSONDecoder().decode([UserModel].self, from: data) {
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.onAPISuccess(decodedType)
                }
            }
            
        }.resume()
    }
    
}
