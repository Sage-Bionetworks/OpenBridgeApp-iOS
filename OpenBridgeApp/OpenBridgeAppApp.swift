//
//  OpenBridgeAppApp.swift
//

import SwiftUI
import BridgeClient
import BridgeClientExtension

// Include for the shared code for all flavors of this app
import SharedOpenBridgeApp

// Include Firebase for crashlytics support
import FirebaseCore
import FirebaseCrashlytics

// Included Assessments
import WashUArcWrapper_iOS

let kAppId = "private"

@main
class AppDelegate : OpenBridgeAppDelegate {
    override class var appId: String { kAppId }
    override class var pemPath: String { Bundle.module.path(forResource: kAppId, ofType: "pem")! }
    override class var backgroundProcessId: String { "org.sagebase.\(kAppId).upload" }
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Setup firebase app *before* setting up bridge manager
        FirebaseApp.configure()
        Logger.setLogWriter(CrashlyticsLogWriter())
        
        // Setup the Arc assessment manager
        ArcAssessmentManager.shared.onLaunch()
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

/// This allows setting up the plist with a scene that is built into the app even if the package is imported.
class SceneDelegate : OpenBridgeSceneDelegate<ContentView> {
}

class CrashlyticsLogWriter : IOSLogWriter {
    let identifier: String = "private"
    
    func setUserId(_ userId: String?) {
        #if DEBUG
        print("Crashlytics userId: \(userId ?? "NULL")")
        #else
        Crashlytics.crashlytics().setUserID(userId)
        #endif
    }
    
    func log(severity: LogSeverity, message: String?, tag: String?, error: Error?) {
        if let message = message {
            logInfo(severity: severity, tag: tag, message: message)
        }
        if let error = error {
            if severity.ordinal >= LogSeverity.error.ordinal {
                logError(error: error)
            }
            else {
                logInfo(severity: severity, tag: tag, message: error.localizedDescription)
            }
        }
    }
    
    func logError(error: Error) {
        #if DEBUG
        #else
        let nsError = (error as NSError)
        let reportError = NSError(domain: nsError.domain, code: nsError.code, userInfo: nsError.userInfo)
        Crashlytics.crashlytics().record(error: reportError)
        Crashlytics.crashlytics().sendUnsentReports()
        #endif
    }
    
    func logInfo(severity: LogSeverity, tag: String?, message: String) {
        #if DEBUG
        #else
        Crashlytics.crashlytics().log("\(tag ?? "Unknown") : \(severity.name.uppercased()) : \(message)")
        #endif
    }
    
    func addKeys(from dictionary: [String : Any]) {
        #if DEBUG
        print("Crashlytics keys: \(dictionary)")
        #else
        Crashlytics.crashlytics().setCustomKeysAndValues(dictionary)
        #endif
    }
}
