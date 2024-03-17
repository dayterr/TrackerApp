//
//  TrackerAppTests.swift
//  TrackerAppTests
//
//  Created by Ruth Dayter on 18.03.2024.
//

import XCTest
import SnapshotTesting
@testable import TrackerApp

final class TrackerAppTests: XCTestCase {

    func testMainViewController() {
        let vc = TrackersViewController()
        
        assertSnapshots(of: vc, as: [.image(on: .iPhone13, traits: UITraitCollection(userInterfaceStyle: .light))])
        
        assertSnapshots(of: vc, as: [.image(on: .iPhone13, traits: UITraitCollection(userInterfaceStyle: .dark))])
    }
}
