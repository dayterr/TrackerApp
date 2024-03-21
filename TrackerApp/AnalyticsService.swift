//
//  AnalyticsService.swift
//  TrackerApp
//
//  Created by Ruth Dayter on 17.03.2024.
//

import Foundation
import YandexMobileMetrica

struct AnalyticsService {
    
    static let shared = AnalyticsService()
    
    func activateYandexMetrica() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "67c37f17-73a5-46f8-85f7-6636decbb795") else { return }
        
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func reportEvent(event: String, params: [AnyHashable : Any]) {
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        } )
    }
}
