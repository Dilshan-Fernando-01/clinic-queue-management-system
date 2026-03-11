//
//  ImagingCategoriesData.swift
//  ClinicQueue
//
//  Created by Keshana Liyanaarachchi on 2026-03-11.
//

import Foundation

struct ImagingCategoriesData {
    static let categories: [CategoryItem] = [
        CategoryItem(title: "X-Ray", icon: "GeneralIcon"),
        CategoryItem(title: "CT Scan", icon: "CardiologyIcon"),
        CategoryItem(title: "MRI", icon: "NeurologyIcon"),
        CategoryItem(title: "Ultrasound", icon: "OrthoIcon"),
        CategoryItem(title: "Mammography", icon: "OBGYNIcon"),
        CategoryItem(title: "Bone Density", icon: "OrthoIcon"),
        CategoryItem(title: "Cardiac Imaging", icon: "CardiologyIcon"),
        CategoryItem(title: "Emergency", icon: "ENTIcon"),
    ]
}
