//
//  ActivityIndicatorButton.swift
//  JPC.ActivityIndicatorButton
//
//  Created by Jon Chmura on 3/9/15 (Happy Apple Watch Day!).
//  Copyright (c) 2015 Jon Chmura. All rights reserved.
//
/*
 The MIT License (MIT)
 Copyright (c) 2015 jpchmura
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit



private extension CGRect {
    
    var center: CGPoint {
        get {
            return CGPoint(x: self.midX, y: self.midY)
        }
    }
}

private extension UIColor {
    
    func colorWithSaturation(_ sat: CGFloat) -> UIColor {
        
        var hue: CGFloat = 0, satOld: CGFloat = 0, bright: CGFloat = 0, alpha: CGFloat = 0
        self.getHue(&hue, saturation: &satOld, brightness: &bright, alpha: &alpha)
        
        return UIColor(hue: hue, saturation: sat, brightness: bright, alpha: alpha)
    }
}




/**
 Defines the Style of the button.
 - Outline: For this style the button is clear. The image is tinted based on the current tint color. The button "track" outlines the image. This is comparible to the App Store download button.
 - Solid:   In this style the button has a solid background.  The background color is the current tint color and the image is tinted with the current foreground color. This is comparible to Google Material Design.
 */
public enum ActivityIndicatorButtonStyle {
    case outline, solid
}

/**
 Defines the state of the spinning and progress animations.
 - Inactive:   No activity. In this state the ActivityIndicatorButton acts only like a button.
 - Spinning:   A spinner analogous to UIActivityIndicator is animated around the bounds of the button.
 - Percentage: A circular progress bar surrounds the button. The value represents the percentage filled.
 */
public enum ActivityIndicatorButtonProgressBarStyle: Equatable {
    case inactive, spinning, percentage(value: Float)
}

/**
 *  This struct defines the current state of an ActivityIndicatorButton.
 */
public struct ActivityIndicatorButtonState: Equatable {
    
    /// An optional property to help identify this button. Does not effect rendering is any way. Must be set to use the "SavedStates" feature.
    public let name: String?
    
    /// If this is set it will override the tintColor property on the button.
    public var tintColor: UIColor?
    
    /// If this is set it will override the "normalTrackColor" property on the button.
    public var trackColor: UIColor?
    
    /// If this is set it will override the "normalforegroundColor" property on the button.
    public var foregroundColor: UIColor?
    
    /// Optionally provide an image for this state. It is centered in the button.
    public var image: UIImage?
    
    /// The activity state of the button.
    /// :see: ActivityIndicatorButtonProgressBarStyle
    public var progressBarStyle: ActivityIndicatorButtonProgressBarStyle
    
    /**
     Default initializer. No properties are required. All have default values.
     
     - parameter name:             Default value is nil
     - parameter tintColor:        Default value is nil
     - parameter trackColor:       Default value is nil
     - parameter foregroundColor:  Default value is nil
     - parameter image:            Default value is nil
     - parameter progressBarStyle: Default value is .Inactive
     */
    public init(name: String? = nil, tintColor: UIColor? = nil, trackColor: UIColor? = nil, foregroundColor: UIColor? = nil, image: UIImage? = nil, progressBarStyle: ActivityIndicatorButtonProgressBarStyle = .inactive) {
        self.name = name
        self.tintColor = tintColor
        self.trackColor = trackColor
        self.foregroundColor = foregroundColor
        self.image = image
        self.progressBarStyle = progressBarStyle
    }
    
    /**
     Convenience function to set the progressBarStyle to .Percentage(value: value)
     */
    public mutating func setProgress(_ value: Float) {
        self.progressBarStyle = .percentage(value: value)
    }
}



/*
 We need to have custom support for Equatable since on of our states has an input argument.
 */
public func == (lhs: ActivityIndicatorButtonProgressBarStyle, rhs: ActivityIndicatorButtonProgressBarStyle) -> Bool {
    switch lhs {
    case .inactive:
        switch rhs {
        case .inactive:
            return true
        default:
            return false
        }
        
    case .spinning:
        switch rhs {
        case .spinning:
            return true
        default:
            return false
        }
        
    case .percentage(let lhsValue):
        switch rhs {
        case .percentage(let rhsValue):
            return lhsValue == rhsValue
        default:
            return false
        }
    }
}

public func == (lhs: ActivityIndicatorButtonState, rhs: ActivityIndicatorButtonState) -> Bool {
    return lhs.tintColor == rhs.tintColor && lhs.trackColor == rhs.trackColor && lhs.image == rhs.image && lhs.progressBarStyle == rhs.progressBarStyle
}






