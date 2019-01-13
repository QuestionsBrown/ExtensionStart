//
//  Extensions.swift
//  GitTest7
//
//  Created by Concetta Turner on 1/13/19.
//  Copyright © 2019 Integral Mobile AR. All rights reserved.
//

import Foundation
import SceneKit

extension SCNNode {
    
    
    func cleanupMeshes() {
        
        for child in childNodes {
            child.cleanupMeshes()
        }
        
        //Firebase Database Set Geometry & Texture NEEDED
        geometry = nil
        geometry?.materials.removeAll()
        removeFromParentNode()
        print("MeshesCleaned")
    }
    
    func fadeItem() {
        let fadeIn = SCNAction.fadeIn(duration: 0)
        self.runAction(fadeIn)
    }
    
    
    func moveTo(viewSpotPos : SCNVector3) {
        let moveTo = SCNAction.move(to: viewSpotPos, duration: 0.9)
        let scaleBy = SCNAction.scale(by: 1, duration: 1)
        self.runAction(moveTo)
        self.runAction(scaleBy)
    }
    
    func snapBack(viewSpotPos : SCNVector3) {
        let moveTo = SCNAction.move(to: viewSpotPos, duration: 0.0)
        let scaleBy = SCNAction.scale(by: 1, duration: 1)
        self.runAction(moveTo)
        self.runAction(scaleBy)
    }
    
    func returnItem(itemOrigin : SCNVector3) {
        let moveTo = SCNAction.move(to: itemOrigin, duration: 0.9)
        self.runAction(moveTo)
    }
    
    func rotate(by worldRotation: SCNQuaternion, worldTarget: SCNVector3) {
        let moveTo = SCNAction.rotate(by: 2, around: worldTarget, duration: 30)
        self.runAction(moveTo)
    }
    
    
    func spinItem() {
        let deadlineTime = DispatchTime.now() + .seconds(0)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.runAction(SCNAction.repeat(.rotateBy(x: 0, y: 6.4, z: 0, duration: 5), count: 2))
        }
    }
    
    func spinItem3() {
        let deadlineTime = DispatchTime.now() + .seconds(0)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.runAction(SCNAction.repeat(.rotateBy(x: 0, y: 0, z: 6.4, duration: 5), count: 2))
        }
    }
    
    func spinCake() {
        let deadlineTime = DispatchTime.now() + .seconds(0)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.runAction(SCNAction.repeat(.rotateBy(x: 0, y: 6.4, z: 0, duration: 5), count: 2))
        }
    }
    
    func moveSpotLight(viewSpotPos : SCNVector3) {
        let moveTo = SCNAction.move(to: viewSpotPos, duration: 0)
        self.runAction(moveTo)
    }
    
    //    func directionsFadeOut() {
    //     let fadeOut = SCNAction.fadeOpacity(by: -0.50, duration: 0.50)
    // self.runAction(fadeOut)
    //    }
    //
    //    func directionsFadeIn() {
    //        let fadeIn = SCNAction.fadeOpacity(by: 0.50, duration: 0.50)
    //         self.runAction(fadeIn)
    //    }
    
    private static let highlightAnimationKey = "highlightAnimationKey"
    private static let dehighlightAnimationKey = "dehighlightAnimationKey"
    private static let highlightAnimationDuration = 0.15
    
    /**
     Add a new highlight fitler if no one already exists
     */
    private func addHighlightFilter(glowIntensity: Double, glowRadius: Double) {
        if highlightFilterExist() { return }
        
        let newHighlightFilter = HighlightFilter()
        newHighlightFilter.name = HighlightFilter.filterName
        newHighlightFilter.setValue(NSNumber(floatLiteral: glowRadius), forKey: "inputRadius")
        newHighlightFilter.setValue(NSNumber(floatLiteral: glowIntensity), forKey: "inputIntensity")
        
        if self.filters != nil {
            self.filters?.append(newHighlightFilter)
        }
        else {
            self.filters = [newHighlightFilter]
        }
    }
    
    func highlight(glowIntensity: Double = 6.0, glowRadius: Double = 30.0) {
        addHighlightFilter(glowIntensity: glowIntensity, glowRadius: glowRadius)
        
        SCNTransaction.begin()
        let animation = CABasicAnimation(keyPath: "filters.highlightFilter.inputIntensity")
        animation.fromValue = 0.0
        animation.duration = SCNNode.highlightAnimationDuration
        SCNTransaction.completionBlock = {
            // We add the filter again in case it was removed by dehighlight at the same time
            self.addHighlightFilter(glowIntensity: glowIntensity, glowRadius: glowRadius)
        }
        self.addAnimation(animation, forKey: SCNNode.highlightAnimationKey)
        SCNTransaction.commit()
    }
    
    func dehighlight() {
        if let highlightFilter = highlightFilter() {
            let currentIntensity = highlightFilter.inputIntensity!
            highlightFilter.setValue(NSNumber(floatLiteral: 0.0), forKey: "inputIntensity")
            SCNTransaction.begin()
            let animation = CABasicAnimation(keyPath: "filters.highlightFilter.inputIntensity")
            animation.fromValue = currentIntensity
            animation.duration = SCNNode.highlightAnimationDuration
            SCNTransaction.completionBlock = {
                self.removeHighlightFilter()
            }
            self.addAnimation(animation, forKey: SCNNode.dehighlightAnimationKey)
            SCNTransaction.commit()
        }
    }
    
    
    
    private func removeHighlightFilter() {
        if let highlightFilterIndex = self.highlightFilterIndex() {
            self.filters?.remove(at: highlightFilterIndex)
        }
    }
    
    private func highlightFilter() -> HighlightFilter? {
        guard let highlightFilterIndex = highlightFilterIndex() else {
            return nil
        }
        return filters?[highlightFilterIndex] as? HighlightFilter
    }
    
    private func highlightFilterIndex() -> Int? {
        return filters?.map{$0.name}.index(of: HighlightFilter.filterName) ?? nil
    }
    
    
    
    private func highlightFilterExist() -> Bool {
        return filters?.map{$0.name}.contains(HighlightFilter.filterName) ?? false
    }
    
}


