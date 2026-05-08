import SwiftUI

/// Shared row background palette for sidebar / tab / popover-menu rows.
/// Centralizes the hover/active alpha values so a future theme toggle has one
/// place to change.
extension View {
    func hoverableRowBackground(isActive: Bool = false, isHovered: Bool) -> some View {
        let color: Color
        if isActive {
            color = Color.white.opacity(0.10)
        } else if isHovered {
            color = Color.white.opacity(0.05)
        } else {
            color = .clear
        }
        return background(color)
    }

    /// Menu rows are single-state: hover === selected, so they use the active
    /// alpha (0.10) instead of the lighter hover (0.05).
    func menuRowHover(_ isHovered: Bool) -> some View {
        background(isHovered ? Color.white.opacity(0.10) : Color.clear)
    }
}

/// One row in a kooky popover menu — tab right-click, "+" agent menu, etc.
/// Shares hover treatment + typography with the rest of the chrome.
/// Optional `shortcut` renders right-aligned in the same monospace style
/// AppKit uses for native NSMenuItem key equivalents (e.g. "⌘W", "⌘⇧D").
struct KookyMenuRow<Leading: View>: View {
    let title: String
    let shortcut: String?
    let isDisabled: Bool
    let leading: Leading
    let action: () -> Void

    @State private var isHovered = false

    init(
        title: String,
        shortcut: String? = nil,
        isDisabled: Bool = false,
        @ViewBuilder leading: () -> Leading,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.shortcut = shortcut
        self.isDisabled = isDisabled
        self.leading = leading()
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.space2) {
                leading
                Text(title)
                    .font(Theme.display(12.5, weight: .regular))
                    .foregroundStyle(isDisabled ? Theme.chromeMuted : Theme.chromeForeground)
                Spacer(minLength: 0)
                if let shortcut {
                    // System font (SF Pro) — the ⌘⇧⌥⌃ glyphs are designed for
                    // it; in JetBrains Mono they render heavier and off-baseline,
                    // which looks alien next to the row title.
                    Text(shortcut)
                        .font(.system(size: 11.5, weight: .regular))
                        .tracking(0.5)
                        .foregroundStyle(isDisabled ? Theme.chromeMuted.opacity(0.6) : Theme.chromeMuted)
                        .padding(.leading, Theme.space2)
                }
            }
            .padding(.horizontal, Theme.space2 + 2)
            .padding(.vertical, 7)
            .frame(maxWidth: .infinity, alignment: .leading)
            .menuRowHover(isHovered && !isDisabled)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .onHover { isHovered = $0 && !isDisabled }
    }
}

extension KookyMenuRow where Leading == EmptyView {
    init(
        title: String,
        shortcut: String? = nil,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.init(
            title: title,
            shortcut: shortcut,
            isDisabled: isDisabled,
            leading: { EmptyView() },
            action: action
        )
    }
}

struct KookyMenuDivider: View {
    var body: some View {
        Rectangle()
            .fill(Theme.chromeHairline)
            .frame(height: 1)
            .padding(.vertical, 3)
            .padding(.horizontal, Theme.space2)
    }
}