@IBDesignable
open class ActivityIndicatorButton: UIControl {
    
    
    
    
    // MARK: - Public API
    
    
    open override var isEnabled: Bool {
        didSet {
            self.updateAllColors()
        }
    }
    
    
    
    // MARK: State
    
    /// Internal storage of activityState
    fileprivate var _activityState: ActivityIndicatorButtonState = ActivityIndicatorButtonState(progressBarStyle: .inactive)
    
    
    /// Set the ActivityIndicatorButtonState.
    /// You may set custom defined activity states or directly modify the values here.
    /// Animation is implicit. (i.e. this is equivalent to calling transitionActivityState(toState: animated: true)
    /// :see: transitionActivityState(toState:animated:)
    open var activityState: ActivityIndicatorButtonState {
        get {
            return _activityState
        }
        set {
            _activityState = newValue
            self.updateForNextActivityState(animated: true)
        }
    }
    
    /**
     Set activityState with optional animation
     
     :see: activityState
     */
    open func transitionActivityState(_ toState: ActivityIndicatorButtonState, animated: Bool = true) {
        self._activityState = toState
        self.updateForNextActivityState(animated: animated)
    }
    
    /// Returns the tintColor that is currently being used. If the current state provides no tint color self.tintColor is returned.
    /// :see: activityState
    /// :see: ActivityIndicatorButtonState
    open var tintColorForCurrentActivityState: UIColor {
        if let color = self.activityState.tintColor {
            return color
        }
        return self.tintColor
    }
    
    /// Returns the trackColor that is currently being used. If the current state provides no tint color self.normalTrackColor is returned.
    /// :see: activityState
    /// :see: ActivityIndicatorButtonState
    open var trackColorForCurrentActivityState: UIColor {
        if let color = self.activityState.trackColor {
            return color
        }
        return self.normalTrackColor
    }
    
    /// Returns the foregroundColor that is currently being used. If the current state provides no tint color self.normalForegroundColor is returned.
    /// :see: activityState
    /// :see: ActivityIndicatorButtonState
    open var foregroundColorForCurrentActivityState: UIColor {
        if let color = self.activityState.foregroundColor {
            return color
        }
        return self.normalForegroundColor
    }
    
    
    /// The color of the outline around the button. A track for the Progress Bar.
    /// This value may be overridden in ActivityIndicatorButtonState
    /// :see: activityState
    /// :see: ActivityIndicatorButtonState
    /// :see: trackColorForCurrentActivityState
    @IBInspectable open var normalTrackColor: UIColor = UIColor.lightGray {
        didSet {
            updateAllColors()
        }
    }
    
    
    /// The color of the image. Ignored when style == .Outline.
    /// This value may be overridden in ActivityIndicatorButtonState
    /// :see: activityState
    /// :see: ActivityIndicatorButtonState
    /// :see: foregroundColorForCurrentActivityState
    @IBInspectable open var normalForegroundColor: UIColor = UIColor.white {
        didSet {
            updateAllColors()
        }
    }
    
    
    /// Set the image of the current activityState
    /// This is equivalent to creating a new ActivityIndicatorButtonState and setting it to activityState
    /// :see: activityState
    /// :see: ActivityIndicatorButtonState
    @IBInspectable open var image: UIImage? {
        get {
            return self.activityState.image
        }
        set {
            self.activityState.image = newValue
        }
    }
    
    
    // MARK: State Animations
    
    /// Defines the length of the animation for ActivityState transitions.
    open var animationDuration: CFTimeInterval = 0.2
    
    /// The timing function for ActivityState transitions.
    open var animationTimingFunction: CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    
    
    
    
    // MARK: Hit Ripple Animation
    
    /// The distance past the edge of the button which the ripple animation will propagate on touch up and touch down
    @IBInspectable open var hitAnimationDistance: CGFloat = 5.0
    
    /// The duration of the ripple hit animation
    @IBInspectable open var hitAnimationDuration: CFTimeInterval = 0.5
    
    /// The color of the touch down and touch up ripple animation. Default value is UIColor.grayColor().colorWithAlphaComponent(0.5).
    @IBInspectable open var hitAnimationColor: UIColor = UIColor.gray.withAlphaComponent(0.5)
    
    
    
    // MARK: Style
    
