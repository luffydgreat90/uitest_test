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
    private var navigation: UINavigationController?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)

        let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(
                identifier: "ListViewController",
                creator: {
            [unowned self] coder in
            return ListViewController(
                coder: coder,
                viewModel: ViewModel(
                    imageStore: ImageStore(
                        urlSession: urlSession
                    ),
                    getCharacterHttp: getCharacters()
                )) { [unowned self] character in
                    navigateDetailViewController(character: character)
                }
        })

        navigation = UINavigationController(rootViewController: vc)
        
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
    
    private func navigateDetailViewController(character: Character) {
        let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(identifier: "DetailViewController") {   coder in
                
                return DetailViewController(coder: coder, character: character)
            }
        
        navigation?.pushViewController(vc, animated: true)
    }

    func getCharacters() -> CharacterHandler {

//        if let useMocks = ProcessInfo().environment["UITestUseMocks"], useMocks == "true" {
            return { complete in
                complete(Result {
                    return [Character(name: "Morty", status: "Alive", image: URL(string: "https://rickandmortyapi.com/api/character/avatar/2.jpeg")!)]
                })
           }
//        } else {
//            return self.characterStore.getCharacters
//        }
    }
}
