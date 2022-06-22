//
//  MIMEType.swift
//  
//
//  Created by Alex Ioja-Yang on 20/06/2022.
//

import Foundation

/// Multipurpose Internet Mail Extension defined and standardized in IETF's [RFC 6838](https://datatracker.ietf.org/doc/html/rfc6838)
public enum MIMEType: String {
    
    /// Key under which the MIME Type is added in the request header
    internal static let key = "Content-Type"
    
    case JSON =  "application/json"
    case urlEncodedForm = "application/x-www-form-urlencoded"
}