    /// The color of the drop shadow or UIColor.clearColor() if you do not wish to display a shadow. The shadow never drawn is useSolidColorButtons is false.
    /// :see: useSolidColorButtons
    @IBInspectable open var shadowColor: UIColor = UIColor.black
    
    
    /// If true the circular background of this control is colored with the tint color and the image is colored white. Otherwise the background is clear and the image is tinted. Image color is only adjusted if it is a template image.
    /// :see: ActivityIndicatorButtonStyle
    @IBInspectable open var style: ActivityIndicatorButtonStyle = .solid {
        didSet {
            self.updateAllColors()
        }
    }
    
    
    
    
    
    // MARK: UI Configuration
    
    /// The width of the circular progress bar / activity indicator
    @IBInspectable open var progressBarWidth: CGFloat = 3 {
        didSet {
            self.updateButtonConstains()
            self.updateForCurrentBounds()
        }
    }
    
    /// The width of the track outline separating the progress bar from the button
    @IBInspectable open var trackWidth: CGFloat = 1.5 {
        didSet {
            self.updateButtonConstains()
            self.updateForCurrentBounds()
        }
    }
    
    /// The minimum amount of padding between the image and the side of the button
    @IBInspectable open var minimumImagePadding: CGFloat = 5 {
        didSet {
            self.updateButtonConstains()
            self.updateForCurrentBounds()
        }
    }
    
    
    
    
    
    
    // MARK: - State Management
    
    /// Internal storage of saved states
    fileprivate var savedStates: [String : ActivityIndicatorButtonState] = [:]
    
    /// The number of ActivityIndicatorButtonState stored
    open var savedStatesCount: Int {
        return savedStates.count
    }
    
    /**
     Store an ActivityIndicatorButtonState for simple access
     
     - parameter name: The key used to store the state. It doesn't have to be equal to state.name but it is probably good practice. For this API the name property on state is not required.
     
     - returns: The ActivityIndicatorButtonState or nil if a saved state could not be found.
     */
    open subscript (name: String) -> ActivityIndicatorButtonState? {
        get {
            return savedStates[name]
        }
        set {
            savedStates[name] = newValue
        }
    }
    
    /**
     Convenience API for saving a group of states.
     
     - parameter states: An array of states. The name property MUST be set.  If not an assertion is triggered.  The states are keyed based on the value of "name".
     */
    open func saveStates(_ states: [ActivityIndicatorButtonState]) {
        for aState in states {
            assert(aState.name != nil, "All saved states must have a name")
            self[aState.name!] = aState
        }
    }
    
    /**
     Convenience API for setting a saved state. Equivalent to button.activityState = button["name of state"]
     
     - parameter name:     The key used to access the saved state
     - parameter animated: If animated is desired
     
     - returns: True is the state was found in saved states.
     */
    open func transitionSavedState(_ name: String, animated: Bool = true) -> Bool {
        if let state = self[name] {
            self.transitionActivityState(state, animated: animated)
            return true
        }
        return false
    }
    
    
    
    
    
    
    
    // MARK: - Initialization
    
