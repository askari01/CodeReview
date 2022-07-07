code review by Farrukh Askari

10: we don't need to import UIKIt, because we are not using any UIKit classes
12: struct should also conform to Codable protocol
12: Music Album should also include cover art url
16: ID needs to be constant
20: opening brases should be on the same line as the declaration
22: isLoading should be boolean and needs to be a published variable like @Published var isLoading = true
29: wrong function naming convention fetch_albums() should be fetchAlbums()
30: URL should be validated 
33: completion should be preceeded by [weak self], but no need here as we aren't capturing self in the closure
33: should switch on completion results and update the isLoading published variable
35: albums should be preceeded by [weak self], we are capturing self in the closure
41: opening brases should be on the same line as the declaration
50: wrong check !false is equals to true, and checking it against isLoading is bad
56: lazyVStack needs to be embded in a scrollView
61: use $isLoading instead of binding
75: the closing parenthesis needs to be on every respective line instead of stacking them in one line
90: naming convention is odd, should be fetchAlbums()
95: again this view should be in a sperate file
96: parenthesis should be on the same line as the declaration
97: wrong function naming convention converturl should be convertURL
99: spelling mistake
106: dispatch call should be mentioned on receive rather than on complete block
124: coverArtData should use if let to check if it is nil else return empty view
125: Vstack is unnecessary
126: UIimage construct from data should be done on 124 after if-let
134: Previews needs to inherit from PreviewProvider
140: mockAlbum should provide convertURL value