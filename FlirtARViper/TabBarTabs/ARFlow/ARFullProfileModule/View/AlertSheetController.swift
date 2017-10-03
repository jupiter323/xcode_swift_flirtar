//
//  AlertSheetController.swift
//  FlirtARViper
//
//  Created by on 06.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import XLActionController

open class YoutubeActionController: ActionController<AlertTitledCell, ActionData, UICollectionReusableView, Void, UICollectionReusableView, Void> {
    
    public override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        collectionViewLayout.minimumLineSpacing = -0.5
        
        settings.behavior.hideOnScrollDown = false
        settings.animation.scale = nil
        settings.animation.present.duration = 0.6
        settings.animation.dismiss.duration = 0.6
        settings.animation.dismiss.offset = 30
        settings.animation.dismiss.options = .curveLinear
        
        cellSpec = .nibFile(nibName: "AlertTitledCell", bundle: Bundle(for: AlertTitledCell.self), height: { _  in 54 })
        
        onConfigureCellForAction = { cell, action, indexPath in
            
            cell.setup(action.data?.title, detail: nil, image: nil)
            
            cell.alpha = action.enabled ? 1.0 : 0.5
            
            UIView.animate(withDuration: 0.30) {
            }
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class AlertTitledCell: ActionCell {
    
    open lazy var animatableBackgroundView: UIView = { [weak self] in
        let view = UIView(frame: self?.frame ?? CGRect.zero)
        view.backgroundColor = UIColor.red.withAlphaComponent(0.40)
        return view
        }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    func initialize() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        backgroundView.addSubview(animatableBackgroundView)
        selectedBackgroundView = backgroundView
        
    }
    
    open override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                animatableBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                animatableBackgroundView.frame = CGRect(x: 0, y: 0, width: 30, height: frame.height)
                animatableBackgroundView.center = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
                
                UIView.animate(withDuration: 0.5) { [weak self] in
                    guard let me  = self else {
                        return
                    }
                    
                    me.animatableBackgroundView.frame = CGRect(x: 0, y: 0, width: me.frame.width, height: me.frame.height)
                    me.animatableBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.08)
                }
            } else {
                animatableBackgroundView.backgroundColor = animatableBackgroundView.backgroundColor?.withAlphaComponent(0.0)
            }
        }
    }
}
