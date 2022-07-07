// Henrik Top Mygind, 21/06/2022

import Foundation

public protocol DataEncodable {
    var data: Data { get }
}

public protocol DataDecodable {
    init?(_ data: Data?)
}

public typealias DataCodable = DataEncodable & DataDecodable
