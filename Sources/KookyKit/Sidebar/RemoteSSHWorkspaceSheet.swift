import SwiftUI

struct RemoteSSHWorkspaceSheet: View {
    let create: (RemoteWorkspace) -> Void
    let dismiss: () -> Void

    @State private var destination = ""
    @State private var path = "~"

    private var canSubmit: Bool {
        !destination.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("REMOTE-SSH-WORKSPACE")
                .font(Theme.mono(10, weight: .semibold))
                .foregroundStyle(Theme.chromeMuted)
                .tracking(1.2)
                .padding(.bottom, 18)

            Text("Open a remote workspace")
                .font(Theme.display(20, weight: .medium))
                .foregroundStyle(Theme.chromeForeground)

            Text("New tabs and agents in this workspace launch over SSH in the remote path.")
                .font(Theme.mono(11.5))
                .foregroundStyle(Theme.chromeMuted)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 6)

            Rectangle()
                .fill(Theme.chromeHairline)
                .frame(width: 32, height: 1)
                .padding(.vertical, 22)

            VStack(alignment: .leading, spacing: 12) {
                field(label: "destination", placeholder: "devbox or user@host", text: $destination)
                field(label: "remote-path", placeholder: "~/work/project", text: $path)
            }

            HStack(spacing: 10) {
                Spacer()
                BracketButton("cancel") { dismiss() }
                BracketButton("create") {
                    create(RemoteWorkspace(
                        destination: RemoteWorkspace.normalizedDestination(destination),
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
