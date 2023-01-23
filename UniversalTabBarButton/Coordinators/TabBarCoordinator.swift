//
//  AppCoordinator.swift
//  UniversalTabBarButton
//
//  Created by Наиль Буркеев on 23.01.2023.
//

import UIKit

final class TabBarCoordinator {
    
    public var tabBarController: UITabBarController
    
    public var navigationController: UINavigationController
    
    private let fabric = Fabric()
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
        self.tabBarController.tabBar.backgroundColor = .white
        self.tabBarController.tabBar.tintColor = .black
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    public func start() {
        let pages: [TabBarPage] = [.title0, .title1, .title2, .title3]
        let controllers = pages.map({ getTabControllers($0) })
        prepareTabBarModule(withTabControllers: controllers)
    }
    
    public func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    public func currentPage() -> TabBarPage? {
        return TabBarPage.init(index: tabBarController.selectedIndex)
    }
    
    private func getTabControllers(_ page: TabBarPage) -> UINavigationController {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(false, animated: false)
        navController.tabBarItem = UITabBarItem(title: page.titleValue(),
                                                image: page.imageValue(isSelected: false),
                                                selectedImage: page.imageValue(isSelected: true))
        
        let vc = fabric.getTabBarVC(for: page)
        navController.pushViewController(vc, animated: true)
        
        return navController
    }
    
    private func prepareTabBarModule(withTabControllers tabControllers: [UIViewController]) {
        tabBarController.setViewControllers(tabControllers, animated: true)
        tabBarController.selectedIndex = TabBarPage.title0.pageOrderNumber()
        tabBarController.tabBar.isTranslucent = false
        navigationController.pushViewController(tabBarController, animated: true)
    }
}

final class Fabric {
    func getTabBarVC(for page: TabBarPage) -> UIViewController {
        switch page {
        case .title0:
            let vc = UIViewController()
            vc.view.backgroundColor = .red
            return vc
        case .title1:
            let vc = UIViewController()
            vc.view.backgroundColor = .orange
            return vc
        case .title2:
            return ViewControllerWithUniversalButton()
        case .title3:
            let vc = UIViewController()
            vc.view?.backgroundColor = .yellow
            return vc
        }
    }
}
