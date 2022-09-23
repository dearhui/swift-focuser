//
//  File.swift
//  
//
//  Created by Augustinas Malinauskas on 01/09/2021.
//

import SwiftUI
import Introspect

class TextFieldObserver: NSObject, UITextFieldDelegate {
    var onReturnTap: () -> () = {}
    var onEditingBegin: () -> () = {}
    var onEditingEnd: () -> () = {}
    weak var forwardToDelegate: UITextFieldDelegate?
    
    @available(iOS 2.0, *)
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return forwardToDelegate?.textFieldShouldBeginEditing?(textField) ?? true
    }

    @available(iOS 2.0, *)
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        print("textfield DidBegin")
        onEditingBegin()
        forwardToDelegate?.textFieldDidBeginEditing?(textField)
    }

    @available(iOS 2.0, *)
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return forwardToDelegate?.textFieldShouldEndEditing?(textField) ?? true
    }

    @available(iOS 2.0, *)
    func textFieldDidEndEditing(_ textField: UITextField) {
        forwardToDelegate?.textFieldDidEndEditing?(textField)
    }

    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
//        print("textfield DidEnd")
        onEditingEnd()
        forwardToDelegate?.textFieldDidEndEditing?(textField)
    }

    @available(iOS 2.0, *)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        forwardToDelegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
    
    @available(iOS 13.0, *)
    func textFieldDidChangeSelection(_ textField: UITextField) {
        forwardToDelegate?.textFieldDidChangeSelection?(textField)
    }

    @available(iOS 2.0, *)
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        forwardToDelegate?.textFieldShouldClear?(textField) ?? true
    }
    
    @available(iOS 2.0, *)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onReturnTap()
        return forwardToDelegate?.textFieldShouldReturn?(textField) ?? true
    }
}

public struct FocusModifier<Value: Hashable>: ViewModifier {
    @Binding var focusedField: Value?
    var equals: Value
    @State var observer = TextFieldObserver()
    
    public func body(content: Content) -> some View {
        content
            .introspectTextField { tf in
                if !(tf.delegate is TextFieldObserver) {
                    observer.forwardToDelegate = tf.delegate
                    tf.delegate = observer
                }
                
                observer.onEditingBegin = {
                    focusedField = equals
                }
                
                observer.onEditingEnd = {
                    focusedField = nil
                }
                
                observer.onReturnTap = {
                    focusedField = nil
                }
                
                if focusedField == equals {
                    tf.becomeFirstResponder()
                } else {
                    tf.endEditing(true)
                }
            }
            .simultaneousGesture(TapGesture().onEnded {
                focusedField = equals
            })
    }
}

public struct FocusModifierBool: ViewModifier {
    @Binding var isFocusedField: Bool
    @State var observer = TextFieldObserver()
    
    public func body(content: Content) -> some View {
        content
            .introspectTextField { tf in
                if !(tf.delegate is TextFieldObserver) {
                    observer.forwardToDelegate = tf.delegate
                    tf.delegate = observer
                }
                
                observer.onEditingBegin = {
                    isFocusedField = true
                }
                
                observer.onEditingEnd = {
                    isFocusedField = false
                }
                
                observer.onReturnTap = {
                    isFocusedField = false
                }
                
                if isFocusedField == true {
                    tf.becomeFirstResponder()
                } else {
                    tf.endEditing(true)
                }
            }
            .simultaneousGesture(TapGesture().onEnded {
                isFocusedField = true
            })
    }
}
