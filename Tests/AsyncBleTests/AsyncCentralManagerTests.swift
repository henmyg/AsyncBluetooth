// Henrik Top Mygind, 16/06/2022

import XCTest
import Combine
import CoreBluetoothWrapper
import AsyncBle

class AsyncCentralManagerTests: XCTestCase {

    func test_delegatesArePublished() {
        let mock = MockCentralManager()
        let manager = SimpleAsyncCentralManager(mock)
        
        var subscriptions = Set<AnyCancellable>()
        let didUpdateState = expectation(description: "DidUpdateState")
        let didDiscover = expectation(description: "DidDiscover")
        let didConnect = expectation(description: "DidConnect")
        let didFailToConnect = expectation(description: "DidFailToConnect")
        let didDisconnect = expectation(description: "DidDisconnect")
        
        manager.didUpdateState.sink { _ in didUpdateState.fulfill() }.store(in: &subscriptions)
        manager.didDiscover.sink { _ in didDiscover.fulfill() }.store(in: &subscriptions)
        manager.didConnect.sink { _ in didConnect.fulfill() }.store(in: &subscriptions)
        manager.didFailToConnect.sink { _ in didFailToConnect.fulfill() }.store(in: &subscriptions)
        manager.didDisconnect.sink { _ in didDisconnect.fulfill() }.store(in: &subscriptions)
        
        guard case .simple(delegate: let delegate) = mock.delegate else {
            XCTFail("Wrtong delegate type")
            return
        }
        
        let peripheral = MockPeripheral()
        delegate.delegate?.centralManagerDidUpdateState(mock)
        delegate.delegate?.centralManager(mock, didDiscover: peripheral, advertisementData: [:], rssi: 42)
        delegate.delegate?.centralManager(mock, didConnect: peripheral)
        delegate.delegate?.centralManager(mock, didFailToConnect: peripheral, error: nil)
        delegate.delegate?.centralManager(mock, didDisconnectPeripheral: peripheral, error: nil)
        
        wait(for: [
            didUpdateState,
            didDiscover,
            didConnect,
            didFailToConnect,
            didDisconnect
        ], timeout: 0.5)
    }
    
    func test_doesntKeepEachotherAlive() {
        var strongManager: CentralManager? = MockCentralManager()
        weak var weakManager = strongManager
        var strongAsync: AsyncCentralManager? = SimpleAsyncCentralManager(strongManager!)
        weak var weakAsync = strongAsync
        strongManager = nil
        
        XCTAssertNotNil(weakManager) // Kept alive by asyncManager
        XCTAssertNotNil(weakAsync)
        
        strongAsync = nil
        XCTAssertNil(weakManager) // No longer kept alive
        XCTAssertNil(weakAsync)
        
//        var strongDelegate: ExampleDelegate? = ExampleDelegate()
//        weak var weakDelegate = strongDelegate
//        let _ = ActualCentralManager(delegate: .restoring(delegate: strongDelegate!), queue: nil, options: [:])
//        XCTAssertNotNil(weakDelegate)
//
//        strongDelegate = nil
//        XCTAssertNil(weakDelegate)
    }
    
    
    public class SimpleCentralManagerDelegateRef {
        public init(_ delegate: SimpleCentralManagerDelegate) {
            self.delegate = delegate
        }
        
        public weak var delegate: SimpleCentralManagerDelegate?
    }
    

    
    func test_normalRetaining() {
        var viewModel: ViewModel? = ViewModel()
        weak var weakViewModel = viewModel
        var service: Service? = Service()
        weak var weakService = service
        service?.delegate = viewModel
        
        XCTAssertNotNil(weakViewModel)
        XCTAssertNotNil(weakService)
        
        viewModel = nil
        XCTAssertNil(weakViewModel)
        XCTAssertNotNil(weakService)
        
        service = nil
        XCTAssertNil(weakViewModel)
        XCTAssertNil(weakService)
    }
    
    func test_enumRetaining() {
        var viewModel: ViewModel? = ViewModel()
        weak var weakViewModel = viewModel
        var service: Service? = Service()
        weak var weakService = service
        service?.eDelegate = .one(delegate: DelegateExampleRef(viewModel!))
        
        XCTAssertNotNil(weakViewModel)
        XCTAssertNotNil(weakService)
        
        viewModel = nil
        XCTAssertNil(weakViewModel)
        XCTAssertNotNil(weakService)
        
        service = nil
        XCTAssertNil(weakViewModel)
        XCTAssertNil(weakService)
    }
}

class ViewModel : DelegateExample {
    
}

class Service {
    weak var delegate: DelegateExample?
    var eDelegate: Delegater?
}

protocol DelegateExample: AnyObject {
}


class DelegateExampleRef {
    public init(_ delegate: DelegateExample) {
        self.delegate = delegate
    }

    public weak var delegate: DelegateExample?
}



enum Delegater {
    case one(delegate: DelegateExampleRef)
}
