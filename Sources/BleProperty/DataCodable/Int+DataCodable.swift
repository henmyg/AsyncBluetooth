// Henrik Top Mygind, 07/07/2022

import Foundation

extension Int: DataCodable {
    public init?(_ data: Data?) {
        guard let value = data?.withUnsafeBytes({ $0.load(as: Int.self) }) else {
            return nil
        }
        
        self = value
    }
    
    public var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<Int>.size)
    }
    
    public var asLittleEndian: Data { self.littleEndian.data }
    public var asBigEndian: Data { self.bigEndian.data }
}

// MARK: UInt
extension UInt8: DataCodable {
    public init?(_ data: Data?) {
        guard let value = data?.withUnsafeBytes({ $0.load(as: UInt8.self) }) else {
            return nil
        }
        
        self = value
    }
    
    public var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<UInt8>.size)
    }
    
    public var asLittleEndian: Data { self.littleEndian.data }
    public var asBigEndian: Data { self.bigEndian.data }
}

extension UInt16: DataCodable {
    public init?(_ data: Data?) {
        guard let value = data?.withUnsafeBytes({ $0.load(as: UInt16.self) }) else {
            return nil
        }
        
        self = value
    }
    
    public var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<UInt16>.size)
    }
    
    public var asLittleEndian: Data { self.littleEndian.data }
    public var asBigEndian: Data { self.bigEndian.data }
}

extension UInt32: DataCodable {
    public init?(_ data: Data?) {
        guard let value = data?.withUnsafeBytes({ $0.load(as: UInt32.self) }) else {
            return nil
        }
        
        self = value
    }
    
    public var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<UInt32>.size)
    }
    
    public var asLittleEndian: Data { self.littleEndian.data }
    public var asBigEndian: Data { self.bigEndian.data }
}

extension UInt64: DataCodable {
    public init?(_ data: Data?) {
        guard let value = data?.withUnsafeBytes({ $0.load(as: UInt64.self) }) else {
            return nil
        }
        
        self = value
    }
    
    public var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<UInt64>.size)
    }
    
    public var asLittleEndian: Data { self.littleEndian.data }
    public var asBigEndian: Data { self.bigEndian.data }
}

// MARK: Int
extension Int8: DataCodable {
    public init?(_ data: Data?) {
        guard let value = data?.withUnsafeBytes({ $0.load(as: Int8.self) }) else {
            return nil
        }
        
        self = value
    }
    
    public var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<Int8>.size)
    }
    
    public var asLittleEndian: Data { self.littleEndian.data }
    public var asBigEndian: Data { self.bigEndian.data }
}

extension Int16: DataCodable {
    public init?(_ data: Data?) {
        guard let value = data?.withUnsafeBytes({ $0.load(as: Int16.self) }) else {
            return nil
        }
        
        self = value
    }
    
    public var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<Int16>.size)
    }
    
    public var asLittleEndian: Data { self.littleEndian.data }
    public var asBigEndian: Data { self.bigEndian.data }
}

extension Int32: DataCodable {
    public init?(_ data: Data?) {
        guard let value = data?.withUnsafeBytes({ $0.load(as: Int32.self) }) else {
            return nil
        }
        
        self = value
    }
    
    public var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<Int32>.size)
    }
    
    public var asLittleEndian: Data { self.littleEndian.data }
    public var asBigEndian: Data { self.bigEndian.data }
}

extension Int64: DataCodable {
    public init?(_ data: Data?) {
        guard let value = data?.withUnsafeBytes({ $0.load(as: Int64.self) }) else {
            return nil
        }
        
        self = value
    }
    
    public var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<Int64>.size)
    }
    
    public var asLittleEndian: Data { self.littleEndian.data }
    public var asBigEndian: Data { self.bigEndian.data }
}
