//
//  WelcomeViewModel.swift
//  Mastodon
//
//  Created by Cirno MainasuK on 2021-9-15.
//

import Foundation
import Combine
import MastodonCore
import MastodonSDK

@MainActor
final class WelcomeViewModel {
 
    var disposeBag = Set<AnyCancellable>()
    
    // output
    @Published var needsShowDismissEntry = false
    
    init() {
        AuthenticationServiceProvider.shared.$mastodonAuthenticationBoxes
            .map { !$0.isEmpty }
            .assign(to: &$needsShowDismissEntry)
    }
}
