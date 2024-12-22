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

        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ViewController",
                                                                                   creator: {
            [unowned self] coder in
            return ViewController(
                coder: coder,
                viewModel: ViewModel(
                    imageStore: ImageStore(
                        urlSession: urlSession
                    ),
                    getCharacterHttp: getCharacters()
                )
            )
        })

        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }

    func getCharacters() -> CharacterHandler {
    #if DEBUG
        return { complete in
            complete(Result {
                return [Character(name: "Morty", image: URL(string: "https://rickandmortyapi.com/api/character/avatar/2.jpeg")!)]
            })
       }
        #elseif RELEASE
        return self.characterStore.getCharacters
    #endif

    }
}
