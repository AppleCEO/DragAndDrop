//
//  ViewController.swift
//  Cupist
//
//  Created by joon-ho kil on 2020/03/28.
//  Copyright © 2020 joon-ho kil. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  let alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
  var order = [String]() {
    didSet {
      topGridView.reloadData()
      bottomGridView.reloadData()
    }
  }
  let topGridView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
  let greyLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = CustomColor.cupistGrey.value
    label.text = CustomMent.grey.rawValue
    label.textAlignment = .center
    return label
  }()
  let hideButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = CustomColor.cupistPink.value
    button.setTitle("숨김", for: .normal)
    button.setTitleColor(.white, for: .normal)
    return button
  }()
  let showButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = CustomColor.cupistPink.value
    button.setTitle("보임", for: .normal)
    button.setTitleColor(.white, for: .normal)
    return button
  }()
  let initButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = CustomColor.cupistPink.value
    button.setTitle("초기화", for: .normal)
    button.setTitleColor(.white, for: .normal)
    return button
  }()
  let bottomGridView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())

  let cellInterval = CGFloat(CustomUnits.cellInterval)
  let numberOfCellIntervalPerRow = CGFloat(CustomUnits.numberOfCellIntervalPerRow)
  let numberOfCellsPerRow = CGFloat(CustomUnits.numberOfCellsPerRow)
  let numberOfCellsPerColumn = CGFloat(CustomUnits.numberOfCellsPerColumn)
  var showConst = [NSLayoutConstraint]()
  var hideConst = [NSLayoutConstraint]()
  var dragConst = [NSLayoutConstraint]()
  var isShow = true
    
  override func viewDidLoad() {
    super.viewDidLoad()
        
    addSubviews()
    makeConstraints()
    collectionViewSetup()
    NSLayoutConstraint.activate(showConst)
    let hideButtonGesture = UIPanGestureRecognizer(target: self, action: #selector(dragHideButton))
    hideButton.addGestureRecognizer(hideButtonGesture)
    let showButtonGesture = UIPanGestureRecognizer(target: self, action: #selector(dragShowButton))
    showButton.addGestureRecognizer(showButtonGesture)
    let initButtonGesture = UIPanGestureRecognizer(target: self, action: #selector(dragInitButton))
    initButton.addGestureRecognizer(initButtonGesture)
    addTargets()
  }
    
  @objc private func dragHideButton(_ sender: UIPanGestureRecognizer) {
    dragButton(sender)
  }
  @objc private func dragShowButton(_ sender: UIPanGestureRecognizer) {
    dragButton(sender)
  }
  @objc private func dragInitButton(_ sender: UIPanGestureRecognizer) {
    dragButton(sender)
  }
  private func dragButton(_ sender: UIPanGestureRecognizer) {
    let point = sender.location(in: view)
    let draggedView = sender.view!
    let cellLength = (self.view.frame.width-cellInterval*numberOfCellIntervalPerRow)/numberOfCellsPerRow
    let buttonLength = self.view.frame.width/numberOfCellsPerRow
    if point.y < CGFloat(CustomUnits.greyLabelHeight)*1.5 {
      hideButtonTaped()
      return
    }
    
    if point.y > cellLength*numberOfCellsPerColumn+cellInterval+CGFloat(CustomUnits.greyLabelHeight)*1.5 {
      showButtonTaped()
      return
    }
    let center = self.view.center
    draggedView.center = point
    topGridView.frame.origin = CGPoint(x: 0, y: point.y-(cellLength*numberOfCellsPerColumn+cellInterval)-CGFloat(CustomUnits.greyLabelHeight)*1.5)
    greyLabel.center = CGPoint(x: center.x, y: point.y-CGFloat(CustomUnits.greyLabelHeight))
    hideButton.center = CGPoint(x: center.x-buttonLength, y: point.y)
    showButton.center = CGPoint(x: center.x, y: point.y)
    initButton.center = CGPoint(x: center.x+buttonLength, y: point.y)
    if isShow {
      NSLayoutConstraint.deactivate(showConst)
      NSLayoutConstraint.activate(dragConst)
      bottomGridView.frame.origin = CGPoint(x: 0, y: point.y+CGFloat(CustomUnits.greyLabelHeight)/2.0)
    } else {
      let bottomGridViewElseHeight = CGFloat(CustomUnits.greyLabelHeight)
      let bottomGridViewHeight = self.view.frame.height-bottomGridViewElseHeight
      bottomGridView.center = CGPoint(x: center.x, y: point.y+bottomGridViewHeight/2.0)
    }
  }

  private func addSubviews() {
    self.view.addSubview(self.topGridView)
    self.view.addSubview(self.greyLabel)
    self.view.addSubview(self.hideButton)
    self.view.addSubview(self.showButton)
    self.view.addSubview(self.initButton)
    self.view.addSubview(self.bottomGridView)
  }

  private func makeConstraints() {
    let cellLength = (self.view.frame.width-cellInterval*numberOfCellIntervalPerRow)/numberOfCellsPerRow
    let buttonLength = self.view.frame.width/numberOfCellsPerRow
    topGridViewMakeConstraint(cellLength: cellLength)
    greyLabelMakeConstraints()
    hideButtonMakeConstraints(buttonLengh: buttonLength)
    showButtonMakeConstraints(buttonLengh: buttonLength)
    initButtonMakeConstraints(buttonLengh: buttonLength)
    bottomGridViewMakeConstraint(cellLength: cellLength)
  }
    
  private func topGridViewMakeConstraint(cellLength: CGFloat) {
    topGridView.translatesAutoresizingMaskIntoConstraints = false
    let topConst = topGridView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
    let leadingConst = topGridView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)
    let trailingConst = topGridView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
    let heightConst = topGridView.heightAnchor.constraint(equalToConstant: cellLength*numberOfCellsPerColumn+cellInterval)
    
    self.showConst += [topConst, leadingConst, trailingConst, heightConst]
    self.hideConst += [leadingConst, trailingConst, heightConst]
    self.dragConst += [leadingConst, trailingConst, heightConst]
  }
  
  private func greyLabelMakeConstraints() {
    greyLabel.translatesAutoresizingMaskIntoConstraints = false
    let topConst = greyLabel.topAnchor.constraint(equalTo: self.topGridView.bottomAnchor)
    let leadingConst = greyLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)
    let trailingConst = greyLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
    let heightConst = greyLabel.heightAnchor.constraint(equalToConstant: CGFloat(CustomUnits.greyLabelHeight))
    
    let hideTopConst = greyLabel.bottomAnchor.constraint(equalTo: self.topGridView.topAnchor)
    
    self.showConst += [topConst, leadingConst, trailingConst, heightConst]
    self.hideConst += [hideTopConst, leadingConst, trailingConst, heightConst]
    self.dragConst += [topConst, leadingConst, trailingConst, heightConst]
  }
    
  private func hideButtonMakeConstraints(buttonLengh: CGFloat) {
    hideButton.translatesAutoresizingMaskIntoConstraints = false
    let topConst = hideButton.topAnchor.constraint(equalTo: self.greyLabel.bottomAnchor)
    let leadingConst = hideButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)
    let widthConst = hideButton.widthAnchor.constraint(equalToConstant: CGFloat(buttonLengh))
    let heightConst = hideButton.heightAnchor.constraint(equalToConstant: CGFloat(CustomUnits.greyLabelHeight))
    
    let hideTopConst = hideButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
    
    self.showConst += [topConst, leadingConst, widthConst, heightConst]
    self.hideConst += [hideTopConst, leadingConst, widthConst, heightConst]
    self.dragConst += [topConst, leadingConst, widthConst, heightConst]
  }
    
  private func showButtonMakeConstraints(buttonLengh: CGFloat) {
    showButton.translatesAutoresizingMaskIntoConstraints = false
    let topConst = showButton.topAnchor.constraint(equalTo: self.greyLabel.bottomAnchor)
    let leadingConst = showButton.leadingAnchor.constraint(equalTo: self.hideButton.trailingAnchor)
    let widthConst = showButton.widthAnchor.constraint(equalToConstant: CGFloat(buttonLengh))
    let heightConst = showButton.heightAnchor.constraint(equalToConstant: CGFloat(CustomUnits.greyLabelHeight))
    
    let hideTopConst = showButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
    
    self.showConst += [topConst, leadingConst, widthConst, heightConst]
    self.hideConst += [hideTopConst, leadingConst, widthConst, heightConst]
    self.dragConst += [topConst, leadingConst, widthConst, heightConst]
  }
    
  private func initButtonMakeConstraints(buttonLengh: CGFloat) {
    initButton.translatesAutoresizingMaskIntoConstraints = false
    let topConst = initButton.topAnchor.constraint(equalTo: self.greyLabel.bottomAnchor)
    let leadingConst = initButton.leadingAnchor.constraint(equalTo: self.showButton.trailingAnchor)
    let widthConst = initButton.widthAnchor.constraint(equalToConstant: CGFloat(buttonLengh))
    let heightConst = initButton.heightAnchor.constraint(equalToConstant: CGFloat(CustomUnits.greyLabelHeight))
    let hideTopConst = initButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
    
    self.showConst += [topConst, leadingConst, widthConst, heightConst]
    self.hideConst += [hideTopConst, leadingConst, widthConst, heightConst]
    self.dragConst += [topConst, leadingConst, widthConst, heightConst]
  }
    
  private func bottomGridViewMakeConstraint(cellLength: CGFloat) {
    bottomGridView.translatesAutoresizingMaskIntoConstraints = false
    let topConst = bottomGridView.topAnchor.constraint(equalTo: self.initButton.bottomAnchor)
    let leadingConst = bottomGridView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)
    let trailingConst = bottomGridView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
    let bottomConst = bottomGridView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
    let heightConst = bottomGridView.heightAnchor.constraint(equalToConstant: 700.0)
    NSLayoutConstraint.activate([topConst, leadingConst, trailingConst, bottomConst])
    
    self.showConst += [topConst, leadingConst, trailingConst, bottomConst]
    self.hideConst += [topConst, leadingConst, trailingConst, bottomConst]
    self.dragConst += [topConst, leadingConst, trailingConst, heightConst]
  }
    
  private func collectionViewSetup() {
    topGridView.backgroundColor = .white
    topGridView.dataSource = self
    topGridView.register(AlphabetCollectionViewCell.self, forCellWithReuseIdentifier: "AlphabetCollectionViewCell")
    let topGrideLayout = UICollectionViewFlowLayout()
    topGridView.collectionViewLayout = topGrideLayout
    topGridView.showsHorizontalScrollIndicator = false
    topGridView.delegate = self
    topGridView.dataSource = self
    topGridView.dragInteractionEnabled = true
    topGridView.dragDelegate = self
    topGridView.dropDelegate = self
    bottomGridView.backgroundColor = .white
    bottomGridView.dataSource = self
    bottomGridView.register(AlphabetCollectionViewCell.self, forCellWithReuseIdentifier: "AlphabetCollectionViewCell")
    let bottomGrideLayout = UICollectionViewFlowLayout()
    bottomGridView.collectionViewLayout = bottomGrideLayout
    bottomGridView.showsHorizontalScrollIndicator = false
    bottomGridView.delegate = self
    bottomGridView.dataSource = self
  }
    
  private func addTargets() {
    self.hideButton.addTarget(self, action: #selector(hideButtonTaped), for: .touchUpInside)
    self.showButton.addTarget(self, action: #selector(showButtonTaped), for: .touchUpInside)
    self.initButton.addTarget(self, action: #selector(initButtonTaped), for: .touchUpInside)
  }
    
  @objc private func hideButtonTaped() {
    NSLayoutConstraint.deactivate(showConst)
    NSLayoutConstraint.activate(hideConst)
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
    self.isShow = false
  }
    
  @objc private func showButtonTaped() {
    NSLayoutConstraint.deactivate(hideConst)
    NSLayoutConstraint.activate(showConst)
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
    self.isShow = true
  }
    
  @objc private func initButtonTaped() {
    self.order = [String]()
  }
    
  private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
    let items = coordinator.items
    if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath {
      var dIndexPath = destinationIndexPath
      if dIndexPath.row >= collectionView.numberOfItems(inSection: 0) {
        dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
      }
      collectionView.performBatchUpdates({
        self.order.remove(at: sourceIndexPath.row)
        if dIndexPath.row > self.order.count {
          dIndexPath.row = self.order.count
        }
        self.order.insert(item.dragItem.localObject as! String, at: dIndexPath.row)
        collectionView.deleteItems(at: [sourceIndexPath])
        collectionView.insertItems(at: [dIndexPath])
      })
      coordinator.drop(items.first!.dragItem, toItemAt: dIndexPath)
    }
  }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == self.topGridView {
      return CustomUnits.numberOfCellsOfTopGrid
    }
    return alphabet.count
  }
        
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlphabetCollectionViewCell.ID, for: indexPath) as! AlphabetCollectionViewCell
    cell.layer.borderColor = UIColor.gray.cgColor
    cell.layer.borderWidth = 1
    if collectionView == topGridView && indexPath.row < order.count {
      cell.textLabel.text = order[indexPath.row]
    }
    if collectionView == bottomGridView {
      let item = alphabet[indexPath.row]
      cell.textLabel.text = item
      if let index = self.order.firstIndex(of: item) {
        cell.orderLabel.text = String(index+1)
        cell.orderLabel.isHidden = false
      } else {
        cell.orderLabel.isHidden = true
      }
    }
    return cell
  }
    
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let selectItem = self.alphabet[indexPath.row]
    guard collectionView == self.bottomGridView else {
      return
    }
    if let index = self.order.firstIndex(of: selectItem) {
      self.order.remove(at: index)
      return
    }
    if order.count < 6 {
      order.append(selectItem)
    }
  }
    
  func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
    true
  }

  func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    let item = order.remove(at: sourceIndexPath.item)
    order.insert(item, at: destinationIndexPath.item)
  }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let cellLength = (self.view.frame.width-cellInterval*numberOfCellIntervalPerRow)/numberOfCellsPerRow
    return CGSize(width: cellLength, height: cellLength)
  }
    
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    cellInterval
  }
    
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    cellInterval
  }
}

