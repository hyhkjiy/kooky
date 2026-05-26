import Foundation

struct KookyTerminalTheme: Identifiable, Hashable {
    let id: String
    let title: String
    let backgroundHex: String
    let foregroundHex: String
    let lines: [String]

    static let presets: [KookyTerminalTheme] = [
        .init(
            id: "catppuccin-frappe",
            title: "Catppuccin Frappe",
            background: "#303446",
            foreground: "#C6D0F5",
            cursor: "#F2D5CF",
            selectionBackground: "#626880",
            selectionForeground: "#C6D0F5",
            palette: [
                "#51576D", "#E78284", "#A6D189", "#E5C890",
                "#8CAAEE", "#F4B8E4", "#81C8BE", "#A5ADCE",
                "#626880", "#E67172", "#8EC772", "#D9BA73",
                "#7B9EF0", "#F2A4DB", "#5ABFB5", "#B5BFE2",
            ]
        ),
        .init(
            id: "catppuccin-latte",
            title: "Catppuccin Latte",
            background: "#EFF1F5",
            foreground: "#4C4F69",
            cursor: "#DC8A78",
            selectionBackground: "#CCD0DA",
            selectionForeground: "#4C4F69",
            palette: [
                "#5C5F77", "#D20F39", "#40A02B", "#DF8E1D",
                "#1E66F5", "#EA76CB", "#179299", "#ACB0BE",
                "#6C6F85", "#D20F39", "#40A02B", "#DF8E1D",
                "#1E66F5", "#EA76CB", "#179299", "#BCC0CC",
            ]
        ),
        .init(
            id: "dracula",
            title: "Dracula",
            background: "#282A36",
            foreground: "#F8F8F2",
            cursor: "#F8F8F2",
            selectionBackground: "#44475A",
            selectionForeground: "#F8F8F2",
            palette: [
                "#000000", "#FF5555", "#50FA7B", "#F1FA8C",
                "#BD93F9", "#FF79C6", "#8BE9FD", "#BBBBBB",
                "#555555", "#FF5555", "#50FA7B", "#F1FA8C",
                "#BD93F9", "#FF79C6", "#8BE9FD", "#FFFFFF",
            ]
        ),
        .init(
            id: "rose-pine",
            title: "Rosé Pine",
            background: "#191724",
            foreground: "#E0DEF4",
            cursor: "#E0DEF4",
            selectionBackground: "#403D52",
            selectionForeground: "#E0DEF4",
            palette: [
                "#26233A", "#EB6F92", "#31748F", "#F6C177",
                "#9CCFD8", "#C4A7E7", "#EBBCBA", "#E0DEF4",
                "#6E6A86", "#EB6F92", "#31748F", "#F6C177",
                "#9CCFD8", "#C4A7E7", "#EBBCBA", "#E0DEF4",
            ]
        ),
        .init(
            id: "rose-pine-dawn",
            title: "Rosé Pine Dawn",
            background: "#FAF4ED",
            foreground: "#575279",
            cursor: "#575279",
            selectionBackground: "#DFDAD9",
            selectionForeground: "#575279",
            palette: [
                "#F2E9E1", "#B4637A", "#286983", "#EA9D34",
                "#56949F", "#907AA9", "#D7827E", "#575279",
                "#9893A5", "#B4637A", "#286983", "#EA9D34",
                "#56949F", "#907AA9", "#D7827E", "#575279",
            ]
        ),
        .init(
            id: "solarized-dark",
            title: "Solarized Dark",
            background: "#002B36",
            foreground: "#839496",
            cursor: "#93A1A1",
            selectionBackground: "#073642",
            selectionForeground: "#93A1A1",
            palette: [
                "#073642", "#DC322F", "#859900", "#B58900",
                "#268BD2", "#D33682", "#2AA198", "#EEE8D5",
                "#002B36", "#CB4B16", "#586E75", "#657B83",
                "#839496", "#6C71C4", "#93A1A1", "#FDF6E3",
            ]
        ),
        .init(
            id: "solarized-light",
            title: "Solarized Light",
            background: "#FDF6E3",
            foreground: "#657B83",
            cursor: "#586E75",
            selectionBackground: "#EEE8D5",
            selectionForeground: "#586E75",
            palette: [
                "#073642", "#DC322F", "#859900", "#B58900",
                "#268BD2", "#D33682", "#2AA198", "#EEE8D5",
                "#002B36", "#CB4B16", "#586E75", "#657B83",
                "#839496", "#6C71C4", "#93A1A1", "#FDF6E3",
            ]
        ),
    ]

    static func preset(for storedValue: String) -> KookyTerminalTheme? {
        let trimmed = storedValue.trimmingCharacters(in: .whitespacesAndNewlines)
        return presets.first { $0.id == trimmed || $0.title == trimmed }
    }

    private init(
        id: String,
        title: String,
        background: String,
        foreground: String,
        cursor: String,
        selectionBackground: String,
        selectionForeground: String,
        palette: [String]
    ) {
        self.id = id
        self.title = title
        self.backgroundHex = background
        self.foregroundHex = foreground
        self.lines = [
            "background = \(background)",
            "foreground = \(foreground)",
            "cursor-color = \(cursor)",
            "selection-background = \(selectionBackground)",
            "selection-foreground = \(selectionForeground)",
        ] + palette.enumerated().map { idx, color in
            "palette = \(idx)=\(color)"
        }
    }
}
