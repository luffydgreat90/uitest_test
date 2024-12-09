//
//  SceneDelegate.swift
//  testproj
//
//  Created by marlon von ansale on 01/12/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private lazy var urlSession: URLSession = URLSession(configuration: .ephemeral)
    private lazy var httpClient: HTTPClient = HTTPClient(urlSession: urlSession)
    private lazy var characterStore: CharacterStore = CharacterStore(getHandler: httpClient.get)

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)

        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ViewController", creator: { coder in
            return ViewController(coder: coder, viewModel: ViewModel(imageStore: ImageStore(urlSession: self.urlSession), getCharacterHttp: self.characterStore.getCharacters))
        })

        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}

