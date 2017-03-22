//
//  ViewController.swift
//  CoreySalzer-Lab3
//
//  Created by Corey Salzer on 2/13/17.
//  Copyright © 2017 Corey Salzer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var drawingCanvasView: UIView!
    
    var isBrush : Bool!
    var currStroke : StrokeView?
    var currTextField : UITextField?
    var currThickness : CGFloat!
    var currPenColor : UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        currThickness = 15
        currPenColor = UIColor.black
        isBrush = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currTextField != nil && touches.first!.view != currTextField! {
            currTextField!.resignFirstResponder()
        }
        
        guard let touchPoint = touches.first?.location(in: drawingCanvasView) else { return }
        if isBrush! {
            let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            currStroke = StrokeView(frame: frame)
            currStroke?.stroke = Stroke(points: [touchPoint], thickness: currThickness, color: currPenColor)
            drawingCanvasView.addSubview(currStroke!)
        }
        else {
            let frame = CGRect(x: touchPoint.x, y: touchPoint.y, width: drawingCanvasView.frame.width - touchPoint.x, height: 10 + currThickness * 2)
            currTextField = UITextField(frame: frame)
            currTextField!.textColor = currPenColor
            currTextField!.tintColor = currPenColor
            currTextField!.font = UIFont.systemFont(ofSize: 3 + currThickness * 2)
            currTextField!.addTarget(self, action: #selector(customTextFieldEditingDidEnd(textField:)), for: UIControlEvents.editingDidEnd)
            currTextField!.becomeFirstResponder()
            drawingCanvasView.addSubview(currTextField!)
        }

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isBrush! {
            if touches.first == nil { return }
            
            for touch in touches {
                currStroke?.stroke?.points.append(touch.location(in: drawingCanvasView))
            }
        }
        else {
            for touch in touches {
                let touchPoint = touch.location(in: drawingCanvasView)
                currTextField!.frame = CGRect(x: touchPoint.x, y: touchPoint.y, width: drawingCanvasView.frame.width - touchPoint.x, height: 10 + currThickness * 2)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first?.location(in: drawingCanvasView) else { return }
        if isBrush! {
            currStroke?.stroke?.points.append(touchPoint)
        }
        else {
            currTextField!.frame = CGRect(x: touchPoint.x, y: touchPoint.y, width: drawingCanvasView.frame.width - touchPoint.x, height: 10 + currThickness * 2)
        }
    }
    
    func customTextFieldEditingDidEnd(textField: UITextField) {
        if textField.text! == "" {
            textField.removeFromSuperview()
        }

        textField.sizeToFit()
        textField.isEnabled = false
    }
    
    @IBAction func changePenSize(_ sender: UISlider) {
        currThickness = CGFloat(5 + sender.value * 20)
    }
    
    @IBAction func clearCanvas(_ sender: UIButton) {
        for v in drawingCanvasView.subviews {
            v.removeFromSuperview()
        }
    }
    
    @IBAction func undoStroke(_ sender: UIButton) {
        if currTextField != nil {
            currTextField!.resignFirstResponder()
        }
        
        if (drawingCanvasView.subviews.last != nil) {
            drawingCanvasView.subviews.last!.removeFromSuperview()
        }
    }
    @IBAction func addWinkyFace(_ sender: UIButton) {
        let imageView = UIImageView(image: UIImage(named: "face-with-stuck-out-tongue-and-winking-eye"))
        let randX = CGFloat(drand48()) * drawingCanvasView.frame.width
        let randY = CGFloat(drand48()) * drawingCanvasView.frame.height
        imageView.frame = CGRect(x: randX, y: randY, width: 50 + 2 * currThickness, height: 50 + 2 * currThickness)
        drawingCanvasView.addSubview(imageView)
    }
    
    @IBAction func changeColor(_ sender: ColorButton) {
        currPenColor = sender.backgroundColor!
    }
    
    @IBAction func changeToText(_ sender: UIButton) {
        isBrush = false
    }

    @IBAction func changeToBrush(_ sender: UIButton) {
        isBrush = true
        if currTextField != nil {
            currTextField!.resignFirstResponder()
        }
    }

}

