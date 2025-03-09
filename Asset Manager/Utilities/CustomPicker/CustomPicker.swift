//
//  CustomPicker.swift
//  Asset Manager
//
//  Created by Marwan on 31/07/2022.
//

import UIKit
import FittedSheets

struct PickerModel {
    var name: String
    var id: Int
}

class CustomPicker: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet private weak var titleLbl: UILabel!

    //    static var shared = PickerVC()
    var currentVC: UIViewController!
    var dataArray: [PickerModel] = []
    var selectedID: Int?
    var selectedValue = ""
    var didPickValue: ((Int, String)->())?

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        picker.reloadAllComponents()
        if let selectedIndex = dataArray.firstIndex(where: { $0.id == selectedID }) {
            picker.selectRow(selectedIndex, inComponent: 0, animated: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (dataArray.count > 0) {
            selectedID = dataArray[row].id
            selectedValue = dataArray[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let title = dataArray[row].name
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func show(vc: UIViewController, array: [PickerModel], selectedID: Int?, title: String) {
        OperationQueue.main.addOperation {
            self.currentVC = vc
            self.currentVC.view.endEditing(true)
            let sheetOptions = SheetOptions(pullBarHeight: 10, presentingViewCornerRadius: 20, shouldExtendBackground: true, setIntrinsicHeightOnNavigationControllers: nil, useFullScreenMode: false, shrinkPresentingViewController: true, useInlineMode: false, horizontalPadding: 0, maxWidth: nil)
            let sheetVC = SheetViewController(controller: self, sizes: [.percent(0.4)], options: sheetOptions)
            sheetVC.gripColor = .clear
            sheetVC.cornerRadius = 20
            sheetVC.pullBarBackgroundColor = UIColor.clear
            sheetVC.dismissOnPull = true
            sheetVC.dismissOnOverlayTap = true
            
            self.currentVC.present(sheetVC, animated: true)
            
            self.dataArray = array
            if let selectedID = selectedID {
                self.selectedID = selectedID
                self.selectedValue = self.dataArray.first(where: { $0.id == selectedID })?.name ?? ""
            } else {
                self.selectedID = self.dataArray.first?.id
                self.selectedValue = self.dataArray.first?.name ?? ""
            }
            self.titleLbl.text = title

//            if (self.dataArray.count > 0) {
//                if self.selectedIndex < 0 || self.selectedIndex >= self.dataArray.count {
//                    self.selectedIndex = 0
//                }
//            }
        }
    }

    @IBAction func confirmBtnTapped(_ sender: Any?) {
        if self.dataArray.count > 0 {
            self.didPickValue?(selectedID ?? 0, selectedValue)
        } else {
            self.didPickValue?(0, selectedValue)

        }
        self.dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { }
    
    
}


