//
//  TabBarController.swift
//  LZLSLP
//
//  Created by user on 8/30/24.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabs = TabType.tabs()
        self.setViewControllers(tabs, animated: true)
    }
}

enum TabType: CaseIterable {
    case community
    case trending
    case donation
    
    
    func viewController() -> UIViewController {
        switch self {
        case .community:
            let viewController = CommunityViewController(
                baseView: CommunityView(),
                viewModel: CommunityViewModel()
            )
            return viewController
        case .trending:
            let viewController = TrendingViewController(
                baseView: TrendingView(),
                viewModel: TrendingViewModel()
            )
            return viewController
        case .donation:
            let viewController = DonationViewController(
                baseView: DonationView(),
                viewModel: DonationViewModel()
            )
            return viewController
        }
    }
    
    var tabImage: UIImage {
        switch self {
        case .community:
            UIImage(systemName: "chart.bar.doc.horizontal.fill")!
        case .trending:
            UIImage(systemName: "flame.circle.fill")!
        case .donation:
            UIImage(systemName: "cup.and.saucer.fill")!
        }
    }
    
    static func tabs() -> [UIViewController] {
        let allTabs = Self.allCases
        
        var viewControllers: [UIViewController] = []
        
        for tab in allTabs {
            let vc = UINavigationController(rootViewController: tab.viewController())
            vc.tabBarItem.image = tab.tabImage
            viewControllers.append(vc)
        }
        
        return viewControllers
    }
}
