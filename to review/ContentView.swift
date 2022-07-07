//
//  ContentView.swift
//  to review
//
//  Created by Farrukh Askari on 17/06/2022.
//

//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundColor(.accentColor)
//            Text("Hello, world!")
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

import SwiftUI
import Combine
//import UIKit

struct MusicAlbum: Identifiable, Codable { //
    let title: String
    let artist: String
    let id: UUID = UUID() // should be let
    let coverArtURL: String

    // missing coding keys
    enum CodingKeys: String, CodingKey {
        case title = "album"
        case artist
        case coverArtURL = "cover"
//        case id
    }
}

class ViewModel: ObservableObject { //
    @Published var albums: [MusicAlbum] = []
    @Published var isLoading = true

    var cancellables = Set<AnyCancellable>() // spelling mistake

    init(albums: [MusicAlbum]) {
        self.albums = albums
    }

    func fetch_albums() {
        guard let url = URL(string: "https://1979673067.rsc.cdn77.org/music-albums.json") else { return } // check for validity
        
        URLSession.shared.dataTaskPublisher(for: url) // pass in url
            .map { $0.data }
            .decode(type: [MusicAlbum].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                print(completion) // value not used, should be check for error and completion
                switch completion {
                case .finished:
                    self?.isLoading = false
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.isLoading = false
                // should
//                self.cancellables.map{ $0.cancel() }
            } receiveValue: { [weak self] albums in
                print ("abc", albums)
                self?.albums = albums
            } .store(in: &cancellables)
    }
}

struct Albums: View
{ // needs to be on upper line
    // does it needs to be observed object
    @ObservedObject var viewModel:ViewModel = ViewModel(albums: []) // should not be provided here,  needs a value also no need for semi colon
    @State var isLoading: Bool = false
    var showDetailView: Bool = false
    var title: String?

    var body: some View {
        GeometryReader { proxy in
            if viewModel.isLoading { // bad check
                ProgressView()
                    .offset(x: proxy.size.width / 2,
                            y: proxy.size.height / 2)
            } else {
                NavigationView {
                    ScrollView { // needs to be there
                        LazyVStack {
                            ForEach(viewModel.albums) { album in
                                NavigationLink(isActive: $isLoading) {
                                    DetailView(coverarturl: URL(string: album.coverArtURL))
                                } label: {
                                    VStack {
                                        HStack {
                                            Text("Artist: ")
                                            Text(album.artist)
                                        }
                                        .font(.headline)
                                        HStack {
                                            Text("Album: ")
                                            Text(album.title)
                                                .font(.subheadline)
                                        }
                                    }
                                }
                            }
                        }
                        .toolbar(content: {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                } label: {
                                    Image(systemName: "plus")
                                }
                            }
                        })
                        .navigationTitle("My albums!")
                    }
                }
            }
        }
        .onAppear {
            viewModel.isLoading.toggle()
            viewModel.fetch_albums()
        }
    }
}

// should be in another view
struct DetailView: View
{
    var coverarturl: URL? // bad naming convention
    @State var coverArtData: Data?
    @State var cancellables = Set<AnyCancellable>()

    var body: some View {
        VStack {
            coverImage()
        }
        .onAppear {
//            DispatchQueue.main.async {
                coverarturl.map {
                    URLSession.shared.dataTaskPublisher(for: $0)
//                        .map { $0.data }
                        .receive(on: DispatchQueue.main)
                        .sink { completion in
                            print(completion) // value not used, should be check for error and completion
                            switch completion {
                            case .finished:
                                break
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        } receiveValue: { (data: Data,
                                           response: URLResponse) in
                            self.coverArtData = data
                        }
                        .store(in: &cancellables)
                }
//            }
        }
    }

    @ViewBuilder
    func coverImage() -> some View {
        if let coverArtData = coverArtData, let image = UIImage(data: coverArtData) {
            Image(uiImage: image)
        }
        EmptyView()

//        if coverArtData != nil { // can be done via guard
//            VStack {
//                Image(uiImage: UIImage(data: coverArtData!)!)
//           }
//        } else {
//            EmptyView()
//        }
    }
}

struct ContentView_Previews: PreviewProvider { // needs to inherit view provider
    static var previews: some View {
        Albums(viewModel: ViewModel(albums: mockAlbums))
    }
}

let mockAlbums: [MusicAlbum] = [MusicAlbum(title: "Foo", artist: "Bar", coverArtURL: "hr")]
