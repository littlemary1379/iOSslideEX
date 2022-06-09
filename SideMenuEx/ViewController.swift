//
//  ViewController.swift
//  SideMenuEx
//
//  Created by onnoffcompany on 2022/06/08.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var labelTest: UILabel!
    
    private var sideMenuViewController : SideMenuViewController!
    private var sideMenuRevealWidth : CGFloat = 260
    private let paddingForRotation : CGFloat = 150
    
    private var isExpended : Bool = false
    
    private var sideMenuTrailingConstraint : NSLayoutConstraint!
    
    private var revealSideMenuOnTop : Bool = true
    
    private var sideMenuShadowView : UIView!
    
    private var draggingIsEnable : Bool = false
    private var panBaseLocation : CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setListenter()
        
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        self.sideMenuViewController = storyBoard.instantiateViewController(withIdentifier: "SideMenuID") as! SideMenuViewController
        view.insertSubview(self.sideMenuViewController!.view, at: self.revealSideMenuOnTop ? 2 : 0)
        addChild(self.sideMenuViewController!)
        self.sideMenuViewController!.didMove(toParent: self)
        
        self.sideMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        if self.revealSideMenuOnTop {
            self.sideMenuTrailingConstraint = self.sideMenuViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -self.sideMenuRevealWidth-self.paddingForRotation)
            self.sideMenuTrailingConstraint.isActive = true
        }
        
        NSLayoutConstraint.activate([
            self.sideMenuViewController.view.widthAnchor.constraint(equalToConstant: self.sideMenuRevealWidth),
            self.sideMenuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.sideMenuViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        //showViewController(viewController: UINavigationController.self, storyboardId: "HomeNavID")
        
        //shadow ?
        self.sideMenuShadowView = UIView(frame: self.view.bounds)
        self.sideMenuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.sideMenuShadowView.backgroundColor = .black
        self.sideMenuShadowView.alpha = 0.0
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapGestureRecognizer))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
        if self.revealSideMenuOnTop {
            view.insertSubview(self.sideMenuShadowView, at: 1)
        }
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        panGestureRecognizer.delegate = self
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate { _ in
            if self.revealSideMenuOnTop {
                self.sideMenuTrailingConstraint.constant = self.isExpended ? 0 : (-self.sideMenuRevealWidth - self.paddingForRotation)
            }
            
        }
    }
    
    func setListenter() {
        labelTest.setOnTouchListener(self, action: #selector(onTouch))
    }
    
    
}

extension ViewController {
    
    @IBAction open func revealSideMenu() {
        self.sideMenuState(expanded: self.isExpended ? false : true)
    }
    
    @objc func onTouch() {
        print("??")
        revealSideMenu()
    }
    
    func showViewController<T: UIViewController>(viewController: T.Type, storyboardId : String) -> () {
        
        for subview in view.subviews {
            if subview.tag == 99 {
                subview.removeFromSuperview()
            }
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
        vc.view.tag = 99
        view.insertSubview(vc.view, at: self.revealSideMenuOnTop ? 0 : 1)
        addChild(vc)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vc.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            vc.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            vc.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            vc.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        if !self.revealSideMenuOnTop {
            
            if isExpended {
                vc.view.frame.origin.x = self.sideMenuRevealWidth
            }
            
            if self.sideMenuShadowView != nil {
                vc.view.addSubview(self.sideMenuShadowView)
            }
        }
        vc.didMove(toParent: self)
    }
    
    func sideMenuState(expanded : Bool) {
        if expanded {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? 0 : self.sideMenuRevealWidth) {_ in
                self.isExpended = true
            }
            UIView.animate(withDuration: 0.5) {self.sideMenuShadowView.alpha = 0.5}
         } else {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? (-self.sideMenuRevealWidth - self.paddingForRotation) : 0) {_ in
                self.isExpended = false
            }
             UIView.animate(withDuration: 0.5) {self.sideMenuShadowView.alpha = 0.0}
        }
    }
    
    func animateSideMenu(targetPosition : CGFloat, completion : @escaping (Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
            if self.revealSideMenuOnTop {
                self.sideMenuTrailingConstraint.constant = targetPosition
                self.view.layoutIfNeeded()
            } else {
                self.view.subviews[1].frame.origin.x = targetPosition
            }
        }, completion: completion)
    }
    
}

