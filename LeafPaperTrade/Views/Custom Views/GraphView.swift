//
//  GraphView.swift
//  LeafPaperTrade
//
//  Created by Devin Singh on 2/26/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import UIKit

protocol GraphViewDelegate: class {
    func didMoveToPrice(_ graphView: GraphView, price: Double)
}

// Layout constants
private extension CGFloat {
    static let graphLineWidth: CGFloat = 1.5
    static var scale: CGFloat = 100
    static let lineViewHeightMultiplier: CGFloat = 0.7
    static let baseLineWidth: CGFloat = 1.0
    static let timeStampPadding: CGFloat = 10.0
}

class GraphView: UIView {
    
    var dataPoints: EquityChartData?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        return formatter
    }()
    
    private var lineView = UIView()
    private let timeStampLabel = UILabel()
    private var lineViewLeading = NSLayoutConstraint()
    private var timeStampLeading = NSLayoutConstraint()
    
    private let panGestureRecognizer = UIPanGestureRecognizer()
    private let longPressGestureRecognizer = UILongPressGestureRecognizer()
    
    private var height: CGFloat = 0
    private var width: CGFloat = 0
    private var step: CGFloat = 1
    private var once: Bool = false
    
    private var xCoordinates: [CGFloat] = []
    
    // Delegate property to access
    weak var delegate: GraphViewDelegate?
    private var feedbackGenerator = UISelectionFeedbackGenerator()
    
    init(data: EquityChartData?) {
        self.dataPoints = data
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.dataPoints = EquityChartData(openingPrice: 0, data: [])
        super.init(coder: aDecoder)
    }
    
    
    override func draw(_ rect: CGRect) {
        
        height = rect.size.height
        width = rect.size.width
        
        
        guard let dataPoints = dataPoints else { return }
        step = width/CGFloat(dataPoints.data.count)
        
        drawGraph(rect: rect)
        
        if once { return }
        once = true
        
        configureLineIndicatorView()
        configureTimeStampLabel()
        
        addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.addTarget(self, action: #selector(userDidPan(_:)))
        
        addGestureRecognizer(longPressGestureRecognizer)
        longPressGestureRecognizer.addTarget(self, action: #selector(userDidLongPress(_:)))
    }
    
    private func drawGraph(rect: CGRect) {
        
        let graphPath = UIBezierPath()
        graphPath.move(to: CGPoint(x: 0, y: height))
        
        guard let dataPoints = dataPoints else { return }
        
        xCoordinates.append(0)
        
        var currentX: CGFloat = 0.0
        for _ in dataPoints.data {
            // Added one for the opening price
            let numberOfPrices = dataPoints.data.count + 1
            
            let incrementXByValue = rect.size.width/CGFloat(numberOfPrices)
            
            currentX += incrementXByValue
            
            xCoordinates.append(CGFloat(currentX))
        }
        
        
        for (index, dataPoint) in dataPoints.data.enumerated() {
            let midPoint = dataPoints.openingPrice
            let graphMiddle = height/2
            
            let y: CGFloat = graphMiddle + CGFloat(midPoint - dataPoint.price) * CGFloat.scale
            
            
            if y < self.coordinateSpace.bounds.origin.y {
                CGFloat.scale -= 1
                drawGraph(rect: rect)
            } else {
                let newPoint = CGPoint(x: xCoordinates[index], y: y)
                
                if index == 0 {
                    graphPath.move(to: CGPoint(x: 0, y: y))
                } else {
                    graphPath.addLine(to: newPoint)
                }
            }
            
            
            
            
        }
        UIColor.upAccentColor.setFill()
        UIColor.upAccentColor.setStroke()
        graphPath.lineWidth = .graphLineWidth
        graphPath.stroke()
    }
    
    private func configureLineIndicatorView() {
        lineView.backgroundColor = UIColor.gray
        lineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(lineView)
        
        lineViewLeading = NSLayoutConstraint(item: lineView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        
        addConstraints([
            lineViewLeading,
            NSLayoutConstraint(item: lineView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: lineView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1.0),
            NSLayoutConstraint(item: lineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height * .lineViewHeightMultiplier),
        ])
    }
    
    private func configureTimeStampLabel() {
        timeStampLabel.configureTitleLabel(withText: "09:30:00 ET")
        timeStampLabel.textColor = .lightTitleTextColor
        addSubview(timeStampLabel)
        timeStampLabel.translatesAutoresizingMaskIntoConstraints = false
        
        timeStampLeading = NSLayoutConstraint(item: timeStampLabel, attribute: .leading, relatedBy: .equal, toItem: lineView, attribute: .leading, multiplier: 1.0, constant: .timeStampPadding)
        
        addConstraints([
            NSLayoutConstraint(item: timeStampLabel, attribute: .bottom, relatedBy: .equal, toItem: lineView, attribute: .top, multiplier: 1.0, constant: 0.0),
            timeStampLeading
        ])
    }
    
    @objc func userDidLongPress(_ lpgr: UILongPressGestureRecognizer) {
        let touchLocation = lpgr.location(in: self)
        let x = convertTouchLocationToPointX(touchLocation: touchLocation)
        
        guard let xIndex = xCoordinates.firstIndex(of: x) else {return }
        guard let dataPoints = dataPoints else { return }
        
        if xIndex > dataPoints.data.count - 1 { return }
        let dataPoint = dataPoints.data[xIndex]
        updateIndicator(with: x, date: dataPoint.date, price: dataPoint.price)
    }
    
    @objc func userDidPan(_ pgr: UIPanGestureRecognizer) {
        let touchLocation = pgr.location(in: self)
        
        switch pgr.state {
        case .changed, .began, .ended:
            
            let x = convertTouchLocationToPointX(touchLocation: touchLocation)
            
            guard let xIndex = xCoordinates.firstIndex(of: x) else { return }
            guard let dataPoints = dataPoints else { return }
            
            if xIndex > dataPoints.data.count - 1 { return }
            let dataPoint = dataPoints.data[xIndex]
            
            updateIndicator(with: x, date: dataPoint.date, price: dataPoint.price)
            
        default: break
        }
    }
    
    private func updateIndicator(with offset: CGFloat, date: Date, price: Double) {
        let dateString = dateFormatter.string(from: date)
        
        let seperatedDate = dateString.split(separator: " ").map { String($0) }
        
        timeStampLabel.text = seperatedDate[1] + " ET"
        
        if offset != lineViewLeading.constant {
            feedbackGenerator.prepare()
            feedbackGenerator.selectionChanged()
            // Calling didMoveToPrice on the delegate (view controller)
            delegate?.didMoveToPrice(self, price: price)
        }
        
        lineViewLeading.constant = offset
        
        let timeStampStartAnchor = timeStampLabel.frame.width/2 + .timeStampPadding
        let timeStampEndAnchor = width - timeStampLabel.frame.width/2 - .timeStampPadding
        
        if offset > timeStampStartAnchor && offset < timeStampEndAnchor {
            timeStampLeading.constant = -timeStampLabel.frame.width/2
        } else if offset + timeStampStartAnchor  < timeStampEndAnchor {
            timeStampLeading.constant = -timeStampLabel.frame.width/2 + (timeStampLabel.frame.width/2 - offset) + .timeStampPadding
        } else {
            timeStampLeading.constant = -timeStampLabel.frame.width + (width - offset) - .timeStampPadding
        }
    }
    
    // Check if touchLocation.x is in the bounds of the width of the view, and converts it to a graph value
    private func convertTouchLocationToPointX(touchLocation: CGPoint) -> CGFloat {
        let maxX: CGFloat = width
        let minX: CGFloat = 0
        
        var x = min(max(touchLocation.x, maxX), minX)
        
        xCoordinates.forEach { (xCoordinate) in
            let difference = abs(xCoordinate - touchLocation.x)
            if difference <= step {
                x = CGFloat(xCoordinate)
                return
            }
        }
        
        return x
    }
}
