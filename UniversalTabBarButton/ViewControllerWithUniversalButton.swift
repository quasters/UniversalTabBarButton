//
//  ViewController.swift
//  UniversalTabBarButton
//
//  Created by Наиль Буркеев on 19.01.2023.
//

import UIKit

class ViewControllerWithUniversalButton: UIViewController {
    
    // MARK: - UI Elements
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.backgroundColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        return tableView
    }()
    
    private lazy var universalTabBarButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(universalButtonAction), for: .touchUpInside)
        button.backgroundColor = .yellow
        
        button.layer.cornerRadius = universalTabBarButtonButtonDiameter / 2
        button.layer.masksToBounds = true
        
        button.setImage(UIImage(systemName: "plus")?.withRenderingMode(.alwaysOriginal).withTintColor(.black),
                        for: .normal)
        button.isHidden = true
        return button
    }()
    
    // MARK: - TabBar Properties
    private let universalTabBarButtonButtonDiameter = CGFloat(57)
    private let tabbarCutoutHeight = CGFloat(12)
    private var tabBarCutoutMaskDiameter: CGFloat {
        return universalTabBarButtonButtonDiameter + 14
    }
    private var tabBarShadowImage: UIImage?
    private var tabBarShadowColor: UIColor?
    private var tabBarBackgroundImage: UIImage?
    
    // MARK: - UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        maskTabBar()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateUniversalTabBarButtonFrame()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        backTabBarToDefaultState()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        setupTableView()
    }
    
    private func setupTableView() {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
    }
    
    // MARK: - UI Callbacks
    @objc
    private func universalButtonAction() {
        print("Universal Button was tapped")
    }
}



// MARK: - UITableViewDataSource
extension ViewControllerWithUniversalButton: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        cell.textLabel?.text = "Row \(indexPath.row)"
        return cell
    }
}



// MARK: - TabBar + universalTabBarButton Settings
extension ViewControllerWithUniversalButton {
    
    private func maskTabBar() {
        guard let tabBar = tabBarController?.tabBar,
              let tabBarItemsCount = tabBar.items?.count
        else { return }
        
        universalTabBarButton.isHidden = false
        
        let tabBarElementWidth = UIScreen.main.bounds.width / CGFloat(tabBarItemsCount)
        let xPosition = tabBarElementWidth * CGFloat(tabBarItemsCount - 1) - (tabBarCutoutMaskDiameter / 2)
        let yPosition = -tabBarCutoutMaskDiameter + tabbarCutoutHeight
        
        let maskLayer = CAShapeLayer()
        let path = CGMutablePath()
        
        path.addRect(tabBar.bounds)
        path.addEllipse(in: CGRect(x: xPosition, y: yPosition, width: tabBarCutoutMaskDiameter, height: tabBarCutoutMaskDiameter))
        
        maskLayer.path = path
        maskLayer.fillRule = .evenOdd
        
        tabBar.layer.mask = maskLayer
        
        tabBar.isTranslucent = true
        
        removeTabBarTopLine()
    }
    
    private func removeTabBarTopLine() {
        guard let tabBar = tabBarController?.tabBar else { return }
        
        if #available(iOS 13.0, *) {
            let appearance = tabBar.standardAppearance
            
            tabBarShadowImage = appearance.shadowImage
            tabBarShadowColor = appearance.shadowColor
            
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            
            tabBar.standardAppearance = appearance
        } else {
            tabBarShadowImage = tabBar.shadowImage
            tabBarBackgroundImage = tabBar.backgroundImage
            
            tabBar.shadowImage = UIImage()
            tabBar.backgroundImage = UIImage()
        }
    }
    
    private func updateUniversalTabBarButtonFrame() {
        guard let tabBar = tabBarController?.tabBar,
              let tabBarItemsCount = tabBar.items?.count
        else { return }
        
        let screenHeight = UIScreen.main.bounds.height
        let tabBarHeight = tabBar.frame.size.height
        let yPosition = screenHeight - tabBarHeight - tabBarCutoutMaskDiameter + (tabBarCutoutMaskDiameter - universalTabBarButtonButtonDiameter) / 2 + tabbarCutoutHeight
        
        let tabBarElementWidth = UIScreen.main.bounds.width / CGFloat(tabBarItemsCount)
        let xPosition = tabBarElementWidth * CGFloat(tabBarItemsCount - 1) - (universalTabBarButtonButtonDiameter / 2)
        
        universalTabBarButton.frame = CGRect(x: xPosition,
                                             y: yPosition,
                                             width: universalTabBarButtonButtonDiameter,
                                             height: universalTabBarButtonButtonDiameter)
        
        tabBarController?.view.addSubview(universalTabBarButton)
    }
    
    private func backTabBarToDefaultState() {
        guard let tabBar = tabBarController?.tabBar else { return }
        tabBar.layer.mask = nil
        
        if #available(iOS 13.0, *) {
            let appearance = tabBar.standardAppearance
            if let gShadowColor = tabBarShadowColor {
                appearance.shadowColor = gShadowColor
            }
            if let gShadowImage = tabBarShadowImage {
                appearance.shadowImage = gShadowImage
            }
            tabBar.standardAppearance = appearance
        } else {
            if let gShadowImage = tabBarShadowImage {
                tabBar.shadowImage = gShadowImage
            }
            if let gBackgroundImage = tabBarBackgroundImage {
                tabBar.backgroundImage = gBackgroundImage
            }
        }
        
        universalTabBarButton.isHidden = true
    }
}

