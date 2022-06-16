// Henrik Top Mygind, 06/06/2022

import CoreBluetooth

class ActualService: Service {
    private let service: CBService
    init(_ service: CBService) {
        self.service = service
    }
    
    var uuid: CBUUID { service.uuid }
    
    var isPrimary: Bool { service.isPrimary }
    
    var characteristics: [Characteristic]? {
        service.characteristics.map { $0 }
    }
}
