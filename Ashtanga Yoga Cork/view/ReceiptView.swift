//
//  PdfView.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 01/05/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import PDFKit

struct ReceiptView: View, Observer {
    var pdfview: PDFKitRepresentedView = PDFKitRepresentedView()

    var body: some View {
        VStack( alignment: .leading, spacing: 0) {
            BackButton(UpdateSource.bug)
            self.pdfview
        }
    }
    
    func update(source: UpdateSource, requestview: RequestedView, loginstate: LoginStatus, payload: Payload, error: ApiError) {
        if source == UpdateSource.scraper && requestview == RequestedView.receipt {
            let pl = payload.payload as? DownloadTaskComplete ?? nil
            if pl != nil {
                self.pdfview.updateDocument(pl!.pdfurl!, pl!.data!)
            }
        }
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    let pdfView = PDFView()
    
    func updateDocument(_ url: URL, _ data: Data) {
        print(url.path)
        let fileExists = FileManager().fileExists(atPath: (url.path))
        print(fileExists)
        self.pdfView.document = PDFDocument(data: data)
    }

    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        self.pdfView.autoScales = true
        return self.pdfView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        // Update the view.
    }
}
