// Henrik Top Mygind, 17/06/2022

import Foundation
import CoreBluetooth

public class MockService: Service {
    public init() { }
    
    public var uuid: CBUUID = CBUUID()
    
    public var isPrimary: Bool = false
    
    public var characteristics: [Characteristic]?
}
