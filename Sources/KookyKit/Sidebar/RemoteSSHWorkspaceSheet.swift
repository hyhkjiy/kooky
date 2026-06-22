import SwiftUI

struct RemoteSSHWorkspaceSheet: View {
    enum Mode {
        case create
        case edit

        var title: String {
            switch self {
            case .create: return "Open a remote workspace"
            case .edit: return "Edit remote workspace"
            }
        }

        var subtitle: String {
            switch self {
            case .create:
                return "New tabs and agents in this workspace launch over SSH in the remote path."
            case .edit:
                return "Future tabs and agents in this workspace launch with this SSH command and remote path."
            }
        }

        var submitLabel: String {
            switch self {
            case .create: return "create"
            case .edit: return "save"
            }
        }
    }

    let mode: Mode
    let submit: (RemoteWorkspace) -> Void
    let dismiss: () -> Void

    @State private var command = ""
    @State private var path = "~"

    init(mode: Mode = .create, remote: RemoteWorkspace? = nil, submit: @escaping (RemoteWorkspace) -> Void, dismiss: @escaping () -> Void) {
        self.mode = mode
        self.submit = submit
        self.dismiss = dismiss
        _command = State(initialValue: remote.map { "ssh \($0.normalizedDestination)" } ?? "")
        _path = State(initialValue: remote?.displayPath ?? "~")
    }

    private var canSubmit: Bool {
        !command.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("REMOTE-SSH-WORKSPACE")
                .font(Theme.mono(10, weight: .semibold))
                .foregroundStyle(Theme.chromeMuted)
                .tracking(1.2)
                .padding(.bottom, 18)

            Text(mode.title)
                .font(Theme.display(20, weight: .medium))
                .foregroundStyle(Theme.chromeForeground)

            Text(mode.subtitle)
                .font(Theme.mono(11.5))
                .foregroundStyle(Theme.chromeMuted)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 6)

            Rectangle()
                .fill(Theme.chromeHairline)
                .frame(width: 32, height: 1)
                .padding(.vertical, 22)

            VStack(alignment: .leading, spacing: 12) {
                field(label: "ssh-command", placeholder: "ssh devbox or root@host", text: $command)
                field(label: "remote-path", placeholder: "~/work/project", text: $path)
            }

            HStack(spacing: 10) {
                Spacer()
                BracketButton("cancel") { dismiss() }
                BracketButton(mode.submitLabel) {
                    submit(RemoteWorkspace(
                        destination: RemoteWorkspace.normalizedDestination(command),
                        path: path.trimmingCharacters(in: .whitespacesAndNewlines)
                    ))
                    dismiss()
                }
                .disabled(!canSubmit)
                .opacity(canSubmit ? 1 : 0.4)
            }
            .padding(.top, 22)
        }
        .padding(24)
        .frame(width: 440)
        .background(Theme.chromeBackground)
    }

    private func field(label: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(Theme.mono(10, weight: .semibold))
                .foregroundStyle(Theme.chromeMuted)
            TextField(placeholder, text: text)
                .textFieldStyle(.plain)
                .font(Theme.mono(12))
                .foregroundStyle(Theme.chromeForeground)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(Theme.chromeActive.opacity(0.35))
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Theme.chromeHairline, lineWidth: 1)
                }
        }
    }
}