extension ViewController : UIGestureRecognizerDelegate {
    //shadow ?
    @objc func TapGestureRecognizer(sender : UITapGestureRecognizer) {
        if sender.state == .ended {
            if self.isExpended {
                self.sideMenuState(expanded: false)
            }
        }
    }
    
    @objc func handlePanGesture(sender : UIPanGestureRecognizer) {
        let position : CGFloat = sender.translation(in: self.view).x
        let velocity : CGFloat = sender.velocity(in: self.view).x
        
        switch sender.state {
        case.began:
            if velocity > 0, self.isExpended {
                sender.state = .cancelled
            }
            
            if velocity > 0, !self.isExpended {
                self.draggingIsEnable = true
            } else if velocity < 0, !self.isExpended {
                self.draggingIsEnable = true
            }
            
            if self.draggingIsEnable {
                let velocityThreshold : CGFloat = 550
                if abs(velocity) > velocityThreshold {
                    self.sideMenuState(expanded: self.isExpended ? false : true)
                    self.draggingIsEnable = false
                    return
                }
                
                if self.revealSideMenuOnTop {
                    self.panBaseLocation = 0.0
                    if self.isExpended {
                        self.panBaseLocation = self.sideMenuRevealWidth
                    }
                }
        
            }
        case .changed:
            
            if self.draggingIsEnable {
                if self.revealSideMenuOnTop {
                    let xLocation : CGFloat = self.panBaseLocation + position
                    let percentage = (xLocation * 150 / self.sideMenuRevealWidth) / self.sideMenuRevealWidth
                    let alpha = percentage >= 0.6 ? 0.6 : percentage
                    self.sideMenuShadowView.alpha = alpha
                    
                    if xLocation <= self.sideMenuRevealWidth {
                        self.sideMenuTrailingConstraint.constant = xLocation - sideMenuRevealWidth
                    }
                } else {
                    if let recogView = sender.view?.subviews[1] {
                        let percentage = (recogView.frame.origin.x * 150 / self.sideMenuRevealWidth) / self.sideMenuRevealWidth
                        let alpha = percentage >= 0.6 ? 0.6 : percentage
                        self.sideMenuShadowView.alpha = alpha
                        
                        if recogView.frame.origin.x <= self.sideMenuRevealWidth, recogView.frame.origin.x >= 0 {
                            recogView.frame.origin.x = recogView.frame.origin.x + position
                            sender.setTranslation(CGPoint.zero, in: view)
                        }
                    }
                }
            }
            
        case.ended:
            self.draggingIsEnable = false
            if self.revealSideMenuOnTop {
                let movedMoreThanHalf = self.sideMenuTrailingConstraint.constant > -(self.sideMenuRevealWidth*0.5)
                self.sideMenuState(expanded: movedMoreThanHalf)
            } else {
                if let recogView = sender.view?.subviews[1] {
                    let movedMoreThanHalf = recogView.frame.origin.x > self.sideMenuRevealWidth * 0.5
                    self.sideMenuState(expanded: movedMoreThanHalf)
                }
            }
            
        default: break
            
        }
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.sideMenuViewController.view))! {
            return false
        }
        return true
    }
}

extension UIViewController {
    
    func revealViewController() -> ViewController? {
        var viewController : UIViewController? = self
        
        if viewController != nil && viewController is ViewController {
            return viewController! as? ViewController
        }
        
        while (!(viewController is ViewController) && viewController?.parent != nil) {
            viewController = viewController?.parent
        }
        
        if viewController is ViewController {
            return viewController as? ViewController
        }
        
        return nil
    }
    
}

