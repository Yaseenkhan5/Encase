//
//  ScheduleDetailView.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import SwiftUI

struct ScheduleDetailView: View {
    
    // The states need to display all task at the bottom
    @EnvironmentObject var listViewModel: ListViewModel
    @State private var editMode = EditMode.inactive
    @State var showAddView = false
    @State var isEditMode = false
    // ---------------------------------------------------//
    
    
    @Environment(\.presentationMode) var mode
    @EnvironmentObject var scheduleModel: ScheduleModel
    @State var editItem = false
    var navigationBar:Bool = false
    
    var body: some View {
        ZStack {
            if let schedule = scheduleModel.selectedSchedule {
                ScrollView {
                    VStack (alignment: .leading) {
                        
                        // MARK: Schedule Image
                        ZStack {
                            Image(uiImage: schedule.getImage(width: 600))
                                .resizable()
                                .scaledToFill()
                                .frame(maxHeight: 300)
                                .background(Color.gray.opacity(0.2))
                                .clipped()
                            
                            if let urls = URL(string: schedule.urls) {
                                Link(destination: urls) {
                                    Image(systemName: "link.circle")
                                        .foregroundColor(.blue)
                                        .font(.largeTitle)
                                        .position(x: 360, y: 35)
                                }
                            }
                        }

                        
                        // MARK: Schedule title
                        Text(schedule.name)
                            .bold()
                            .padding(.top, 20)
                            .padding(.leading)
                            //.palatinoFont(24, weight: .bold)
                            .font(.system(size: 24,weight: .bold))
                        
                        HStack {
                            if let claseURL = URL(string: schedule.clase) {
                                Link(destination: claseURL) {
                                    Image(systemName: "video.circle")
                                        .foregroundColor(.blue)
                                        .font(.largeTitle)
                                        .position(x: 60, y: 20)
                                }
                            }
                            if let recursosURL = URL(string: schedule.recursos) {
                                Link(destination: recursosURL) {
                                    Image(systemName: "person.crop.circle")
                                        .foregroundColor(.blue)
                                        .font(.largeTitle)
                                        .position(x: 60, y: 20)
                                }
                            }
                            if let chatURL = URL(string: schedule.chat) {
                                Link(destination: chatURL) {
                                    Image(systemName: "phone.circle")
                                        .foregroundColor(.blue)
                                        .font(.largeTitle)
                                        .position(x: 60, y: 20)
                                }
                            }
                        }
                        .padding(5)
                        
                        Divider()
                        
                        // MARK: Links
                        VStack(alignment: .leading) {
                            Text("Schedule")
                                //.palatinoFont(16, weight: .bold)
                                .font(.system(size: 16,weight: .bold))
                                .padding([.bottom, .top], 5)
                            
                            ForEach(schedule.times, id:\.self){ subjectTime in
                                Label {
                                    Text(subjectTime.day_index.dayName + " at " + subjectTime.time.getString())
                                } icon: {
                                    Image(systemName: "clock")
                                }
                                .padding(.bottom, 5)
                                //.palatinoFont(15, weight: .regular)
                                .font(.system(size: 15,weight: .regular))
                            }
                            
                        }
                        .padding(.horizontal)
                        
                        // MARK: Divider
                        Divider()
                        
                        // MARK: More Information
                        VStack(alignment: .leading) {
                            Text("Aditional Information")
                                //.palatinoFont(16, weight: .bold)
                                .font(.system(size: 16,weight: .bold))
                                .padding([.bottom, .top], 5)
                            
                            ForEach(schedule.moreinfo, id:\.self) { info in
                                Text(info)
                                    //.palatinoFont(15, weight: .regular)
                                    .font(.system(size: 15,weight: .regular))
                                    .padding(.bottom, 5)
                            }
                        }
                        .padding(.horizontal)
                        
                        Divider()
                        
                        VStack(alignment: .leading) {
                            
                            Text("Pending Tasks")
                                .font(.system(size: 16,weight: .bold))
                                .padding([.bottom, .top], 5)
                            
                            
                            // Should only display the tasks of that specific topic
                            
                            VStack {
                                
                                ForEach(listViewModel.items) { item in
                                    ListRowView(item: item) {
                                        withAnimation(.linear) {
                                            listViewModel.updateItem(item: item)
                                        }
                                    } editBtn: {
                                        self.listViewModel.selectedItemToEdit = item
                                        self.isEditMode = true
                                        self.showAddView = true
                                    }
                                }
                            }
  
                        }
                        .padding(.horizontal)
                        
                        Divider()
                    }
                }
            
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            self.edit()
                        } label: {
                            Label("Edit", systemImage: "pencil")
                                //.palatinoFont(16, weight: .bold)
                                .font(.system(size: 16,weight: .bold))
                                .padding()
                        }
                    }
                }
                .overlay(
                    ZStack {
                        if !navigationBar {
                            Button {
                                self.edit()
                            } label: {
                                Label("Edit", systemImage: "pencil")
                                    .padding(8)
                                    .background(Color.white)
                                    .clipShape(Capsule())
                            }
                            .padding()
                        }
                    }
                    
                    ,alignment: .topLeading
                )
                .sheet(isPresented: $editItem){
                    AddScheduleView()
                        .environmentObject(scheduleModel)
                }
                
                
            }else {
                Text("DELETED!")
                    .font(.title)
                    .onAppear {
                        self.mode.wrappedValue.dismiss()
                    }
            }
        }
    }
    
    private func edit() {
        if let schedule = scheduleModel.selectedSchedule {
            self.scheduleModel.selectedSchedule = schedule
                    self.editItem.toggle()
        }
    }
}



