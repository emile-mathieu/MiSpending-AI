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
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var scheme
    
    @Binding var isSheetPresented: Bool
    
    @State private var CameraViewText: String = "Please Add or Scan a Receipt"
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var showExpenseCameraView = false
    
    // Use the new ViewModel (which uses CameraManager) for the live feed.
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .center) {
                    Text(CameraViewText)
                        .font(.headline)
                        .foregroundStyle(.black)
                    
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                // Child 1: Camera Preview Container
                GeometryReader { geometry in
                    if let frame = viewModel.currentFrame {
                        Image(decorative: frame, scale: 1)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width,
                                   height: geometry.size.height)
                            .clipped()
                    } else {
                        CameraNotAvailable()
                            .frame(width: geometry.size.width,
                                   height: geometry.size.height)
                    }
                }
                .aspectRatio(3/4, contentMode: .fill)
                
                // Child 2: Camera Controls (buttons, overlays, etc.)
                VStack {
                    Spacer()
                    
                    HStack(alignment: .center) {
                        PhotosPicker(selection: $selectedItem, matching: .any(of: [.images]), photoLibrary: .shared()) {
                            ZStack {
                                Circle().fill(.gray.opacity(0.3)).frame(width: 50, height: 50)
                                Image(systemName: "photo.on.rectangle.angled.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(.primary)
                            }
                        }
                        .padding(.leading, 20)
                        .onChange(of: selectedItem) { _, newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                        selectedImage = uiImage
                                        showExpenseCameraView = true
                                } else {
                                    CameraViewText = "Not a receipt!"
                                }
                            }
                        }
                        
                        Spacer()
                        Button {
                            if let cgImage = viewModel.currentFrame {
                                let uiImage = UIImage(cgImage: cgImage)
                                Task {
                                    selectedImage = uiImage
                                    showExpenseCameraView = true
                                }
                            }
                        } label: {
                            Image(systemName: "camera.circle.fill")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .foregroundStyle(.primary)
                        }
                        Spacer()
                        Color.clear.frame(width: 70, height: 1)
                        
                    }
                    .padding(.bottom, 20)
                }.padding(.top, 20)
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Camera Error"),
                      message: Text(viewModel.alertMessage),
                      dismissButton: .default(Text("OK"), action: {dismiss()}))
                
            }
            .navigationDestination(isPresented: $showExpenseCameraView) {
                if let image = selectedImage {
                    ExpenseCameraView(
                        imageTaken: image,
                        isSheetPresented: $isSheetPresented
                    )
                }
            }
            .onAppear {
                viewModel.restartSession()
            }
            .onDisappear {
                viewModel.stopSession()
            }
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .foregroundStyle(.primary)
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
