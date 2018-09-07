//
//  GameLabel.swift
//  KCGameLabel
//
//  Created by Tran Vinh Kinh on 9/7/18.
//  Copyright © 2018 Tran Vinh Kinh. All rights reserved.
//

import UIKit

public enum GameLabelStyle {
    case none
    case bounce
    case fadedZoom
    case zoomInOut
    case flipHorizontal
    case flipVertical
    case rotateDown
    case rotateUp
    
    
    init(fromString str : String?) {
        if let s = str {
            switch s {
            case "none":
                self = .none
                break
            case "bounce":
                self = .bounce
                break
            case "fadedZoom":
                self = .fadedZoom
                break
            case "zoomInOut":
                self = .zoomInOut
                break
            case "flipHorizontal":
                self = .flipHorizontal
                break
            case "flipVertical":
                self = .flipVertical
                break
            case "rotateDown":
                self = .rotateDown
                break
            case "rotateUp":
                self = .rotateUp
                break
            default:
                self = .none
            }
        } else {
            self = .none
        }
    }
    
    func lowercaseString() -> String {
        switch self {
        case .none:
            return "none"
        case .bounce:
            return "bounce"
        case .fadedZoom:
            return "fadedZoom"
        case .zoomInOut:
            return "zoomInOut"
        case .flipHorizontal:
            return "flipHorizontal"
        case .flipVertical:
            return "flipVertical"
        case .rotateDown:
            return "rotateDown"
        case .rotateUp:
            return "rotateUp"
        }
    }
    
    func titleString() -> String {
        switch self {
        case .none:
            return "None"
        case .bounce:
            return "Bounce"
        case .fadedZoom:
            return "Faded Zoom"
        case .zoomInOut:
            return "Zoom In-Out"
        case .flipHorizontal:
            return "Flip Horizontal"
        case .flipVertical:
            return "Flip Vertical"
        case .rotateDown:
            return "Rotate Down"
        case .rotateUp:
            return "Rotate Up"
        }
    }
}

public class GameLabel : UIView {
    private let label = UILabel()               // Main label
    
    private let ghostLabel = UILabel()          // Label for doing animation
    private var valueArray : [String] = []      // Store array of label text value in case it change very fast
    
    private var animateTimer : Timer? = nil
    
