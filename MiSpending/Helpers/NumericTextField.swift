import SwiftUI
import UIKit

/// A UIViewRepresentable that:
/// - Shows integer-only keyboard (numberPad)
/// - Always has a Done button on top (UIToolbar)
/// - Shows a placeholder (e.g. "e.g 500") when value == 0
struct NumericTextField: UIViewRepresentable {
    @Binding var value: Int
    let placeholder: String
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame: .zero)
        
        // 1) Use numberPad for integer-only input
        textField.keyboardType = .numberPad
        
        // 2) Attach a UIToolbar with a Done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: context.coordinator,
            action: #selector(Coordinator.doneTapped)
        )
        toolbar.items = [
            UIBarButtonItem.flexibleSpace(),
            doneButton
        ]
        
        textField.inputAccessoryView = toolbar
        
        // 3) Placeholder (light gray by default)
        textField.placeholder = placeholder
        
        // Set the delegate to handle typed digits + parse
        textField.delegate = context.coordinator
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        // If value == 0, show placeholder by making the text field empty.
        // If value != 0, show the integer as a string.
        
        if value == 0 {
            // If the user typed something previously, clear it so placeholder is visible
            if uiView.text?.isEmpty == false {
                uiView.text = ""
            }
        } else {
            let currentText = uiView.text ?? ""
            let newText = String(value)
            if currentText != newText {
                uiView.text = newText
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        let parent: NumericTextField
        
        init(_ parent: NumericTextField) {
            self.parent = parent
        }
        
        @objc func doneTapped() {
            // Dismiss the keyboard
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil,
                from: nil,
                for: nil
            )
        }
        
        // Only allow digits 0-9
        func textField(_ textField: UITextField,
                       shouldChangeCharactersIn range: NSRange,
                       replacementString string: String) -> Bool {
            let allowedChars = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedChars.isSuperset(of: characterSet)
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            // Parse the final input as an Int. If empty, treat as 0
            parent.value = Int(textField.text ?? "") ?? 0
        }
    }
}