extension ViewController : UICollectionViewDragDelegate {
  func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    guard self.order.count > 1 else {
      return [UIDragItem]()
    }
    let item = self.order[indexPath.row]
    let itemProvider = NSItemProvider(object: item as NSString)
    let dragItem = UIDragItem(itemProvider: itemProvider)
    dragItem.localObject = item
    return [dragItem]
  }
    
  func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
    let item = self.order[indexPath.row]
    let itemProvider = NSItemProvider(object: item as NSString)
    let dragItem = UIDragItem(itemProvider: itemProvider)
    dragItem.localObject = item
    return [dragItem]
  }
    
  func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
    let previewParameters = UIDragPreviewParameters()
    previewParameters.visiblePath = UIBezierPath(rect: CGRect(x: .zero, y: .zero, width: 120, height: 120))
    return previewParameters
    }
}

// MARK: - UICollectionViewDropDelegate Methods
extension ViewController : UICollectionViewDropDelegate
{
  func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
    return session.canLoadObjects(ofClass: NSString.self)
  }
    
  func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
    if collectionView.hasActiveDrag {
      return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    } else {
      return UICollectionViewDropProposal(operation: .forbidden)
    }
  }
    
  func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
    let destinationIndexPath: IndexPath
    if let indexPath = coordinator.destinationIndexPath {
      destinationIndexPath = indexPath
    } else {
      let section = collectionView.numberOfSections - 1
      let row = collectionView.numberOfItems(inSection: section)
      destinationIndexPath = IndexPath(row: row, section: section)
    }
        
    switch coordinator.proposal.operation {
    case .move:
      self.reorderItems(coordinator: coordinator, destinationIndexPath:destinationIndexPath, collectionView: collectionView)
      break
    default:
      return
    }
  }
}
