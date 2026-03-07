import SwiftUI

struct ServiceCard: View {
    let service: Service
    var isHighlighted: Bool = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(service.background)
                .shadow(color: Color.black.opacity(0.05),
                        radius: 10, x: 0, y: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(isHighlighted ? Color.purple : Color.clear,
                                lineWidth: 3)
                )

            VStack(alignment: .leading, spacing: 12) {
                // Icon with background
                Image(systemName: service.icon)
                    .font(.system(size: 24))
                    .foregroundColor(.black)
                    .frame(width: 44, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.white.opacity(0.8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(isHighlighted ? Color.purple.opacity(0.6)
                                                          : Color.black.opacity(0.06),
                                            lineWidth: isHighlighted ? 2 : 1)
                            )
                    )

                // Title - with minimum scale factor for long text
                Text(service.title)
                    .font(.headline.weight(.semibold))
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .fixedSize(horizontal: false, vertical: true)

                // Subtitle - with proper multiline display
                Text(service.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .minimumScaleFactor(0.8)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)

                Spacer(minLength: 0)
            }
            .padding(16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
    }
}