//Make Into Struct
enum MeshNames: String {
    case Fish
    case Yeezys
    case Chiken
    case Nikes
    
    case Salmon
    case Converse
    case Oysters
    case Sushi
    
    case Bread
    case Crackers
    case FruitSides
    case OGYeezys
    
    case Cake
    case FruitCake
    case Chocolate
    case GingerBreadHouse
    
    
    case BreakfastHitBox
    case Lunch
    case DinnerHitBox
    case SidesHitBox
    case DessertsHitBox
    case FruitHitbox
    
    case TV
    case NetflixBox
}


protocol WorldSetupDelegate {
    
    var contentRootNode: SCNNode {get}
    
    //First Row
    var position0: SCNVector3 {get set}
    //    var position1: SCNVector3 {get set} (0,-1,-4)
    //    var position0: SCNVector3 {get set} (-1,-1,-4)
    //    var position1: SCNVector3 {get set} (-2,-1,-4)
    
    //Second Row
    //    var position0: SCNVector3 {get set} (1,0,-4)
    //    var position1: SCNVector3 {get set} (0,0,-4)
    //    var position2: SCNVector3 {get set} (-1,0,-4)
    //    var position3: SCNVector3 {get set} (-2,-1,-4)
    
    
    func launchAllDonuts()
    
    mutating func selectItem(withImageName name: String)
    
    mutating func resetItemNode(withImageName name: String)
    
    func resetAllNodes()
    
    //    func resetDinnerNodes()
    
    //        var store: SCNNode {get}
    //        var mainCatagories: SCNNode {get set}
    //        var chocolateCatagory: SCNNode {get set}
    //        var icedCatagory: SCNNode {get set}
    //        var glazedCatagory: SCNNode {get set}
    //        var filledCatagories: SCNNode {get set}
    //        var cakeCatagories: SCNNode {get set}
    
    
}


class HighlightFilter: CIFilter {
    
    static let filterName = "highlightFilter"
    
    @objc dynamic var inputImage: CIImage?
    @objc dynamic var inputIntensity: NSNumber?
    @objc dynamic var inputRadius: NSNumber?
    
    override var outputImage: CIImage? {
        guard let inputImage = inputImage else {
            return nil
        }
        
        let bloomFilter = CIFilter(name:"CIBloom")!
        bloomFilter.setValue(inputImage, forKey: kCIInputImageKey)
        bloomFilter.setValue(inputIntensity, forKey: "inputIntensity")
        bloomFilter.setValue(inputRadius, forKey: "inputRadius")
        
        let sourceOverCompositing = CIFilter(name:"CISourceOverCompositing")!
        sourceOverCompositing.setValue(inputImage, forKey: "inputImage")
        sourceOverCompositing.setValue(bloomFilter.outputImage, forKey: "inputBackgroundImage")
        
        return sourceOverCompositing.outputImage
    }
    
}

