//
//  CoreNavigation.swift
//  PlaySet
//
//  Created by Michael De La Cruz on 10/6/18.
//  Copyright © 2018 Michael De La Cruz. All rights reserved.
//

import UIKit

public protocol Configurable {
    associatedtype Configuration
    func configure(with configuration: Configuration)
}

extension Configurable where Self: UIViewController {
    init(with configuration: Configuration, nibName: String?, bundle: Bundle?) {
        self.init(nibName: nibName, bundle: bundle)
        configure(with: configuration)
    }
}

public typealias ConfigurableViewController = UIViewController & Configurable

public class CoreNavigation {
    var navigationDelegate: NavigationDelegate? = nil
    
    let navigationControllerType: UINavigationController.Type
    
    public init(navigationControllerType: UINavigationController.Type = UINavigationController.self) {
        self.navigationControllerType = navigationControllerType
    }
    
    public struct Destination {
        public typealias ViewControllerFactory = () -> UIViewController
        public typealias BeforePresentingBlock = (UIViewController) -> Void
        
        let beforePresenting: BeforePresentingBlock?
        let viewControllerFactory: ViewControllerFactory
        
        public init(beforePresenting: BeforePresentingBlock? = nil, factory: @escaping ViewControllerFactory) {
            self.beforePresenting = beforePresenting
            self.viewControllerFactory = factory
        }
        
        public static func destination<ViewController: UIViewController>
            (to viewControllerType: ViewController.Type,
             bundle: Bundle? = nil,
             beforePresenting: BeforePresentingBlock? = nil)
            -> Destination
        {
            let nibName = computeNibName(for: viewControllerType)
            return Destination(beforePresenting: beforePresenting) {
                ViewController(nibName: nibName, bundle: bundle)
            }
        }
        
        public static func configurableDestination<CVC: ConfigurableViewController>
            (to configurableViewControllerType: CVC.Type,
             with configuration: CVC.Configuration,
             beforePresenting: BeforePresentingBlock? = nil)
            -> Destination
        {
            let nibName = computeNibName(for: configurableViewControllerType)
            return Destination(beforePresenting: beforePresenting) {
                CVC(with: configuration, nibName: nibName, bundle: nil)
            }
        }
        
        public static func computeNibName(for viewControllerType: UIViewController.Type) -> String {
            let className = String(describing: viewControllerType)
            guard let controllerSubstringRange = className.range(of: "Controller") else {
                fatalError("cannot automatically create Destination for class that doesn't end in 'Controller'")
            }
            return String(className.prefix(upTo: controllerSubstringRange.lowerBound))
        }
    }
    
    public func reset(to destination: Destination, in window: UIWindow) {
        let type = navigationControllerType
        
        UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: {
            
            let vc = destination.viewControllerFactory()
            let navigationController = type.init(rootViewController: vc)
            navigationController.isNavigationBarHidden = true
            destination.beforePresenting?(vc)
            window.rootViewController = navigationController
            
        }, completion: nil)
    }
    
    public func go(to destination: Destination, from presentingViewController: UIViewController) {
        let viewController = destination.viewControllerFactory()
        destination.beforePresenting?(viewController)
        presentingViewController.show(viewController, sender: nil)
    }
    
    public func goBack(from viewController: UIViewController, animated: Bool = true, completion: (() -> Void)?) {
        if let navigationController = viewController.navigationController {
            navigationDelegate = NavigationDelegate { [weak self] in
                completion?()
                navigationController.delegate = nil
                self?.navigationDelegate = nil
            }
            navigationController.delegate = navigationDelegate
            navigationController.popViewController(animated: animated)
        } else if let presentingViewController = viewController.presentingViewController {
            presentingViewController.dismiss(animated: animated, completion: completion)
        } else {
            fatalError("unhandled 'goBack' call")
        }
    }
    
    class NavigationDelegate: NSObject, UINavigationControllerDelegate {
        typealias Completion = () -> Void
        private var completion: Completion
        init(completion: @escaping Completion) {
            self.completion = completion
        }
        
        func navigationController(_ navigationController: UINavigationController,
                                  didShow viewController: UIViewController,
                                  animated: Bool) {
            completion()
        }
    }
}


