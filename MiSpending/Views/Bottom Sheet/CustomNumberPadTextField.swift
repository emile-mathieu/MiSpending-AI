//
//  CustomNumberPadTextField.swift
//  MiSpending
//
//  Created by Emile Mathieu on 24/03/2025.
//

import SwiftUI

// A UIViewRepresentable that wraps a UITextField for number pad input,
// using a binding to an Int. It adds a toolbar with a Done button that uses the
// system image "keyboard.chevron.compact.down" tinted black.
// This was done because the toolbarItem only show's up for the first Textfield.
// The code is HEAVILY INFLUENCED from the Reference:
// • Stack Overflow: https://stackoverflow.com/questions/70511748/swiftui-adding-a-keyboard-toolbar-button-for-only-one-textfield-adds-it-for-al
struct CustomNumberPadTextField: UIViewRepresentable {
    @Binding var value: Int
    var placeholder: String = "Amount e.g., 500"
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomNumberPadTextField
        weak var textField: UITextField?
        
        init(parent: CustomNumberPadTextField) {
            self.parent = parent
        }
        
        // Called when the Done button is tapped.
        @objc func doneTapped() {
            textField?.resignFirstResponder()
        }
        
        // Update the binding as the text changes.
        func textFieldDidChangeSelection(_ textField: UITextField) {
            // Try to convert the text to an Int.
            if let text = textField.text, let newValue = Int(text) {
                parent.value = newValue
            } else {
                // If conversion fails, set to 0 (or choose to ignore).
                parent.value = 0
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UITextField {
        let tf = UITextField(frame: .zero)
        tf.placeholder = placeholder
        tf.keyboardType = .numberPad
        tf.delegate = context.coordinator
        context.coordinator.textField = tf
        
        // Create a minimal toolbar with a "Done" button.
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        // Create a Done button using the system image "keyboard.chevron.compact.down".
        let doneImage = UIImage(systemName: "keyboard.chevron.compact.down")
        let doneButton = UIBarButtonItem(image: doneImage, style: .done, target: context.coordinator, action: #selector(Coordinator.doneTapped))
        doneButton.tintColor = .label
        toolbar.items = [spacer, doneButton]
        tf.inputAccessoryView = toolbar
        
        return tf
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        // Update the UITextField's text if it doesn't match the current binding.
        let newText = value == 0 ? "" : String(value)
        if uiView.text != newText {
            uiView.text = newText
        }
    }
}
