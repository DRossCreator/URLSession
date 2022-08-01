//
//  ViewController.swift
//  URLSessionStartProject
//
//  Created by Alexey Pavlov on 29.11.2021.
//

import UIKit
import CommonCrypto

class ViewController: UIViewController {

    private let endpointClient = EndpointClient(applicationSettings: ApplicationSettingsService())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        executeCall()
    }
    
    func executeCall() {
        let endpoint = GetNameEndpoint()
        let completion: EndpointClient.ObjectEndpointCompletion<String> = { result, response in
            guard let responseUnwrapped = response else { return }

            print("\n\n response = \(responseUnwrapped.allHeaderFields) ;\n \(responseUnwrapped.statusCode) \n")
            switch result {
            case .success(let team):
                print("team = \(team)")
                
            case .failure(let error):
                print(error)
            }
        }
        
        endpointClient.executeRequest(endpoint, completion: completion)
    }

}

final class GetNameEndpoint: ObjectResponseEndpoint<String> {
    
    override var method: RESTClient.RequestType { return .get }
    override var path: String { "/v1/public/characters/1009610/comics" }
    private let publicKey = "c600aa70d57f22efc8035b44f8b68eda"
    private let privateKey = "4d9a3ea7738f06e74b42939a0736a0a855a049d2"
    static var ts = Date.currentTimeStamp
    static var format = "comic"

    override init() {
        super.init()
        queryItems = [URLQueryItem(name: "ts", value: "\(GetNameEndpoint.ts)"),
                      URLQueryItem(name: "format", value: GetNameEndpoint.format),
                      URLQueryItem(name: "apikey", value: publicKey),
                      URLQueryItem(
                        name: "hash",
                        value: md5("\(GetNameEndpoint.ts)\(privateKey)\(publicKey)")
                      ),
        ]
    }
    
}

private func md5(_ string: String) -> String {

     let length = Int(CC_MD5_DIGEST_LENGTH)
     var digest = [UInt8](repeating: 0, count: length)

     if let d = string.data(using: String.Encoding.utf8) {
         _ = d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
             CC_MD5(body, CC_LONG(d.count), &digest)
         }
     }
    print((0..<length).reduce("") {
        $0 + String(format: "%02x", digest[$1])
    })

     return (0..<length).reduce("") {
         $0 + String(format: "%02x", digest[$1])
     }
 }

func decodeJSONOld() {
    let str = """
        {\"team\": [\"ios\", \"android\", \"backend\"]}
    """
    
    let data = Data(str.utf8)

    do {
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            if let names = json["team"] as? [String] {
                print(names)
            }
        }
    } catch let error as NSError {
        print("Failed to load: \(error.localizedDescription)")
    }
}

