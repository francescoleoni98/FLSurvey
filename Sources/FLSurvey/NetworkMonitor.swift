//
//  NetworkMonitor.swift
//  FLSurvey
//
//  Created by Francesco Leoni on 10/06/25.
//

import SwiftUI
import Network
import SystemConfiguration

public class NetworkMonitor: ObservableObject {

	private let monitor = NWPathMonitor()
	private let queue = DispatchQueue(label: "NetworkMonitor")

	@Published public var isConnected = false
	@Published public var connectionType: ConnectionType = .unknown

	public enum ConnectionType {
		case wifi
		case cellular
		case ethernet
		case unknown
	}

	public init() {
		startMonitoring()
	}

	deinit {
		stopMonitoring()
	}

	public func stopMonitoring() {
		monitor.cancel()
	}

	public  func startMonitoring() {
		monitor.pathUpdateHandler = { [weak self] path in
			DispatchQueue.main.async {
				self?.isConnected = path.status == .satisfied
				self?.getConnectionType(path)
			}
		}

		monitor.start(queue: queue)
	}

	private func getConnectionType(_ path: NWPath) {
		if path.usesInterfaceType(.wifi) {
			connectionType = .wifi
		} else if path.usesInterfaceType(.cellular) {
			connectionType = .cellular
		} else if path.usesInterfaceType(.wiredEthernet) {
			connectionType = .ethernet
		} else {
			connectionType = .unknown
		}
	}
}
