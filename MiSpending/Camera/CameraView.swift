//
//  CameraPreviewView.swift
//  MiSpending
//
//  Created by Emile Mathieu on 19/02/2025.
//

import SwiftUI
import PhotosUI
import AVFoundation

/// CameraPreviewView - A SwiftUI view that integrates the iOS camera using AVFoundation.
/// This implementation follows Apple's official guidelines for AVCaptureSession.
/// Reference: https://developer.apple.com/documentation/avfoundation/avcapturesession
struct CameraView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var capturedImage: UIImage? = nil
    @State private var showExpenseCameraView = false
    @StateObject private var cameraModel = CameraModel()
    @Binding var isSheetPresented: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .center) {
                    Text("Please Add or Scan a Receipt")
                        .font(.headline)
                        .foregroundStyle(.black)
                    
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                // Child 1: Camera Preview Container
                CameraPreviewContainer(cameraModel: cameraModel)
                    .aspectRatio(3/4, contentMode: .fill)
                
                // Child 2: Camera Controls (buttons, overlays, etc.)
                VStack {
                    Spacer()
                    
                    HStack(alignment: .center) {
                        PhotosPicker(selection: $selectedItem, matching: .any(of: [.images, .livePhotos, .not(.videos)]), photoLibrary: .shared()) {
                            ZStack {
                                Circle().fill(.gray.opacity(0.3)).frame(width: 50, height: 50)
                                Image(systemName: "photo.on.rectangle.angled.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(.black)
                            }
                        }
                        .padding(.leading, 20)
                        .onChange(of: selectedItem) { oldItem, newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    
                                    let result = try? await checkImageHelper(image: uiImage)
                                    if result == "Receipt"{
                                        selectedImage = uiImage
                                        showExpenseCameraView = true
                                    }
                                }
                            }
                        }
                        .navigationDestination(isPresented: $showExpenseCameraView) {
                            if let selectedImage {
                                ExpenseCameraView(
                                    imageTaken: selectedImage,
                                    isSheetPresented: $isSheetPresented
                                )
                            } else {
                                Text("Not a Receipt!")
                            }
                        }
                        
                        
                        Spacer()
                        Button {
                            cameraModel.capturePhoto()
                        } label: {
                            Image(systemName: "camera.circle.fill")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.black)
                        }
                        Spacer()
                        Color.clear.frame(width: 70, height: 1)
                        
                    }
                    .padding(.bottom, 20)
                }.padding(.top, 20)
            }
            .onAppear {
               // Configure camera only once when this view appears
               // Comment to not crash the view
                cameraModel.configure()
            }
            .alert(isPresented: $cameraModel.showAlert) {
                Alert(title: Text("Camera Error"),
                      message: Text(cameraModel.alertMessage),
                      dismissButton: .default(Text("OK"), action: {dismiss()}))
                
            }
            .onChange(of: cameraModel.capturedImage) { _, newImage in
                Task {
                    guard let newImage = newImage else { return }
                    let result = try? await checkImageHelper(image: newImage)
                    if result == "Receipt" {
                        capturedImage = newImage
                        showExpenseCameraView = true
                    }
                }
            }
            .navigationDestination(isPresented: $showExpenseCameraView) {
                if let capturedImage {
                    ExpenseCameraView(
                        imageTaken: capturedImage,
                        isSheetPresented: $isSheetPresented
                    )
                } else {
                    Text("Not a Receipt!")
                }
            }
            .background(Color.white)
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .foregroundStyle(.black)
                            .font(.system(size: 20))
                    }
                }
            }
        }
    }
}

#Preview{
//    Disabled in preview because it breaks since it's trying to enable the camera
//    @Previewable @State var showPreview: Bool = true
//    CameraView(isSheetPresented: $showPreview)
}
