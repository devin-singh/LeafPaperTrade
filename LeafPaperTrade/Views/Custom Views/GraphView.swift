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
  static let scale: CGFloat = 35
  static let lineViewHeightMultiplier: CGFloat = 0.7
  static let baseLineWidth: CGFloat = 1.0
  static let timeStampPadding: CGFloat = 10.0
}

class GraphView: UIView {
  
var dataPoints: EquityChartData
  
  private lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm a v, MMM d"
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
  
  private var xCoordinates: [CGFloat] = []
  
  // Delegate property to access
  weak var delegate: GraphViewDelegate?
  private var feedbackGenerator = UISelectionFeedbackGenerator()
  
  init(data: EquityChartData) {
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
    
    step = width/CGFloat(dataPoints.data.count)
    
    drawGraph()
    drawMiddleLine()
    
    configureLineIndicatorView()
    configureTimeStampLabel()
    
    addGestureRecognizer(panGestureRecognizer)
    panGestureRecognizer.addTarget(self, action: #selector(userDidPan(_:)))
    
    addGestureRecognizer(longPressGestureRecognizer)
    longPressGestureRecognizer.addTarget(self, action: #selector(userDidLongPress(_:)))
  }
  
  private func drawGraph() {
    
    let graphPath = UIBezierPath()
    graphPath.move(to: CGPoint(x: 0, y: height))
    
    for i in stride(from: 0, to: width, by: step) {
      xCoordinates.append(i)
    }
    
    for (index, dataPoint) in dataPoints.data.enumerated() {
      let midPoint = dataPoints.openingPrice
      let graphMiddle = height/2
      
      let y: CGFloat = graphMiddle + CGFloat(midPoint - dataPoint.price) * .scale
      
      let newPoint = CGPoint(x: xCoordinates[index], y: y)
      graphPath.addLine(to: newPoint)
    }
    
    UIColor.upAccentColor.setFill()
    UIColor.upAccentColor.setStroke()
    graphPath.lineWidth = .graphLineWidth
    graphPath.stroke()
  }
  
  private func drawMiddleLine() {
    let middleLine = UIBezierPath()
    
    let startingPoint = CGPoint(x: 0, y: height/2)
    let endingPoint = CGPoint(x: width, y: height/2)
    
    middleLine.move(to: startingPoint)
    middleLine.addLine(to: endingPoint)
    middleLine.setLineDash([0, step], count: 2, phase: 0)
    
    middleLine.lineWidth = .baseLineWidth
    middleLine.lineCapStyle = .round
    middleLine.stroke()
    
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
    timeStampLabel.configureTitleLabel(withText: "09:00 AM ET, MAY 25")
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
    
    let dataPoint = dataPoints.data[xIndex]
    updateIndicator(with: x, date: dataPoint.date, price: dataPoint.price)
  }
  
  @objc func userDidPan(_ pgr: UIPanGestureRecognizer) {
    let touchLocation = pgr.location(in: self)
    
    switch pgr.state {
    case .changed, .began, .ended:
      
      let x = convertTouchLocationToPointX(touchLocation: touchLocation)
      
      guard let xIndex = xCoordinates.firstIndex(of: x) else {return }
      let dataPoint = dataPoints.data[xIndex]
      
      updateIndicator(with: x, date: dataPoint.date, price: dataPoint.price)
      
    default: break
    }
  }
  
  private func updateIndicator(with offset: CGFloat, date: Date, price: Double) {
    timeStampLabel.text = dateFormatter.string(from: date).uppercased()
    
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
