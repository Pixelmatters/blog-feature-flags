//
//  FeatureToggleProvider.swift
//  FeatureToggle
//

import Foundation

public protocol FeatureToggleProvider {
    typealias FetchResult = Swift.Result<[String: Bool], Error>

    func setup(with values: [String: Bool])
    func fetchFeatureToggles(completion: @escaping (FetchResult) -> Void)
}
