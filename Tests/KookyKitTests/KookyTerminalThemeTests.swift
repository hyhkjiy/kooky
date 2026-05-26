import XCTest
@testable import KookyKit

@MainActor
final class KookyTerminalThemeTests: XCTestCase {
    func testPresetLookupAcceptsStableId() {
        let theme = KookyTerminalTheme.preset(for: "solarized-light")
        XCTAssertEqual(theme?.title, "Solarized Light")
    }

    func testPresetLookupAcceptsLegacyDisplayName() {
        let theme = KookyTerminalTheme.preset(for: "Solarized Light")
        XCTAssertEqual(theme?.id, "solarized-light")
    }

    func testPresetExpandsToConcreteGhosttyColors() {
        let theme = KookyTerminalTheme.preset(for: "dracula")
        XCTAssertEqual(theme?.lines.first, "background = #282A36")
        XCTAssertEqual(theme?.lines.filter { $0.hasPrefix("palette = ") }.count, 16)
    }

    func testSettingsThemeSelectionPreservesUnknownRawTheme() {
        let state = KookySettingsModel.themeSelection(for: "/Users/me/.config/ghostty/themes/custom")
        XCTAssertEqual(state.selection, KookySettingsModel.customThemeSelection)
        XCTAssertEqual(
            KookySettingsModel.persistedThemeValue(
                selection: state.selection,
                customRawValue: state.customRawValue
            ),
            "/Users/me/.config/ghostty/themes/custom"
        )
    }

    func testSettingsDefaultThemeSelectionClearsRawThemeWhenChosen() {
        let defaultSelection = KookySettingsModel.themeSelection(for: nil).selection
        XCTAssertNil(
            KookySettingsModel.persistedThemeValue(
                selection: defaultSelection,
                customRawValue: "/Users/me/.config/ghostty/themes/custom"
            )
        )
    }

    func testSettingsPresetThemeSelectionPersistsStableId() {
        let state = KookySettingsModel.themeSelection(for: "Solarized Light")
        XCTAssertEqual(state.selection, "solarized-light")
        XCTAssertEqual(
            KookySettingsModel.persistedThemeValue(
                selection: state.selection,
                customRawValue: nil
            ),
            "solarized-light"
        )
    }
}