    private var isLayoutFirstTime = true        // Check if view is layout first time of not
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.style = .none
        self.initGameLabelComponents()
    }
    
    init() {
        super.init(frame: .zero)
        
        self.style = .none
        self.initGameLabelComponents()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public static func initGameLabel(WithStyle s : GameLabelStyle) -> GameLabel{
        let gl = GameLabel()
        gl.style = s
        
        gl.initGameLabelComponents()
        
        return gl
    }
    
    private func initGameLabelComponents() {
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        
        self.label.backgroundColor = .clear
        self.label.textAlignment = .center
        self.addSubview(self.label)
        
        self.ghostLabel.backgroundColor = .clear
        self.ghostLabel.textAlignment = .center
        self.addSubview(self.ghostLabel)
        self.ghostLabel.isHidden = true
    }
    
    public var animateZoomScale = CGFloat(1.2) // zoom scale factor for zoom animations
    
    private var _animatedDuration = 0.1
    public var animatedDuration : Double {  // interval each animation, default is 0.25s
        get {
            return _animatedDuration
        }
        set {
            // animatedDuration cannot larger than animatedInterval
            // animatedInterval = animatedDuration + 0.05
            if newValue >= _animatedInterval {
                _animatedInterval = newValue + 0.05
                _animatedDuration = newValue
            }
            else {
                _animatedDuration = newValue
            }
        }
    }
    
    private var _animatedInterval = 0.25
    public var animatedInterval : Double {   // interval each animation, default is 0.25s
        get {
            return _animatedInterval
        }
        set {
            if newValue < 0.1 {
                // animatedInterval cannot be smaller than 0.1s
            }
            else if newValue < _animatedDuration + 0.05 {
                // animatedInterval cannot be smaller than animatedDuration
                _animatedInterval = _animatedDuration + 0.05
            }
            else {
                _animatedInterval = newValue
            }
        }
    }
    
    private var _style : GameLabelStyle = .none
    private var style : GameLabelStyle {     // Label style
        get {
            return self._style
        }
        set {
            self._style = newValue
            switch self._style {
            case .none:
                _animatedDuration = 0
                _animatedInterval = 0
                break
            case .bounce:
                self.animateZoomScale = 1.2
                _animatedDuration = 0.1
                _animatedInterval = 0.2
                break
            case .fadedZoom:
                self.animateZoomScale = 1.4
                _animatedDuration = 0.4
                _animatedInterval = 0.45
                break
            case .zoomInOut:
                self.animateZoomScale = 0
                _animatedDuration = 0.25
                _animatedInterval = 0.3
                break
            case .flipHorizontal:
                _animatedDuration = 0.25
                _animatedInterval = 0.3
                break
            case .flipVertical:
                _animatedDuration = 0.25
                _animatedInterval = 0.3
                break
            case .rotateDown:
                _animatedDuration = 0.25
                _animatedInterval = 0.3
                break
            case .rotateUp:
                _animatedDuration = 0.25
                _animatedInterval = 0.3
                break
            }
        }
    }
    
    public var text : String {
        get {
            return label.text ?? ""
        }
        set {
            self.changeLabelText(With: newValue)
        }
    }
    
    public func setLabelColor(color:UIColor) {
        self.label.textColor = color
        self.ghostLabel.textColor = color
    }
    
    public func setLabelFont(font:UIFont) {
        self.label.font = font
        self.ghostLabel.font = font
    }
    
        
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if self.isLayoutFirstTime == true {
            self.isLayoutFirstTime = false
            
            self.label.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            self.ghostLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    
    private func changeLabelText(With str : String) {
        if self.valueArray.count == 0 {
            self.valueArray.append(str)
            self.label.text = str
        }
        else {
            self.valueArray.append(str)
            
            if self.animateTimer == nil {
                self.animateChange(WithNewValue: str)
                
                self.startTimer()
            }
        }
    }
    
    private func startTimer() {
        self.animateTimer = Timer(timeInterval: self.animatedInterval,
                                  target: self,
                                  selector: #selector(fireTimer(sender:)),
                                  userInfo: nil,
                                  repeats: true)
        RunLoop.current.add(self.animateTimer!, forMode: .commonModes)
    }
    
    private func stopTimer() {
        if self.animateTimer != nil {
            self.animateTimer?.invalidate()
            self.animateTimer = nil
        }
    }
    
    @objc private func fireTimer(sender : Any) {
        if self.valueArray.count > 1 {
            let str = self.valueArray[1]
            self.animateChange(WithNewValue: str)
        }
        else {
            self.stopTimer()
        }
        
    }
    
    private func animateChange(WithNewValue v:String) {
        switch self.style {
        case .none:
            self.ghostLabel.isHidden = true
            self.label.text = v
            self.valueArray.remove(at: 0)
            break
        case .bounce:
            self.ghostLabel.isHidden = true
            self.label.text = v
            UIView.animate(withDuration: _animatedDuration, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6.0, options: .autoreverse, animations: {
                self.label.transform = CGAffineTransform(scaleX: self.animateZoomScale, y: self.animateZoomScale)
            }) { (result) in
                self.label.transform = CGAffineTransform.identity
                self.valueArray.remove(at: 0)
            }
            break
        case .fadedZoom:
            self.ghostLabel.isHidden = false
            self.ghostLabel.alpha = 0.0
            self.ghostLabel.text = v
            self.ghostLabel.transform = CGAffineTransform(scaleX: animateZoomScale, y: animateZoomScale)
            UIView.animate(withDuration: _animatedDuration, animations: {
                self.ghostLabel.transform = CGAffineTransform.identity
                self.ghostLabel.alpha = 1.0
                self.label.alpha = 0.0
            }) { (result) in
                self.ghostLabel.isHidden = true
                self.label.alpha = 1.0
                self.label.text = v
                self.valueArray.remove(at: 0)
            }
            break
        case .zoomInOut:
            self.ghostLabel.isHidden = false
            self.ghostLabel.alpha = 0.0
            self.ghostLabel.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.ghostLabel.text = v
            UIView.animate(withDuration: _animatedDuration, animations: {
                self.ghostLabel.transform = CGAffineTransform.identity
                self.ghostLabel.alpha = 1.0
                self.label.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                self.label.alpha = 0.0
            }) { (result) in
                self.ghostLabel.isHidden = true
                self.label.alpha = 1.0
                self.label.transform = CGAffineTransform.identity
                self.label.text = v
                self.valueArray.remove(at: 0)
            }
            break
        case .flipHorizontal:
            self.ghostLabel.isHidden = false
            self.ghostLabel.text = v
            self.ghostLabel.alpha = 0.0
            self.ghostLabel.transform = CGAffineTransform(scaleX: -1, y: 1)
            UIView.animate(withDuration: _animatedDuration, animations: {
                self.label.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.label.alpha = 0.0
                self.ghostLabel.transform = CGAffineTransform.identity
                self.ghostLabel.alpha = 1.0
            }) { (result) in
                self.label.text = v
                self.label.alpha = 1.0
                self.label.transform = CGAffineTransform.identity
                self.ghostLabel.isHidden = true
                self.valueArray.remove(at: 0)
            }
            break
        case .flipVertical:
            self.ghostLabel.isHidden = false
            self.ghostLabel.text = v
            self.ghostLabel.alpha = 0.0
            self.ghostLabel.transform = CGAffineTransform(scaleX: 1, y: -1)
            UIView.animate(withDuration: _animatedDuration, animations: {
                self.label.transform = CGAffineTransform(scaleX: 1, y: -1)
                self.label.alpha = 0.0
                self.ghostLabel.transform = CGAffineTransform.identity
                self.ghostLabel.alpha = 1.0
            }) { (result) in
                self.label.text = v
                self.label.alpha = 1.0
                self.label.transform = CGAffineTransform.identity
                self.ghostLabel.isHidden = true
                self.valueArray.remove(at: 0)
            }
            break
        case .rotateDown:
            self.ghostLabel.isHidden = false
            self.ghostLabel.alpha = 0.0
            self.ghostLabel.text = v
            
            let ghostLayer = self.ghostLabel.layer
            var ghostTransform : CATransform3D = CATransform3DIdentity
            ghostTransform.m34 = 1.0 / -500.0
            ghostTransform = CATransform3DRotate(ghostTransform, CGFloat(Double.pi/2), 1.0, 0.0, 0.0)
            ghostLayer.transform = ghostTransform
            
            let labelLayer = self.label.layer
            var labelTransform : CATransform3D = CATransform3DIdentity
            labelTransform.m34 = 1.0 / -500.0
            labelTransform = CATransform3DRotate(labelTransform, CGFloat(-Double.pi/2), 1.0, 0.0, 0.0)
            
            let halfDuration = _animatedDuration/2
            UIView.animate(withDuration: halfDuration, animations: {
                labelLayer.transform = labelTransform
                self.label.alpha = 0.0
                
            }) { (result) in
                UIView.animate(withDuration: halfDuration, animations: {
                    ghostTransform = CATransform3DRotate(ghostTransform, CGFloat(-Double.pi/2), 1.0, 0.0, 0.0)
                    ghostLayer.transform = ghostTransform
                    self.ghostLabel.alpha = 1.0
                    
                }) { (result) in
                    ghostTransform = CATransform3DIdentity
                    ghostLayer.transform = ghostTransform
                    self.ghostLabel.alpha = 1.0
                    self.ghostLabel.isHidden = true
                    
                    labelTransform = CATransform3DIdentity
                    labelLayer.transform = labelTransform
                    self.label.alpha = 1.0
                    self.label.text = v
                    
                    self.valueArray.remove(at: 0)
                }
            }
            break
        case .rotateUp:
            self.ghostLabel.isHidden = false
            self.ghostLabel.alpha = 0.0
            self.ghostLabel.text = v
            
            let ghostLayer = self.ghostLabel.layer
            var ghostTransform : CATransform3D = CATransform3DIdentity
            ghostTransform.m34 = 1.0 / -500.0
            ghostTransform = CATransform3DRotate(ghostTransform, CGFloat(-Double.pi/2), 1.0, 0.0, 0.0)
            ghostLayer.transform = ghostTransform
            
            let labelLayer = self.label.layer
            var labelTransform : CATransform3D = CATransform3DIdentity
            labelTransform.m34 = 1.0 / -500.0
            labelTransform = CATransform3DRotate(labelTransform, CGFloat(Double.pi/2), 1.0, 0.0, 0.0)
            
            let halfDuration = _animatedDuration/2
            UIView.animate(withDuration: halfDuration, animations: {
                labelLayer.transform = labelTransform
                self.label.alpha = 0.0
                
            }) { (result) in
                UIView.animate(withDuration: halfDuration, animations: {
                    ghostTransform = CATransform3DRotate(ghostTransform, CGFloat(Double.pi/2), 1.0, 0.0, 0.0)
                    ghostLayer.transform = ghostTransform
                    self.ghostLabel.alpha = 1.0
                    
                }) { (result) in
                    ghostTransform = CATransform3DIdentity
                    ghostLayer.transform = ghostTransform
                    self.ghostLabel.alpha = 1.0
                    self.ghostLabel.isHidden = true
                    
                    labelTransform = CATransform3DIdentity
                    labelLayer.transform = labelTransform
                    self.label.alpha = 1.0
                    self.label.text = v
                    
                    self.valueArray.remove(at: 0)
                }
            }
            break
        }
    }
}