    public init() {
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    fileprivate func commonInit() {
        initialLayoutSetup()
        updateAllColors()
        updateForNextActivityState(animated: false)
        
        // Observe touch down and up for fire ripple animations
        self.addTarget(self, action: #selector(ActivityIndicatorButton.handleTouchUp(_:)), for: .touchUpInside)
        self.addTarget(self, action: #selector(ActivityIndicatorButton.handleTouchDown(_:)), for: .touchDown)
    }
    
    
    
    
    struct Constants {
        struct Layout {
            static let outerPadding: CGFloat = 1
            /// The intrinsicContentSize if no images are provided. If images are provided this is the intrinsicContentSize.
            static let defaultContentSize: CGSize = CGSize(width: 35.0, height: 35.0)
        }
        struct Track {
            static let StartAngle = CGFloat(-M_PI_2)  // Start angle is pointing directly upwards on the screen. This is where progress animations will begin
            static let EndAngle = CGFloat(3 * M_PI_2)
        }
    }
    
    
    
    // MARK: - IBDesignable
    open override func prepareForInterfaceBuilder() {
        // TODO: Improve rendering for interface builder preview
    }
    
    
    
    
    
    // MARK: - State Animations
    
    
    /// Holds the currently rendered State
    fileprivate var renderedActivityState: ActivityIndicatorButtonState?
    
    /**
     Does the real work of transitioning from one ActivityState to the next. If previous state is set will also update out of that state.
     */
    fileprivate func updateForNextActivityState(animated: Bool) {
        
        struct DisplayState {
            let trackVisible: Bool
            let progressBarVisible: Bool
            let tintColor: UIColor
            let trackColor: UIColor
            let image: UIImage?
            let progressBarStyle: ActivityIndicatorButtonProgressBarStyle
        }
        
        
        var nextDisplayState = DisplayState(
            trackVisible: style == .solid || activityState.progressBarStyle != .spinning,
            progressBarVisible: activityState.progressBarStyle != .inactive,
            tintColor: tintColorForCurrentActivityState,
            trackColor: trackColorForCurrentActivityState,
            image: activityState.image,
            progressBarStyle: activityState.progressBarStyle)
        
        var prevDisplayState = DisplayState(
            trackVisible: backgroundView.shapeLayer.opacity > 0.5,
            progressBarVisible: progressView.progressLayer.opacity > 0.5,
            tintColor: UIColor(cgColor: (self.style == .solid ? backgroundView.shapeLayer.fillColor : backgroundView.shapeLayer.strokeColor)!),
            trackColor: UIColor(cgColor: backgroundView.shapeLayer.strokeColor!),
            image: imageView.image,
            progressBarStyle: renderedActivityState != nil ? renderedActivityState!.progressBarStyle : .inactive)
        
        
        
        // Progress View and Background View animations
        struct OpacityAnimation {
            let toValue: Float
            let fromValue: Float
            
            init(hidden: Bool) {
                self.toValue = hidden ? 0.0 : 1.0
                self.fromValue = hidden ? 1.0 : 0.0
            }
            
            func addToLayer(_ layer: CALayer, duration: CFTimeInterval, function: CAMediaTimingFunction) {
                let opacityanim = CABasicAnimation(keyPath: "opacity")
                opacityanim.toValue = self.toValue
                opacityanim.fromValue = self.fromValue
                opacityanim.duration = duration
                opacityanim.timingFunction = function
                layer.add(opacityanim, forKey: "opacity")
                
                layer.opacity = toValue
            }
            
            func setNoAnimation(_ layer: CALayer) {
                CATransaction.begin()
                CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
                layer.opacity = toValue
                CATransaction.commit()
            }
        }
        
        var trackOpacity = OpacityAnimation(hidden: !nextDisplayState.trackVisible)
        var progressOpacity = OpacityAnimation(hidden: !nextDisplayState.progressBarVisible)
        
        // Only animate if value has changed
        let shouldAnimateTrack = animated && prevDisplayState.trackVisible != nextDisplayState.trackVisible
        let shouldAnimateProgressBar = animated && prevDisplayState.progressBarVisible != prevDisplayState.progressBarVisible
        let shouldAnimateImage = animated && prevDisplayState.image != nextDisplayState.image
        
        if shouldAnimateTrack {
            trackOpacity.addToLayer(self.backgroundView.shapeLayer, duration: self.animationDuration, function: self.animationTimingFunction)
        }
        else {
            trackOpacity.setNoAnimation(self.backgroundView.shapeLayer)
        }
        
        if shouldAnimateProgressBar {
            progressOpacity.addToLayer(self.progressView.progressLayer, duration: self.animationDuration, function: self.animationTimingFunction)
        }
        else {
            progressOpacity.setNoAnimation(self.progressView.progressLayer)
        }
        
        
        
        // A helper to get a "compressed" path represented by a single point at the center of the existing path.
        func compressPath(_ path: CGPath) -> CGPath {
            let bounds = path.boundingBoxOfPath
            let center = CGPoint(x: bounds.midX, y: bounds.midY)
            return UIBezierPath(arcCenter: center, radius: 0.0, startAngle: 0.0, endAngle: CGFloat(M_PI * 2), clockwise: true).cgPath
        }
        
        
        
        // Color transition for "useSolidColorButtons"
        // If the tint color is different between 2 states we animate the change by expanding the new color from the center of the button
        if prevDisplayState.tintColor != nextDisplayState.tintColor && self.style == .solid  {
            
            // The transition layer provides the expanding color change in the state transition. The background view color isn't updating until completing this expand animation
            let transitionLayer = CAShapeLayer()
            transitionLayer.path = self.backgroundLayerPath
            
            CATransaction.begin()
            CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            transitionLayer.fillColor = nextDisplayState.tintColor.cgColor
            CATransaction.commit()
            
            self.backgroundView.layer.addSublayer(transitionLayer)
            
            let completion = { () -> Void in
                
                transitionLayer.removeFromSuperlayer()
                self.updateAllColors()
            }
            
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            
            let bgAnim = CABasicAnimation(keyPath: "path")
            bgAnim.fromValue = compressPath(self.backgroundLayerPath)
            bgAnim.toValue = self.backgroundLayerPath
            bgAnim.duration = self.animationDuration
            bgAnim.timingFunction = self.animationTimingFunction
            
            transitionLayer.add(bgAnim, forKey: "bg_expand")
            
            CATransaction.commit()
        }
        else {
            self.updateAllColors()
        }
        
        
        
        
        // Update the image before we drive the animations
        self.setImage(nextDisplayState.image)
        
        // If image has changed and we're animating...
        // For image animations we reveal the new image from the center by expanding its mask
        if shouldAnimateImage {
            
            // Image mask expand
            let imageAnim = CABasicAnimation(keyPath: "path")
            imageAnim.fromValue = compressPath(self.imageViewMaskPath)
            imageAnim.toValue = self.imageViewMaskPath
            imageAnim.duration = self.animationDuration
            imageAnim.timingFunction = self.animationTimingFunction
            
            self.imageViewMask.add(imageAnim, forKey: "image_expand")
        }
        else {
            updateAllColors()
        }
        
        
        // Restart / adjust progress view if needed
        self.updateSpinningAnimation()
        
        switch prevDisplayState.progressBarStyle {
        case .percentage(let value):
            self.updateProgress(fromValue: value, animated: animated)
            
        default:
            self.updateProgress(fromValue: 0, animated: animated)
        }
        
        
        // Update the image constraints
        updateButtonConstains()
        
        // Finally update our current activity state
        self.renderedActivityState = activityState
    }
    
    
    
    fileprivate func updateProgress(fromValue prevValue: Float, animated: Bool) {
        switch self.activityState.progressBarStyle {
        case .percentage(let value):
            
            if animated {
                let anim = CABasicAnimation(keyPath: "strokeEnd")
                anim.fromValue = prevValue
                anim.toValue = value
                anim.duration = self.animationDuration
                anim.timingFunction = self.animationTimingFunction
                self.progressView.progressLayer.add(anim, forKey: "progress")
                
                self.progressView.progressLayer.strokeEnd = CGFloat(value)
            }
            else {
                CATransaction.begin()
                CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
                self.progressView.progressLayer.strokeEnd = CGFloat(value)
                CATransaction.commit()
            }
            
        default:
            break
        }
    }
    
    
    /// This replicates the Google style activity spinner from Material Design
    fileprivate func updateSpinningAnimation() {
        
        let kStrokeAnim = "spinning_stroke"
        let kRotationAnim = "spinning_rotation"
        
        self.progressView.progressLayer.removeAnimation(forKey: kStrokeAnim)
        self.progressView.progressLayer.removeAnimation(forKey: kRotationAnim)
        if self.activityState.progressBarStyle == .spinning {
            
            // The animation is broken into stages that execute in order. All animations in "stage 1" execute simultaneously followed by animations in "stage 2"
            // "Head" refers to the strokeStart which is trailing behind the animation (i.e. the animation is moving clockwise away from the head)
            // "Tail refers to the strokeEnd which is leading the animation
            
            let stage1Time = 0.9
            let pause1Time = 0.05
            let stage2Time = 0.6
            let pause2Time = 0.05
            let stage3Time = 0.1
            
            var animationTime = stage1Time
            
            // Stage1: The circle begins life empty, nothing is stroked.  The tail moves ahead to travel the circumference of the circle. The head follows but lags behind 75% of the circumference. Now 75% of the circles circumference is stroked.
            
            let headStage1 = CABasicAnimation(keyPath: "strokeStart")
            headStage1.fromValue = 0.0
            headStage1.toValue = 0.25
            headStage1.duration = animationTime
            
            let tailStage1 = CABasicAnimation(keyPath: "strokeEnd")
            tailStage1.fromValue = 0.0
            tailStage1.toValue = 1.0
            tailStage1.duration = animationTime
            
            // Pause1: Maintain state from stage 1 for a moment
            let headPause1 = CABasicAnimation(keyPath: "strokeStart")
            headPause1.fromValue = 0.25
            headPause1.toValue = 0.25
            headPause1.beginTime = animationTime
            headPause1.duration = pause1Time
            
            let tailPause1 = CABasicAnimation(keyPath: "strokeEnd")
            tailPause1.fromValue = 1.0
            tailPause1.toValue = 1.0
            tailPause1.beginTime = animationTime
            tailPause1.duration = pause1Time
            
            animationTime += pause1Time
            
            // Stage2: The head whips around the circle to almost catch up with the tail. The tail stays at the end of the circle. Now 10% of the circles circumference is stroked.
            let headStage2 = CABasicAnimation(keyPath: "strokeStart")
            headStage2.fromValue = 0.25
            headStage2.toValue = 0.9
            headStage2.beginTime = animationTime
            headStage2.duration = stage2Time
            
            let tailStage2 = CABasicAnimation(keyPath: "strokeEnd")
            tailStage2.fromValue = 1.0
            tailStage2.toValue = 1.0
            tailStage2.beginTime = animationTime
            tailStage2.duration = stage2Time
            
            animationTime += stage2Time
            
            // Pause2: Maintain state from Stage2 for a moment.
            let headPause2 = CABasicAnimation(keyPath: "strokeStart")
            headPause2.fromValue = 0.9
            headPause2.toValue = 0.9
            headPause2.beginTime = animationTime
            headPause2.duration = pause2Time
            
            let tailPause2 = CABasicAnimation(keyPath: "strokeEnd")
            tailPause2.fromValue = 1.0
            tailPause2.toValue = 1.0
            tailPause2.beginTime = animationTime
            tailPause2.duration = pause2Time
            
            animationTime += pause2Time
            
            // Stage3: The head moves to 100% the circumference to finally catch up with the tail which remains stationary. Now none of the circle is stroked and we are back at the starting state.
            let headStage3 = CABasicAnimation(keyPath: "strokeStart")
            headStage3.fromValue = 0.9
            headStage3.toValue = 1.0
            headStage3.beginTime = animationTime
            headStage3.duration = stage3Time
            
            let tailStage3 = CABasicAnimation(keyPath: "strokeEnd")
            tailStage3.fromValue = 1.0
            tailStage3.toValue = 1.0
            tailStage3.beginTime = animationTime
            tailStage3.duration = stage3Time
            
            animationTime += stage3Time
            
            let group = CAAnimationGroup()
            group.repeatCount = Float.infinity
            group.duration = animationTime
            group.animations = [headStage1, tailStage1, headPause1, tailPause1, headStage2, tailStage2, headPause2, tailPause2, headStage3, tailStage3]
            
            self.progressView.progressLayer.add(group, forKey: kStrokeAnim)
            
            let rotationAnim = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnim.fromValue = 0
            rotationAnim.toValue = 2 * M_PI
            rotationAnim.duration = 3.0
            rotationAnim.repeatCount = Float.infinity
            
            self.progressView.progressLayer.add(rotationAnim, forKey: kRotationAnim)
        }
    }
    
    
    // MARK: - Theming
    
    override open func tintColorDidChange() {
        super.tintColorDidChange()
        
        updateAllColors()
    }
    
    fileprivate func updateButtonColors() {
        
        var tintColor = self.tintColorForCurrentActivityState
        var foregroundColor = self.foregroundColorForCurrentActivityState
        
        if !isEnabled {
            tintColor = tintColor.colorWithSaturation(0.2)
            foregroundColor = foregroundColor.colorWithSaturation(0.2)
        }
        
        switch self.style {
        case .outline:
            self.backgroundView.shapeLayer.fillColor = UIColor.clear.cgColor
            self.imageView.tintColor = tintColor
            self.dropShadowLayer.shadowColor = UIColor.clear.cgColor
            
        case .solid:
            self.backgroundView.shapeLayer.fillColor = tintColor.cgColor
            self.imageView.tintColor = foregroundColor
            self.dropShadowLayer.shadowColor = self.shadowColor.cgColor
        }
    }
    
    fileprivate func updateTrackColors() {
        
        var tintColor = self.tintColorForCurrentActivityState
        
        if !isEnabled {
            tintColor = tintColor.colorWithSaturation(0.2)
        }
        
        let trackColor = self.trackColorForCurrentActivityState.cgColor
        let clear = UIColor.clear.cgColor
        
        self.progressView.progressLayer.strokeColor = tintColor.cgColor
        self.progressView.progressLayer.fillColor = clear
        
        self.backgroundView.shapeLayer.strokeColor = trackColor
    }
    
    fileprivate func updateAllColors() {
        self.updateButtonColors()
        self.updateTrackColors()
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - UI (Private)
    
    /*
     We are wrapping all our layers in views for easier arrangment.
     */
    
    fileprivate class BackgroundView: UIView {
        
        var shapeLayer: CAShapeLayer {
            get {
                return self.layer as! CAShapeLayer
            }
        }
        
        override class var layerClass : AnyClass {
            return CAShapeLayer.self
        }
        
    }
    
    fileprivate class ProgressView: UIView {
        
        var progressLayer: CAShapeLayer {
            get {
                return self.layer as! CAShapeLayer
            }
        }
        
        override class var layerClass : AnyClass {
            return CAShapeLayer.self
        }
        
    }
    
    /// The layer from which to draw the button shadow
    fileprivate var dropShadowLayer: CALayer {
        get {
            return self.layer
        }
    }
    
    fileprivate lazy var imageView: UIImageView = UIImageView()
    
    fileprivate lazy var imageViewMask: CAShapeLayer = CAShapeLayer()
    
    fileprivate lazy var backgroundView: BackgroundView = BackgroundView()
    
    fileprivate lazy var progressView: ProgressView = ProgressView()
    
    
    fileprivate func setImage(_ image: UIImage?) {
        self.imageView.image = image
        self.imageView.sizeToFit()
    }
    
    
    
    
    
    
    
    // MARK: - Layout
    
    fileprivate var progressLayerPath: CGPath {
        get {
            let progressRadius = min(self.progressView.frame.width, self.progressView.frame.height) * 0.5
            return UIBezierPath(
                arcCenter: self.progressView.bounds.center,
                radius: progressRadius - progressBarWidth * 0.5,
                startAngle: Constants.Track.StartAngle,
                endAngle: Constants.Track.EndAngle,
                clockwise: true).cgPath
        }
    }
    
    fileprivate var backgroundLayerPathRadius: CGFloat {
        get {
            return min(self.backgroundView.frame.width, self.backgroundView.frame.height) * 0.5
        }
    }
    
    fileprivate var backgroundLayerPath: CGPath {
        get {
            return UIBezierPath(arcCenter: self.backgroundView.bounds.center, radius: self.backgroundLayerPathRadius, startAngle: Constants.Track.StartAngle, endAngle: Constants.Track.EndAngle, clockwise: true).cgPath
        }
    }
    
    fileprivate var imageViewMaskPath: CGPath {
        get {
            return UIBezierPath(arcCenter: self.imageView.bounds.center, radius: self.backgroundLayerPathRadius, startAngle: Constants.Track.StartAngle, endAngle: Constants.Track.EndAngle, clockwise: true).cgPath
        }
    }
    
    fileprivate var shadowPath: CGPath {
        get {
            return UIBezierPath(arcCenter: self.bounds.center, radius: self.backgroundLayerPathRadius, startAngle: Constants.Track.StartAngle, endAngle: Constants.Track.EndAngle, clockwise: true).cgPath
        }
    }
    
    // The "INNER" padding is the distance between the background and the track. Have to add the width of the progress and the half of the track (the track is the stroke of the background view)
    fileprivate var innerPadding: CGFloat {
        return Constants.Layout.outerPadding + progressBarWidth + 0.5 * trackWidth
    }
    
    fileprivate var buttonConstraints = [NSLayoutConstraint]()
    
    /**
     Should be called once and only once. Adds layers to view heirarchy.
     */
    fileprivate func initialLayoutSetup() {
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.progressView.translatesAutoresizingMaskIntoConstraints = false
        
        self.imageView.backgroundColor = UIColor.clear
        self.backgroundView.backgroundColor = UIColor.clear
        self.progressView.backgroundColor = UIColor.clear
        
        self.imageView.isUserInteractionEnabled = false
        self.backgroundView.isUserInteractionEnabled = false
        self.progressView.isUserInteractionEnabled = false
        
        self.backgroundColor = UIColor.clear
        
        self.addSubview(self.backgroundView)
        self.addSubview(self.imageView)
        self.addSubview(self.progressView)
        
        let views = ["progress" : self.progressView]
        let metrics = ["OUTER" : Constants.Layout.outerPadding]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(OUTER)-[progress]-(OUTER)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(OUTER)-[progress]-(OUTER)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: views))
        
        self.addConstraint(NSLayoutConstraint(item: self.imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        
        updateButtonConstains()
        
        // Set up imageViewMask
        
        self.imageViewMask.fillColor = UIColor.white.cgColor
        self.imageView.layer.mask = self.imageViewMask
        
        // Set up drop shadow
        let layer = self.dropShadowLayer
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 2.5
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
    }
    
    /**
     The button constraints may change if progress bar or track width is changed. This method will handle updates
     */
    fileprivate func updateButtonConstains() {
        
        // Clear old constraints
        self.removeConstraints(buttonConstraints)
        buttonConstraints.removeAll()
        
        let views = ["bg" : self.backgroundView, "image" : imageView] as [String : Any]
        let metrics = ["INNER" : innerPadding, "IMAGE_PAD" : innerPadding + minimumImagePadding]
        
        buttonConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(INNER)-[bg]-(INNER)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: views)
        buttonConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(INNER)-[bg]-(INNER)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: views)
        
        buttonConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(IMAGE_PAD)-[image]-(IMAGE_PAD)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: views)
        buttonConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(IMAGE_PAD)-[image]-(IMAGE_PAD)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: views)
        
        self.addConstraints(buttonConstraints)
    }
    
