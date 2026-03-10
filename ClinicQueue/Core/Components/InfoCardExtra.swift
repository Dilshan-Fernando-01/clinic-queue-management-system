import SwiftUI

struct BloodTestCard: View {
    var image: String
    var title: String
    var specialText: String
    var detailLine1: String
    var detailLine2: String
    
    var showExtraSection: Bool = false
    var bottomTitleLeft: String = ""
    var listItems: [String] = []
    var bottomTitleRight: String = ""
    var bottomSubTextRight: String = ""
    
    var fee: String
    var onButtonTap: (() -> Void)?
    
    var isCheckboxSelectable: Bool = false
    var initiallySelected: Bool = false
    @State private var isSelected: Bool = false
    var onSelectionChange: ((Bool) -> Void)?

    init(
        image: String,
        title: String,
        specialText: String,
        detailLine1: String,
        detailLine2: String,
        showExtraSection: Bool = false,
        bottomTitleLeft: String = "",
        listItems: [String] = [],
        bottomTitleRight: String = "",
        bottomSubTextRight: String = "",
        fee: String,
        onButtonTap: (() -> Void)? = nil,
        isCheckboxSelectable: Bool = false,
        initiallySelected: Bool = false,
        onSelectionChange: ((Bool) -> Void)? = nil
    ) {
        self.image = image
        self.title = title
        self.specialText = specialText
        self.detailLine1 = detailLine1
        self.detailLine2 = detailLine2
        self.showExtraSection = showExtraSection
        self.bottomTitleLeft = bottomTitleLeft
        self.listItems = listItems
        self.bottomTitleRight = bottomTitleRight
        self.bottomSubTextRight = bottomSubTextRight
        self.fee = fee
        self.onButtonTap = onButtonTap
        self.isCheckboxSelectable = isCheckboxSelectable
        self.initiallySelected = initiallySelected
        self.onSelectionChange = onSelectionChange
        self._isSelected = State(initialValue: initiallySelected)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack(alignment: .top, spacing: 16) {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title).font(.headline).fontWeight(.bold)
                    Text(specialText).font(.subheadline).foregroundColor(Color(red: 0.3, green: 0.6, blue: 0.5))
                    Text(detailLine1).font(.caption).foregroundColor(.secondary)
                    Text(detailLine2).font(.caption).foregroundColor(.secondary)
                    
                    if !showExtraSection {
                        feeButton.padding(.top, 4)
                    }
                }
                Spacer()
            }
            
            if showExtraSection {
                Divider()
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(bottomTitleLeft).font(.caption).bold()
                        ForEach(listItems, id: \.self) { item in
                            Text("• \(item)").font(.caption2).foregroundColor(.secondary)
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(bottomTitleRight).font(.caption).bold()
                        Text(bottomSubTextRight).font(.caption2).foregroundColor(.secondary)
                    }
                }
                
                HStack {
                    Spacer()
                    feeButton
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(25)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(isSelected ? Color(red: 0.28, green: 0.58, blue: 0.53) : Color.gray.opacity(0.15),
                        lineWidth: isSelected ? 2 : 1)
        )
        .overlay(alignment: .topTrailing) {
            if isCheckboxSelectable && isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color(red: 0.28, green: 0.58, blue: 0.53))
                    .background(Circle().fill(Color.white))
                    .font(.system(size: 24))
                    .padding(12)
            }
        }
        .padding(.horizontal)
        .onTapGesture {
            if isCheckboxSelectable {
                isSelected.toggle()
                onSelectionChange?(isSelected)
            }
        }
    }
    
    private var feeButton: some View {
        Button(action: {
            onButtonTap?()
        }) {
            Text("Fee: \(fee)")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .padding(.vertical, 8)
                .padding(.horizontal, 24)
                .background(Color(red: 0.28, green: 0.58, blue: 0.53))
                .cornerRadius(20)
        }
        .buttonStyle(PlainButtonStyle())
    }
}


struct BloodTestCard_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 20) {
                BloodTestCard(
                    image: "doctor02",
                    title: "Blood Group & Rh",
                    specialText: "Selectable Component",
                    detailLine1: "Tap anywhere to select",
                    detailLine2: "Location: Room 02",
                    showExtraSection: false,
                    fee: "$25",
                    isCheckboxSelectable: true
                )
                
                BloodTestCard(
                    image: "doctor01",
                    title: "Comprehensive Lab",
                    specialText: "Standard Component",
                    detailLine1: "Estimated wait: ~10 min",
                    detailLine2: "Location: Room 05 - Lab Wing",
                    showExtraSection: true,
                    bottomTitleLeft: "Requirements",
                    listItems: ["Fast for 8 hours"],
                    bottomTitleRight: "Duration",
                    bottomSubTextRight: "15 - 20 mins",
                    fee: "$45",
                    isCheckboxSelectable: true
                )
            }
            .padding(.vertical)
        }
        .background(Color(white: 0.95))
    }
}
