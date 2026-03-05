//
//  TiltView.swift
//  IsTilted
//
//  Main UI — shows tilt status, black & white minimal style.
//

import SwiftUI

struct TiltView: View {
    @StateObject var viewModel: TiltViewModel = TiltViewModel()

    var body: some View {
        VStack(spacing: 32) {

            // Title
            Text("Is Tilted?")
                .font(.system(size: 32, weight: .bold, design: .rounded))

            // Instruction
            Text("Hold your device flat and tap Start")
                .font(.system(size: 15))
                .foregroundColor(.gray)

            Spacer()

            // Status icon
            Image(systemName: viewModel.statusSystemImageName)
                .font(.system(size: 64))
                .foregroundColor(viewModel.isRunning ? (viewModel.isLevel ? .black : .gray) : .gray.opacity(0.4))

            // Status text
            Text(viewModel.statusText)
                .font(.system(size: 26, weight: .bold, design: .rounded))

            // Live values
            if viewModel.isRunning {
                HStack(spacing: 24) {
                    VStack(spacing: 4) {
                        Text("Roll")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.gray)
                        Text(viewModel.rollFormatted)
                            .font(.system(size: 20, weight: .semibold, design: .monospaced))
                    }

                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 1, height: 40)

                    VStack(spacing: 4) {
                        Text("Pitch")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.gray)
                        Text(viewModel.pitchFormatted)
                            .font(.system(size: 20, weight: .semibold, design: .monospaced))
                    }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }

            Spacer()

            // Error message
            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.system(size: 14))
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            // Start / Stop button
            Button(action: {
                if viewModel.isRunning {
                    viewModel.stop()
                } else {
                    viewModel.start()
                }
            }) {
                Text(viewModel.isRunning ? "Stop" : "Start")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(viewModel.isRunning ? .black : .white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(viewModel.isRunning ? Color.white : Color.black)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black, lineWidth: viewModel.isRunning ? 1.5 : 0)
                    )
            }
            .padding(.horizontal)

            // Reset button
            if !viewModel.isRunning && (viewModel.rollDegrees != 0 || viewModel.pitchDegrees != 0) {
                Button(action: {
                    viewModel.reset()
                }) {
                    Text("Reset")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .padding(.vertical)
        .onDisappear {
            viewModel.stop()
        }
    }
}

#Preview {
    TiltView()
}
