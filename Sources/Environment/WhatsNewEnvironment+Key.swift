import SwiftUI

// MARK: - WhatsNewEnvironment+Key

public extension WhatsNewEnvironment {
    
    /// The WhatsNewEnvironment Key
    enum Key: EnvironmentKey {
        
        /// A fresh default environment. Override it with `EnvironmentValues.whatsNew`.
        public static var defaultValue: WhatsNewEnvironment {
            WhatsNewEnvironment()
        }
        
    }
    
}

// MARK: - EnvironmentValues+whatsNew

public extension EnvironmentValues {
    
    /// The WhatsNewEnvironment
    var whatsNew: WhatsNewEnvironment {
        get {
            self[WhatsNewEnvironment.Key.self]
        }
        set {
            self[WhatsNewEnvironment.Key.self] = newValue
        }
    }
    
}
