//
//  AlamofireRequestExtensionMethods.swift
//  EventfulSearchApp
//
//  Created by Miles McLeod on 2016-05-24.
//  Copyright © 2016 Miles McLeod. All rights reserved.
//
import Alamofire
import Fuzi

extension Request {
    public static func XMLResponseSerializer() -> ResponseSerializer<XMLDocument, NSError> {
        return ResponseSerializer { request, response, data, error in
            guard error == nil else { return .Failure(error!) }
            
            guard let validData = data else {
                let failureReason = "Data could not be serialized. Input data was nil."
                let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            
            do {
                let XML = try XMLDocument(data: validData)
                return .Success(XML)
            } catch {
                return .Failure(error as NSError)
            }
        }
    }
    
    public func responseXMLDocument(completionHandler: Response<XMLDocument, NSError> -> Void) -> Self {
        return response(responseSerializer: Request.XMLResponseSerializer(), completionHandler: completionHandler)
    }
}