import Foundation
import OSLog

// MARK: - Log Category

/// Defines logging categories for different app subsystems
enum LogCategory: String, CaseIterable {
    case app = "App"
    case ui = "UI"
    case fileSystem = "FileSystem"
    case parsing = "Parsing"
    case navigation = "Navigation"

    /// The subsystem identifier for this category
    var subsystem: String {
        Bundle.main.bundleIdentifier ?? "com.openspecbuddy"
    }
}

// MARK: - Categorized Logger

/// A logger wrapper that provides categorized logging with OSLog integration
struct CategorizedLogger {
    let category: LogCategory
    private let logger: Logger
    private let osLog: OSLog

    init(category: LogCategory) {
        self.category = category
        self.logger = Logger(subsystem: category.subsystem, category: category.rawValue)
        self.osLog = OSLog(subsystem: category.subsystem, category: category.rawValue)
    }

    // MARK: - Logging Methods

    /// Log a debug message (only visible in Console.app when streaming, not persisted)
    func debug(_ message: String) {
        #if DEBUG
        logger.debug("\(message, privacy: .public)")
        #else
        logger.debug("[\(category.rawValue)] [DEBUG] \(message, privacy: .public)")
        #endif
    }

    /// Log an informational message
    func info(_ message: String) {
        #if DEBUG
        logger.info("\(message, privacy: .public)")
        #else
        logger.info("[\(category.rawValue)] [INFO] \(message, privacy: .public)")
        #endif
    }

    /// Log a notice/default level message
    func notice(_ message: String) {
        #if DEBUG
        logger.notice("\(message, privacy: .public)")
        #else
        logger.notice("[\(category.rawValue)] [NOTICE] \(message, privacy: .public)")
        #endif
    }

    /// Log an error message
    func error(_ message: String) {
        #if DEBUG
        logger.error("\(message, privacy: .public)")
        #else
        logger.error("[\(category.rawValue)] [ERROR] \(message, privacy: .public)")
        #endif
    }

    /// Log a fault message (for critical issues that should never occur)
    func fault(_ message: String) {
        #if DEBUG
        logger.fault("\(message, privacy: .public)")
        #else
        logger.fault("[\(category.rawValue)] [FAULT] \(message, privacy: .public)")
        #endif
    }

    // MARK: - Signpost Support

    /// Start a signpost interval for performance measurement
    /// - Parameter name: The name of the signpost interval
    /// - Returns: A signpost ID to use when ending the interval
    func startSignpost(name: StaticString) -> OSSignpostID {
        let signpostID = OSSignpostID(log: osLog)
        os_signpost(.begin, log: osLog, name: name, signpostID: signpostID)
        return signpostID
    }

    /// End a signpost interval
    /// - Parameters:
    ///   - name: The name of the signpost interval (must match the start call)
    ///   - signpostID: The signpost ID returned from startSignpost
    func endSignpost(name: StaticString, signpostID: OSSignpostID) {
        os_signpost(.end, log: osLog, name: name, signpostID: signpostID)
    }

    /// Emit a signpost event (single point in time)
    /// - Parameter name: The name of the signpost event
    func signpostEvent(name: StaticString) {
        os_signpost(.event, log: osLog, name: name)
    }
}

// MARK: - Logger Extension for Category Access

extension Logger {
    /// Logger for app lifecycle and general events
    static let app = CategorizedLogger(category: .app)

    /// Logger for UI-related events
    static let ui = CategorizedLogger(category: .ui)

    /// Logger for file system operations
    static let fileSystem = CategorizedLogger(category: .fileSystem)

    /// Logger for parsing operations
    static let parsing = CategorizedLogger(category: .parsing)

    /// Logger for navigation events
    static let navigation = CategorizedLogger(category: .navigation)

    /// Get a logger for a specific category
    /// - Parameter category: The logging category
    /// - Returns: A categorized logger instance
    static func `for`(_ category: LogCategory) -> CategorizedLogger {
        CategorizedLogger(category: category)
    }
}

// MARK: - OSLogType Description Extension

extension OSLogType: @retroactive CustomStringConvertible {
    public var description: String {
        switch self {
        case .debug:
            return "DEBUG"
        case .info:
            return "INFO"
        case .default:
            return "DEFAULT"
        case .error:
            return "ERROR"
        case .fault:
            return "FAULT"
        default:
            return "UNKNOWN"
        }
    }
}