    /**
     Should be called when bounds change to update paths of shape layers.
     */
    fileprivate func updateForCurrentBounds() {
        
        self.progressView.progressLayer.lineWidth = progressBarWidth
        self.backgroundView.shapeLayer.lineWidth = trackWidth
        self.progressView.progressLayer.path = self.progressLayerPath
        self.backgroundView.shapeLayer.path = self.backgroundLayerPath
        self.imageViewMask.path = self.imageViewMaskPath
        self.dropShadowLayer.shadowPath = self.shadowPath
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        updateForCurrentBounds()
    }
    
    open override var intrinsicContentSize : CGSize {
        var maxW: CGFloat = Constants.Layout.defaultContentSize.width
        var maxH: CGFloat = Constants.Layout.defaultContentSize.height
        
        let padding = 2 * (minimumImagePadding + trackWidth + progressBarWidth + Constants.Layout.outerPadding)
        
        if let imageSize = self.activityState.image?.size {
            maxW = max(imageSize.width, maxW) + padding
            maxH = max(imageSize.height, maxH) + padding
        }
        
        return CGSize(width: maxW, height: maxH)
    }
    
    
    
    
    
    
    // MARK: - Hit Animation
    func handleTouchUp(_ sender: ActivityIndicatorButton) {
        
        self.createRippleHitAnimation(true)
    }
    
