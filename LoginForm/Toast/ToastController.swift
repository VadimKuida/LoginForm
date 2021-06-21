//
//  ToastController.swift
//  LoginForm
//
//  Created by Вадим Куйда on 29.04.2021.
//

import UIKit

class ToastViewController: UIViewController {
    init(title: String, backgroundColor: UIColor) {
        super.init(nibName: nil, bundle: nil)

        transitioningDelegate = self
        
        modalPresentationStyle = .custom
        view.backgroundColor = backgroundColor
        view.alpha = 1
        let label = UILabel()
        label.text = title
        label.textAlignment  = .center
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 0

        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ToastViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ToastPresentationController(presentedViewController: presented, presenting: presenting  ?? source)
    }
}


class ToastPresentationController: PresentationControllerToast {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView,
            let presentedView = presentedView else { return .zero }

        let inset: CGFloat = 16

        // Make sure to account for the safe area insets
        let safeAreaFrame = containerView.bounds
            .inset(by: containerView.safeAreaInsets)

        let targetWidth = safeAreaFrame.width - 2 * inset
        let fittingSize = CGSize(
            width: targetWidth,
            height: UIView.layoutFittingCompressedSize.height
        )
        let targetHeight = presentedView.systemLayoutSizeFitting(
            fittingSize, withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow).height

        var frame = safeAreaFrame
        frame.origin.x += inset
        frame.origin.y += frame.size.height - targetHeight - inset  - 50
        frame.size.width = targetWidth
        frame.size.height = targetHeight
        
        

        return frame
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        containerView?.frame = CGRect(x: frameOfPresentedViewInContainerView.minX, y: frameOfPresentedViewInContainerView.minY - 80 , width: frameOfPresentedViewInContainerView.width, height: frameOfPresentedViewInContainerView.height + 200)
        presentedView?.layer.cornerRadius = 12
       
    }
}


class PresentationControllerToast: UIPresentationController {
    private var calculatedFrameOfPresentedViewInContainerView = CGRect.zero
    private var shouldSetFrameWhenAccessingPresentedView = false

    override var presentedView: UIView? {
        if shouldSetFrameWhenAccessingPresentedView {
            super.presentedView?.frame = calculatedFrameOfPresentedViewInContainerView
        }
        return super.presentedView
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        shouldSetFrameWhenAccessingPresentedView = completed
        
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        shouldSetFrameWhenAccessingPresentedView = false
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        calculatedFrameOfPresentedViewInContainerView = frameOfPresentedViewInContainerView
    }


}



