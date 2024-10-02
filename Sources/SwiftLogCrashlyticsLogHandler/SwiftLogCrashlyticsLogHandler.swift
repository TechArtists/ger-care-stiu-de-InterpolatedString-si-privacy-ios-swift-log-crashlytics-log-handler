// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import FirebaseCrashlytics
import Logging
import FirebaseCore

public struct SwiftLogCrashlyticsLogHandler: LogHandler {
    public var logLevel: Logger.Level = .trace
    public let label: String

    public init(label: String) {
        self.label = label
        FirebaseCore.FirebaseApp.configure()
    }

    public var metadata = Logger.Metadata() {
        didSet {
            self.prettyMetadata = prettify(self.metadata)
        }
    }
    
    private var prettyMetadata: String?

    /// Logs a message to Firebase Crashlytics with metadata and additional context.
    public func log(
        level: Logger.Level,
        message: Logger.Message,
        metadata: Logger.Metadata?,
        source: String,
        file: String,
        function: String,
        line: UInt
    ) {
        var combinedPrettyMetadata = self.prettyMetadata
        if let metadataOverride = metadata, !metadataOverride.isEmpty {
            combinedPrettyMetadata = self.prettify(
                self.metadata.merging(metadataOverride) { return $1 }
            )
        }
        
        var formedMessage = message.description
        
        if let combinedPrettyMetadata {
            formedMessage += " -- " + combinedPrettyMetadata
        }

        // Construct log message with additional context information
        let detailedMessage = "\(formedMessage) [File: \(file), Function: \(function), Line: \(line)]"
        
        // Log to Firebase Crashlytics
        Crashlytics.crashlytics().log(detailedMessage)
        
        // If the log level is error or critical, report the issue to Crashlytics.
        if level == .error || level == .critical {
            let error = NSError(
                domain: "com.example.CrashlyticsLogHandler",
                code: errorCodeForLogLevel(level),
                userInfo: [NSLocalizedDescriptionKey: detailedMessage]
            )
            Crashlytics.crashlytics().record(error: error)
        }
    }

    /// Retrieve or set metadata for logging.
    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            return self.metadata[metadataKey]
        }
        set {
            self.metadata[metadataKey] = newValue
        }
    }
    
    /// Helper function to format metadata into a readable string.
    private func prettify(_ metadata: Logger.Metadata) -> String? {
        if metadata.isEmpty {
            return nil
        }
        return metadata.map { "\($0)=\($1)" }.joined(separator: " ")
    }
    
    private func errorCodeForLogLevel(_ level: Logger.Level) -> Int {
        switch level {
        case .trace:
            return 0
        case .debug:
            return 1
        case .info:
            return 2
        case .notice:
            return 3
        case .warning:
            return 4
        case .error:
            return 5
        case .critical:
            return 6
        }
    }
}