    func handleTouchDown(_ sender: ActivityIndicatorButton) {
        
        self.createRippleHitAnimation(false)
    }
    
    
    /**
     Creates a new layer under the control which expands outward.
     */
    fileprivate func createRippleHitAnimation(_ isTouchUp: Bool) {
        
        let duration = self.hitAnimationDuration
        let distance: CGFloat = self.hitAnimationDistance
        let color = self.hitAnimationColor.cgColor
        let timing = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        let layer = CAShapeLayer()
        layer.fillColor = color
        layer.strokeColor = UIColor.clear.cgColor
        self.layer.insertSublayer(layer, at: 0)
        
        let bounds = self.bounds
        let radius = max(bounds.width, bounds.height) * 0.5
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let fromPath = UIBezierPath(arcCenter: center, radius: 0.0, startAngle: 0.0, endAngle: CGFloat(2 * M_PI), clockwise: true).cgPath
        let toPath = UIBezierPath(arcCenter: center, radius: radius + distance, startAngle: 0.0, endAngle: CGFloat(2 * M_PI), clockwise: true).cgPath
        
        let completion = { () -> Void in
            layer.removeFromSuperlayer()
        }
        
        func scaleLayer(_ layer: CALayer, offset: CGFloat) {
            
            var scaleFromValue = CATransform3DIdentity
            var scaleToValue = CATransform3DMakeScale(0.98 - offset, 0.98 - offset, 1.0)
            
            if isTouchUp {
                swap(&scaleFromValue, &scaleToValue)
            }
            
            let scaleAnim = CABasicAnimation(keyPath: "transform")
            scaleAnim.fromValue = NSValue(caTransform3D: scaleFromValue)
            scaleAnim.toValue = NSValue(caTransform3D: scaleToValue)
            scaleAnim.duration = duration
            scaleAnim.timingFunction = timing
            
            layer.add(scaleAnim, forKey: "hit_scale")
            layer.transform = scaleToValue
        }
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        
        let pathAnim = CABasicAnimation(keyPath: "path")
        pathAnim.fromValue = fromPath
        pathAnim.toValue = toPath
        
        let fadeAnim = CABasicAnimation(keyPath: "opacity")
        fadeAnim.fromValue = 1.0
        fadeAnim.toValue = 0.0
        
        scaleLayer(self.backgroundView.layer, offset: 0.0)
        scaleLayer(self.dropShadowLayer, offset: 0.0)
        
        let group = CAAnimationGroup()
        group.animations = [pathAnim, fadeAnim]
        group.duration = duration
        group.timingFunction = timing
        
        layer.add(group, forKey: "ripple")
        
        CATransaction.commit()
    }
    
}
