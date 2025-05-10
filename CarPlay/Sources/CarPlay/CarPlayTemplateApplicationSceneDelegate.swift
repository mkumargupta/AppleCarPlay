//
//  CarPlayTemplateApplicationSceneDelegate.swift
//  CarPlay
//
//  Created by Apple on 09/05/25.
//

import CarPlay
import UIKit

class CarPlayTemplateApplicationSceneDelegate: NSObject, CPTemplateApplicationSceneDelegate {
    var interfaceController: CPInterfaceController?
    var window: CPWindow?
    
    
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didConnect interfaceController: CPInterfaceController) {
        
        self.interfaceController = interfaceController

        let viewModel = AppDIContainer.shared.makeSongListViewModel()
        let songs = viewModel.songs

        let listItems = songs.map { song -> CPListItem in
            let item = CPListItem(text: song.songname, detailText: song.artistname)
            item.handler = { selectedItem, completion in
                AlertManager.shared.showCombinedAlert(title: song.songname, interfaceController: interfaceController)
                NotificationCenter.default.post(name: .songSelected, object: song)
                completion()
            }
            return item
        }

        let section = CPListSection(items: listItems)
        let template = CPListTemplate(title: "Songs", sections: [section])

        interfaceController.setRootTemplate(template, animated: true) { _, error in
            if let error = error {
                print("Failed to set root template: \(error.localizedDescription)")
            }
        }
        
    }
    
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene,
                                  didDisconnectInterfaceController interfaceController: CPInterfaceController) {
        
    }
}
