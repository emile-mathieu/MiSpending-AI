import SwiftUI
import UIKit

/// A UIViewRepresentable that:
/// - Shows integer-only keyboard (numberPad)
/// - Always has a Done button on top (UIToolbar) (This solved the problem due to View not re-rendering properly on appear and thus not showing ItemToolbar.)
/// - Shows a placeholder (e.g. "e.g 500") when value == 0
/// - Works for either `Int` or `Double` bindings (this was done for for UserInfoSheetView and ExpenseSaveView so I wouldn't need to write duplicate code.
/// - This code is INSPIRED and BASED on these 2 stackoverflow posts. I am referencing in CASE and EVEN tho, the implementation is DIFFERENT:
///  https://stackoverflow.com/questions/59003612/extend-swiftui-keyboard-with-custom-button
///  https://stackoverflow.com/questions/71592394/swiftui-custom-textfield-not-getting-updated-value

// Seems complicated but I make a struct to accept 2 types of possible value based on a UIViewRepresentable type.
struct NumberTextField<Value>: UIViewRepresentable
    where Value: Numeric,
          Value: LosslessStringConvertible,
          Value: ExpressibleByIntegerLiteral
{
    @Binding var value: Value
    let placeholder: String
    let currencyCode: String

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: NumberTextField
        weak var textField: UITextField?

        init(_ parent: NumberTextField) {
            self.parent = parent
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            guard var rawText = textField.text else { return }

            // Decide if this is an integer type vs. a floating type.
            let isIntegerType = Value.self is any BinaryInteger.Type

            // 1. Keep digits (and one decimal point if Double).
            if isIntegerType {
                // If binding is Int, remove all decimals.
                rawText = rawText.filter { "0123456789".contains($0) }
            } else {
                // If binding is Double, allow digits + decimal.
                rawText = rawText.filter { "0123456789.".contains($0) }
                // Remove extra decimal points if user typed more than one.
                if let firstDotIndex = rawText.firstIndex(of: ".") {
                    let afterDot = rawText.index(after: firstDotIndex)..<rawText.endIndex
                    let cleanedTail = rawText[afterDot].replacingOccurrences(of: ".", with: "")
                    rawText = rawText[..<firstDotIndex] + "." + cleanedTail
                }
            }

            // 2. Parse the cleaned string as Value.
            if let newValue = Value(rawText) {
                parent.value = newValue
            } else {
                parent.value = 0 // fallback if parse fails
            }
        }

        @objc func doneTapped() {
            textField?.resignFirstResponder()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.keyboardType = .numberPad
        tf.delegate = context.coordinator
        context.coordinator.textField = tf

        // This section of the code is where we add the Done button code.
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil,
                                        action: nil)
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .done,
                                         target: context.coordinator,
                                         action: #selector(Coordinator.doneTapped))
        toolbar.items = [flexSpace, doneButton]
        tf.inputAccessoryView = toolbar

        return tf
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        // Convert our numeric Value to a Decimal -> currency string
        // If it's zero, we'll show an empty string as a placeholder.
        if value == 0 {
            uiView.text = ""
        } else {
            // e.g., turn Int or Double into a Decimal for currency formatting
            let decimalValue = Decimal(string: String(value)) ?? 0
            uiView.text = decimalValue.formatted(.currency(code: currencyCode))
        }
    }
}


