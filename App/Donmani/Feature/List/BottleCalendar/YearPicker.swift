//
//  YearPicker.swift
//  Donmani
//
//  Created by 문종식 on 12/12/25.
//

import SwiftUI
import DesignSystem

struct YearPicker: UIViewRepresentable {
    var years: [Int]
    @Binding var selectedYearIndex: Int
    
    // Assign custom coordinator for delegate functions.
    func makeCoordinator() -> YearPicker.Coordinator {
        Coordinator(self)
    }
    
    // Creates the view object and configures its initial state.
    func makeUIView(context: UIViewRepresentableContext<YearPicker>) -> UIPickerView {
        let picker = UIPickerView(frame: .zero)
        picker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            picker.heightAnchor.constraint(equalToConstant: 150),
            picker.widthAnchor.constraint(equalToConstant: .screenWidth),
        ])
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIView(_ view: UIPickerView, context: UIViewRepresentableContext<YearPicker>) {
        view.selectRow(selectedYearIndex, inComponent: 0, animated: true)
    }
    
    func sizeThatFits(
        _ proposal: ProposedViewSize,
        uiView: UIPickerView,
        context: Context
    ) -> CGSize? {
        return CGSize(
            width: proposal.width ?? .infinity,
            height: 150
        )
    }
    
    
    // Coordinator acting as the delegate in SwiftUI.
    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: YearPicker
        
        //init(_:)
        init(_ pickerView: YearPicker) {
            self.parent = pickerView
        }
        
        // Set your custom row height here!
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
            54
        }
        
        //numberOfComponents(in:)
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            1
        }
        
        //pickerView(_:numberOfRowsInComponent:)
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            parent.years.count
        }
        
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            let label = (view as? UILabel) ?? UILabel()
            label.font = DFont.uiFont(.h3, weight: .semibold)
            label.textColor = UIColor(ColorPalette.Neutral.gray99)
            label.textAlignment = .center
            label.text = "\(parent.years[row])년"
            return label
        }
        
        //pickerView(_:didSelectRow:inComponent:)
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            parent.selectedYearIndex = row
        }
    }
}
