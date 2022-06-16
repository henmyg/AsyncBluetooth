// Henrik Top Mygind, 06/06/2022

import CoreBluetooth

public protocol Service {
    var uuid: CBUUID { get }
    var isPrimary: Bool { get }
    var characteristics: [Characteristic]? { get }
}
