//
//  SetDateOfNewsView.swift
//  NewsExplorer
//
//  Created by Dmytro Hetman on 06.10.2023.
//

import SwiftUI

struct SetDateOfNewsView: View {
    @ObservedObject var viewModel: NewsViewModel
    @Environment(\.dismiss) var dismiss
    @State var startDate: Date = .now.monthBefore
    @State var endDate: Date = .now
    var startDateConstraint: Date = .now.monthBefore
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Date of News")
                .bold()
                .font(.headline)
                .padding(.top, 10)
            HStack {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
                .padding()
                Spacer()
            }
            VStack {
                Group {
                    DatePicker("Start Date",
                               selection: $startDate,
                               in: startDateConstraint...endDate,
                               displayedComponents: [.date, .hourAndMinute])
                    DatePicker("End Date",
                               selection: $endDate,
                               in: startDateConstraint...Date(),
                               displayedComponents: [.date, .hourAndMinute])
                }
                .padding(5)
            }
            HStack(alignment: .center) {
                Button {
                    viewModel.discardDateLimits()
                    dismiss()
                } label: {
                    Text("Discard")
                        .bold()
                        .foregroundStyle(.white)
                }
                .frame(width: 84, height: 32)
                .background(Color(red: 0.5, green: 0, blue: 0))
                .clipShape(Capsule())
                .padding(.leading, 20)
                
                Spacer()
                
                Button {
                    viewModel.setDateLimits(startDate: startDate, endDate: endDate)
                    dismiss()
                } label: {
                    Text("Save")
                        .bold()
                        .foregroundStyle(.white)
                }
                .frame(width: 84, height: 32)
                .background(Color(red: 0, green: 0, blue: 0.5))
                .clipShape(Capsule())
                .padding(.trailing, 20)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 20)
            Text("Due to API restrictions you can search news only for previous month")
            Spacer()
        }
        .padding()
    }
}
