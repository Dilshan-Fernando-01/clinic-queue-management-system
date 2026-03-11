//
//  ProfileView.swift
//  ClinicQueue
//
//  Created by Keshana Liyanaarachchi on 2026-03-11.
//

import SwiftUI

struct MenuItem: Identifiable {
    let id = UUID()
    let title: String
    let iconName: String
    let gradientColors: [Color]
    var destination: AnyView?
    var isLogout: Bool = false
}

struct ProfileView: View {
    
    let menuItems: [MenuItem] = [
        MenuItem(
            title: "My Profile",
            iconName: "person.fill",
            gradientColors: [Color(hex: "4FC3F7"), Color(hex: "0288D1")],
            destination: AnyView(SettingsView())
        ),
        
        MenuItem(
            title: "Settings",
            iconName: "gearshape.fill",
            gradientColors: [Color(hex: "4DB6AC"), Color(hex: "00796B")],
            destination: AnyView(SettingsView())
        ),
        
        MenuItem(
            title: "Notifications",
            iconName: "bell.fill",
            gradientColors: [Color(hex: "7986CB"), Color(hex: "3949AB")],
            destination: AnyView(NotificationView())
        ),
        
        MenuItem(
            title: "Transaction History",
            iconName: "envelope.fill",
            gradientColors: [Color(hex: "66BB6A"), Color(hex: "2E7D32")],
            destination: AnyView(TransactionHistory())
        ),
        
        MenuItem(
            title: "Test History",
            iconName: "clipboard.fill",
            gradientColors: [Color(hex: "EF5350"), Color(hex: "B71C1C")],
            destination: AnyView(TestHistoryView())
        ),
        
        MenuItem(
            title: "Channeling History",
            iconName: "stethoscope",
            gradientColors: [Color(hex: "FFA726"), Color(hex: "E65100")],
            destination: AnyView(ChannelingHistoryView())
        ),
        
        MenuItem(
            title: "Logout",
            iconName: "rectangle.portrait.and.arrow.right.fill",
            gradientColors: [Color(hex: "EF5350"), Color(hex: "C62828")],
            destination: nil,
            isLogout: true
        ),
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    
                    HStack(spacing: 14) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 58, height: 58)
                            .foregroundColor(.gray)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                            )
                            .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 3)
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text("John Doe")
                                .font(.system(size: 17, weight: .bold))
                            
                            Text("johnDo26@gmail.com")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                    
                    VStack(spacing: 4) {
                        ForEach(menuItems) { item in
                            MenuRowView(item: item)
                        }
                    }
                    .padding(.horizontal, 12)
                }
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct MenuRowView: View {
    let item: MenuItem
    @State private var isPressed = false
    
    var body: some View {
        
        if let destination = item.destination {
            NavigationLink(destination: destination) {
                rowContent
            }
            .buttonStyle(PlainButtonStyle())
        } else {
            Button(action: {
                print("Logout tapped")
            }) {
                rowContent
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    var rowContent: some View {
        HStack(spacing: 16) {
            
            ZStack {
                LinearGradient(
                    colors: item.gradientColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(width: 46, height: 46)
                .cornerRadius(13)
                
                Image(systemName: item.iconName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            Text(item.title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(item.isLogout ? .red : .primary)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}



struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