extension UIButton {
    
    func fadeIn() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 1
        flash.fromValue = 0
        flash.toValue = 1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        layer.add(flash, forKey: nil)
    }
    
    
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        layer.add(flash, forKey: nil)
    }
    
    
    func flashHelp() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.1
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 1
        layer.add(flash, forKey: nil)
    }
    
    func flashTapScreen() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.85
        flash.fromValue = 1
        flash.toValue = 0
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        layer.add(flash, forKey: nil)
        
    }
    
}

extension UILabel {
    
    func fadeIn() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 5
        flash.fromValue = 0
        flash.toValue = 1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 0
        layer.add(flash, forKey: nil)
    }
    
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.7
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 1
        layer.add(flash, forKey: nil)
    }
    
    func flashTapScreen() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.85
        flash.fromValue = 1
        flash.toValue = 0
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        layer.add(flash, forKey: nil)
        
    }
}


extension UIImageView {
    
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        layer.add(flash, forKey: nil)
    }
}

extension UIScrollView  {
    
    func flash() {
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        self.backgroundColor = UIColor.clear
        
        layer.add(flash, forKey: nil)
    }
}

func degreesToRadians (_ value:CGFloat) -> CGFloat {
    return value * CGFloat(M_PI) / 180.0
}

func radiansToDegrees (_ value:CGFloat) -> CGFloat {
    return value * 180.0 / CGFloat(M_PI)
}

func dialogBezierPathWithFrame(_ frame: CGRect, arrowOrientation orientation: UIImage.Orientation, arrowLength: CGFloat = 20.0) -> UIBezierPath {
    // Translate frame to neutral coordinate system & transpose it to fit the orientation.
    var transposedFrame = CGRect.zero
    switch orientation {
    case .up, .down, .upMirrored, .downMirrored:
        transposedFrame = CGRect(x: 0, y: 0, width: frame.size.width - frame.origin.x, height: frame.size.height - frame.origin.y)
    case .left, .right, .leftMirrored, .rightMirrored:
        transposedFrame = CGRect(x: 0, y: 0,  width: frame.size.height - frame.origin.y, height: frame.size.width - frame.origin.x)
    }
    
    // We need 7 points for our Bezier path
    let midX = transposedFrame.midX
    let point1 = CGPoint(x: transposedFrame.minX, y: transposedFrame.minY + arrowLength)
    let point2 = CGPoint(x: midX - (arrowLength / 2), y: transposedFrame.minY + arrowLength)
    let point3 = CGPoint(x: midX, y: transposedFrame.minY)
    let point4 = CGPoint(x: midX + (arrowLength / 2), y: transposedFrame.minY + arrowLength)
    let point5 = CGPoint(x: transposedFrame.maxX, y: transposedFrame.minY + arrowLength)
    let point6 = CGPoint(x: transposedFrame.maxX, y: transposedFrame.maxY)
    let point7 = CGPoint(x: transposedFrame.minX, y: transposedFrame.maxY)
    
    // Build our Bezier path
    let path = UIBezierPath()
    path.move(to: point1)
    path.addLine(to: point2)
    path.addLine(to: point3)
    path.addLine(to: point4)
    path.addLine(to: point5)
    path.addLine(to: point6)
    path.addLine(to: point7)
    path.close()
    
    // Rotate our path to fit orientation
    switch orientation {
    case .up, .upMirrored:
    break // do nothing
    case .down, .downMirrored:
        path.apply(CGAffineTransform(rotationAngle: degreesToRadians(180.0)))
        path.apply(CGAffineTransform(translationX: transposedFrame.size.width, y: transposedFrame.size.height))
    case .left, .leftMirrored:
        path.apply(CGAffineTransform(rotationAngle: degreesToRadians(-90.0)))
        path.apply(CGAffineTransform(translationX: 0, y: transposedFrame.size.width))
    case .right, .rightMirrored:
        path.apply(CGAffineTransform(rotationAngle: degreesToRadians(90.0)))
        path.apply(CGAffineTransform(translationX: transposedFrame.size.height, y: 0))
    }
    
    return path
}

extension UIView {
    func applyArrowDialogAppearanceWithOrientation(arrowOrientation: UIImage.Orientation) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = dialogBezierPathWithFrame(self.frame, arrowOrientation: arrowOrientation).cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.fillRule = CAShapeLayerFillRule.evenOdd
        self.layer.mask = shapeLayer
    }
    
}

extension UIView {
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}


