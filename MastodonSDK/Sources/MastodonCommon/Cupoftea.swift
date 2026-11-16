//
//  Cupoftea.swift
//  MastodonCommon
//
//  Single source of truth for Cupoftea.social branding and the one server this app talks to.
//

import Foundation

public enum Cupoftea {
    /// The only server this app signs up / logs in to.
    public static let domain = "cupoftea.social"
    /// User-facing app / brand name.
    public static let displayName = "Cupoftea.social"
    /// Custom URL scheme (OAuth callback, Open-In extension).
    public static let urlScheme = "cupoftea"
    public static let websiteURL = URL(string: "https://cupoftea.social")!
    public static let privacyPolicyURL = URL(string: "https://cupoftea.social/privacy-policy")!
    public static let donateURL = URL(string: "https://ko-fi.com/cupofteasocial")!
    public static let sourceCodeURL = URL(string: "https://github.com/WhiskeyOmega/COTS-ios")!
    public static let feedbackURL = URL(string: "https://github.com/WhiskeyOmega/COTS-ios/issues")!
}
