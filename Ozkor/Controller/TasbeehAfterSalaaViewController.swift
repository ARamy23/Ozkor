//
//  ViewController.swift
//  Ozkor
//
//  Created by Ahmed Ramy on 4/6/18.
//  Copyright © 2018 Ahmed Ramy. All rights reserved.
//

import UIKit
import Canvas

class TasbeehAfterSalaaViewController: UIViewController
{
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var ZekrLabel: UILabel!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var animationViewForZekrLabel: CSAnimationView!
    
    
    let textArray = ["Soubhan Allah","Al-Hamd Le Allah","Allahu Akbar"]
    var textArrayIndex = 0
    let shapeLayer = CAShapeLayer()
    var pulsatingLayer : CAShapeLayer!
    var counter = 0
    
    let counterLabel: UILabel =
    {
        let label = UILabel()
        label.text = "Start"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = UIColor.green
        return label
    }()
    
    let animationView : CSAnimationView =
    {
        let av = CSAnimationView()
        av.backgroundColor = UIColor.pulsatingFillColor
        
        av.delay = 0
        av.duration = 0.45
        av.type = CSAnimationTypeZoomOut
        return av
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      view.backgroundColor = UIColor.backgroundColor
        initShapes()
        customizeUI()
        animateBackground()
        initZekrLabelDesign()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        animateBackground()
    }
    
    fileprivate func customizeUI()
    {
        dismissButton.layer.cornerRadius = dismissButton.frame.height / 2
    }
    
    fileprivate func initZekrLabelDesign()
    {
        ZekrLabel.text = textArray[0]
    }
    
    private func setupNotificationObserver()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    @objc private func handleEnterForeground()
    {
            animateBackground()
    }
    
    fileprivate func drawPulsatingLayer(_ circularPath: UIBezierPath) {
        //pulsating effect
        pulsatingLayer = CAShapeLayer()
        pulsatingLayer.path = circularPath.cgPath
        pulsatingLayer.strokeColor = UIColor.clear.cgColor
        pulsatingLayer.fillColor = UIColor.trackStrokeColor.cgColor
        pulsatingLayer.lineWidth = 10
        pulsatingLayer.lineCap = kCALineCapRound
        pulsatingLayer.position = view.center
        view.layer.addSublayer(pulsatingLayer)
    }
    
    fileprivate func drawTrackLayer(_ circularPath: UIBezierPath) {
        
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.pulsatingFillColor.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 10
        trackLayer.lineCap = kCALineCapRound
        trackLayer.position = view.center
        view.layer.addSublayer(trackLayer)
    }
    
    fileprivate func drawTasbehShapeLayer(_ circularPath: UIBezierPath) {
        //Actual Progress
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.lineCap = kCALineCapRound
        
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = 0
        shapeLayer.position = view.center
        view.layer.addSublayer(shapeLayer)
    }
    
    fileprivate func customizeAnimationViewForAccessibility() {
        //customization for the animationView
        animationView.layer.cornerRadius = animationView.frame.height/2
        animationView.layer.masksToBounds = false
    }
    
    fileprivate func initCounter() {
        animationView.addSubview(counterLabel)
        view.addSubview(animationView)
        animationView.frame = CGRect(x:0 , y:0 , width:100 , height: 100)
        animationView.center = view.center
        counterLabel.frame = CGRect(x:0 , y:0 , width:100 , height: 100)
    }
    
    func initShapes()
    {
//        view.backgroundColor = UIColor.init(red: 21, green: 22, blue: 33, alpha: 1)
        
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi*2, clockwise: true)
        
        //Pulsating Effects Layer
        drawPulsatingLayer(circularPath)
        
        
        //Tracks for the progress
        drawTrackLayer(circularPath)
        
        //ActualProgress
        drawTasbehShapeLayer(circularPath)
        
        //TapGestureRecognizer
        /*
         adding gestureRecognizer with a handleTap method
         which basically translates taps into
         counting of the tasbeeh
        */
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        //place the counter in position along with the animationView
        /*
         animationView is a holder to the counter and as well as being an 'animatingView'
        */
        initCounter()
        
        customizeAnimationViewForAccessibility()
    }
    
    private func animateBackground()
    {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.05
        animation.duration = 10
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        background.layer.add(animation, forKey: "animBackground")
    }
    
    fileprivate func animatePulsatingLayer()
    {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.5
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.autoreverses = true
        pulsatingLayer.add(animation, forKey: "pulsing")
        
    }
    
    fileprivate func animateTasbeeh() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fromValue = shapeLayer.strokeEnd
        //If progress is less than being full circle
        if(shapeLayer.strokeEnd < 0.79859)
        {
            shapeLayer.strokeEnd += 0.0242
            counter += 1
            counterLabel.text = String(counter)
            animationView.startCanvasAnimation()
            
        }
        else
        {
            //reset the progress and the counter
            shapeLayer.strokeEnd = 0
            counter = 0
            counterLabel.text = String(counter)
            animatePulsatingLayer()
            
            
            if textArrayIndex < 2
            {
                textArrayIndex += 1
            }
            else
            {
                textArrayIndex = 0
                /*
                 TODO:- Show Alert or popup saying, Ashhado an la ellah ila allah wahdaho la
                 shareek lah, laho l molk wa laho al Hamd, Yohey w yomeet wa howa 3la kol
                 4ay2een kadeer
                */
            }
            ZekrLabel.text = textArray[textArrayIndex]
            animationViewForZekrLabel.delay = 0
            animationViewForZekrLabel.duration = 1.2
            animationViewForZekrLabel.type = CSAnimationTypeSlideUp
            animationViewForZekrLabel.startCanvasAnimation()
            animationView.startCanvasAnimation()
        }
        basicAnimation.toValue = shapeLayer.strokeEnd
        basicAnimation.duration = 0.45
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "circle")
    }
    
    @objc func handleTap()
    {
        animateTasbeeh()
    }
    
    @IBAction func didTapDismissButton(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension UIColor {
    
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static let backgroundColor = UIColor.rgb(r: 26, g: 33, b: 44)
    static let outlineStrokeColor = UIColor.rgb(r: 114, g: 41, b: 87)
    static let trackStrokeColor = UIColor.rgb(r: 0, g: 71, b: 100)
    static let pulsatingFillColor = UIColor.rgb(r: 0, g: 160, b: 200)
    static let zekrColor = UIColor.rgb(r: 114, g: 41, b: 87)
}

