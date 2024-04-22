//
//  Profile.swift
//  Loot
//
//  Created by Kenna Chase on 4/22/24.
//

import SwiftUI

@MainActor
class ProfileStore: ObservableObject {
    @Published var playerProfile: Profile = Profile()

    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("profile.data")
    }

    func load() async throws {
        let task = Task<Profile, Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return Profile()
            }
            let savedProfile = try JSONDecoder().decode(Profile.self, from: data)
            return savedProfile
        }
        let profile = try await task.value
        self.playerProfile = profile
    }

    func save(profile: Profile) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(profile)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
    }
}

    extension ProfileStore {
        struct Profile: Identifiable, Codable {
            let id: UUID
            var name: String
            var background: String // Hex
            var imageNum: Int

            init(id: UUID, name: String, background: String, imageNum: Int) {
                self.id = id
                self.name = name
                self.background = background
                self.imageNum = imageNum
            }
            init() {
                self.id = UUID()
                self.name = ""
                self.background = "#000000"
                self.imageNum = 1
            }

//            func generateUUID(name: String) -> UUID {
//                // TODO: Implement UUID ... 
//                return 0
//            }
        }
}
