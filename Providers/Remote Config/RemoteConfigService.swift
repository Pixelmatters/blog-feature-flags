//
//  RemoteConfigService.swift
//  FeatureToggle
//

import Firebase

public class RemoteConfigService {

    private struct RemoteConfigFeatureData: Codable {
        var debug: Bool = false
        var qa: Bool = false
        var alpha: Bool = false
        var beta: Bool = false
        var release: Bool = false

        func toDictionary() -> [String: Bool] {
            guard let data = try? JSONEncoder().encode(self) else {
                preconditionFailure("Failed to convert \(self) to Data")
            }
            guard let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Bool] else {
                preconditionFailure("Failed to converto \(data) to JSON")
            }

            return dictionary
        }
    }

    private let remoteConfig: RemoteConfig
    private let environment: String

    private var defaultValues = [String: NSObject]()

    private static let fetchTimeout: Double = 10.0

    public init(for environment: String) {
        if FirebaseApp.app() == nil {
            let bundle = Bundle(for: RemoteConfigService.self)
            guard let path = bundle.path(forResource: "GoogleService-Info", ofType: "plist") else {
                preconditionFailure("File not found")
            }

            guard let options = FirebaseOptions(contentsOfFile: path) else {
                preconditionFailure("Invalid options")
            }

            FirebaseApp.configure(options: options)
        }

        self.remoteConfig = RemoteConfig.remoteConfig()

        let settings = RemoteConfigSettings()
        settings.fetchTimeout = Self.fetchTimeout
        self.remoteConfig.configSettings = settings

        self.environment = environment
    }

    private func fetchValues(completion: @escaping (FetchResult) -> Void) {
        var result = [String: Bool]()
        for entry in defaultValues {
            let data = self.remoteConfig.configValue(forKey: entry.key).dataValue

            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Bool]
                result[entry.key] = json?[environment] ?? false
            } catch {
                return completion(.failure(error))
            }
        }
        completion(.success(result))
    }
}

extension RemoteConfigService: FeatureToggleProvider {

    public func setup(with values: [String : Bool]) {
        var defaultValues = [String: NSData]()
        for value in values {
            var remoteConfigData = RemoteConfigFeatureData().toDictionary()
            remoteConfigData[environment] = value.value
            let data = try? JSONSerialization.data(withJSONObject: remoteConfigData) as NSData
            defaultValues[value.key] = data
        }
        self.defaultValues = defaultValues
        self.remoteConfig.setDefaults(defaultValues)
    }

    public func fetchFeatureToggles(completion: @escaping (FeatureToggleProvider.FetchResult) -> Void) {
        self.remoteConfig.fetchAndActivate { [weak self] _, error in
            if let error = error {
                return completion(.failure(error))
            }
            self?.fetchValues(completion: completion)
        }
    }

}
