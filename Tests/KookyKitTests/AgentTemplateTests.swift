import XCTest
@testable import KookyKit

@MainActor
final class AgentTemplateTests: XCTestCase {
    func testTerminalTemplateHasNoAgentEnv() {
        XCTAssertNil(AgentTemplate.terminal.makeSessionConfig().environment["KOOKY_AGENT"])
    }

    func testAgentTemplatesPublishKookyAgentEnv() {
        for template in AgentTemplate.all where template.id != "terminal" {
            XCTAssertEqual(
                template.makeSessionConfig().environment["KOOKY_AGENT"],
                template.initialCommand,
                "agent template \(template.id) must publish KOOKY_AGENT matching its initialCommand"
            )
        }
    }

    func testAllTemplatesAreUniqueAndIncludeTerminal() {
        let ids = AgentTemplate.all.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count, "ids must be unique")
        XCTAssertTrue(ids.contains("terminal"))
    }

    func testTerminalTemplateUsesUserDefaultShell() {
        let expected = ProcessInfo.processInfo.environment["SHELL"] ?? "/bin/zsh"
        XCTAssertEqual(AgentTemplate.terminal.makeSessionConfig().command, expected)
    }

    func testAgentTemplatesPickAShellWithIntegrationWrapper() {
        // Agent must run under one of our wrappers (zsh ZDOTDIR or bash
        // --rcfile) — anything else means KOOKY_AGENT never fires.
        for template in AgentTemplate.all where template.id != "terminal" {
            let cmd = template.makeSessionConfig().command
            XCTAssertTrue(
                cmd == "/bin/zsh" || cmd.contains("kooky-bash-launch-"),
                "agent template \(template.id) launched without a kooky shell wrapper: \(cmd)"
            )
        }
    }

    func testBuiltinTemplatesHaveNoBaseAgentId() {
        for template in AgentTemplate.builtin {
            XCTAssertNil(template.baseAgentId, "builtin \(template.id) must not declare a base")
        }
    }

    func testFromCustomSnapshotsBaseAgentId() {
        let data = CustomAgentData(id: "claude-opus", baseAgentId: "claude-code")
        XCTAssertEqual(AgentTemplate.fromCustom(data).baseAgentId, "claude-code")
    }

    func testFromCustomTreatsEmptyBaseAsNil() {
        let data = CustomAgentData(id: "loose-custom", command: "aichat")
        XCTAssertNil(AgentTemplate.fromCustom(data).baseAgentId)
    }
}
