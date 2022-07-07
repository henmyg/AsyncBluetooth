// Henrik Top Mygind, 07/07/2022

import XCTest

class Int_DataCodableTests: XCTestCase {

    func testWorksWithLittleEndian() {
        let value = UInt32(128256)
        let data = value.asLittleEndian
        let expected = Data([00, 0xF5,0x01, 00])
        XCTAssertEqual(data, expected , "\(data.map { "\($0)"}) != \(expected.map { "\($0)" })")
    }
    
    func testWorksWithBigEndian() {
        let value = UInt32(128256)
        let data = value.asBigEndian
        let expected = Data([00, 0x01,0xF5, 00])
        XCTAssertEqual(data, expected , "\(data.map { "\($0)"}) != \(expected.map { "\($0)" })")
    }
}
