//
//  FeatureToggle.swift
//  FeatureToggle
//

import Foundation

public protocol FeatureToggleService {
    typealias SetupResult = Swift.Result<Void, FeatureToggle.SetupError>
    typealias FeatureEnabledResult = Swift.Result<Bool, FeatureToggle.FeatureError>
    
    func setup(completion: @escaping (SetupResult) -> Void)
    func isFeatureEnabled(feature: FeatureToggle.Feature, completion: @escaping (FeatureEnabledResult) -> Void)
}

public class FeatureToggle {

    public enum Feature: String {
        case feature1
    }

    public enum SetupError: Swift.Error {
        case failedToFetch
    }

    public enum FeatureError: Swift.Error {
        case featureDoesNotExist(feature: Feature)
    }

    private let provider: FeatureToggleProvider

    private var features: [String: Bool] = [
        Feature.feature1.rawValue: false
    ]

    public init(provider: FeatureToggleProvider) {
        self.provider = provider
        self.provider.setup(with: features)
    }
}

extension FeatureToggle: FeatureToggleService {

    public func setup(completion: @escaping (SetupResult) -> Void) {
        provider.fetchFeatureToggles { [weak self] result in
            completion(
                result
                    .mapError { _ in  .failedToFetch }
                    .map { featureToggles in
                        self?.features = featureToggles
                    }
            )
        }
    }

    public func isFeatureEnabled(feature: Feature, completion: @escaping (FeatureEnabledResult) -> Void) {
        if let value = features[feature.rawValue] {
            completion(.success(value))
        } else {
            completion(.failure(.featureDoesNotExist(feature: feature)))
        }
    }
}
