# Amir Morsy iOS Task based on Rick and Morty Characters API

This project is an iOS application that fetches and displays character information from the Rick and Morty API. Users can browse, filter, and view detailed information about their favorite characters.

## Instructions for Building and Running the Application

### Prerequisites
- macOS with Xcode 13 or later installed.
- Swift 5.5 or later.

### Steps to Build and Run
1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd <repository-folder>
   ```

2. Open the project in Xcode:
   ```bash
   open take-home-test-ios.xcodeproj
   ```

3. Select a simulator (e.g., iPhone 14 Pro) or a physical device.

4. Run the application by pressing `Cmd + R` or clicking the **Run** button in Xcode.

5. The application should launch, displaying a list of Rick and Morty characters fetched from the API.

## Assumptions and Decisions Made

1. **API and Data Handling**
   - The application assumes the Rick and Morty API will always be available and return data in the expected format.
   - A `RickandmortyAPIRequest` model was created to handle pagination, and the `RickandmortyAPIResponse` model maps the API response.

2. **Architecture**
   - The app follows an MVVM (Model-View-ViewModel) architecture for clear separation of concerns and better testability.
   - Combine is used for reactive programming to manage data flow between the ViewModel and the views.

3. **UI Design**
   - UIKit and SwiftUI are combined to leverage the strengths of both frameworks. For example, `CharacterRowView` uses SwiftUI for concise and dynamic UI creation, while `CharacterListViewController` and `CharacterDetailsViewController` use UIKit for navigation and table views.

4. **Filtering**
   - Users can filter characters by status (`Alive`, `Dead`, or `Unknown`) using a scrollable filter bar implemented in SwiftUI (`FilterScrollView`).

## Challenges Encountered and Solutions

### 1. **Combining SwiftUI and UIKit**
   - **Challenge:** Integrating SwiftUI components within UIKit views, especially for dynamic content like table view cells.
   - **Solution:** Used `UIHostingController` to embed `CharacterRowView` into `CharacterTableViewCell`, allowing the seamless use of SwiftUI within the UIKit-based table view.

### 2. **Reactive Programming with Combine**
   - **Challenge:** Managing publishers and subscriptions for handling API calls and UI updates.
   - **Solution:** Used `@Published` properties and `PassthroughSubject` to notify views of changes, and managed subscriptions with a `Set<AnyCancellable>` to avoid memory leaks.

### 3. **Handling Pagination**
   - **Challenge:** Fetching and appending data while maintaining responsiveness and avoiding duplicate API calls.
   - **Solution:** Implemented a `hasNext` property in the `CharacterListViewModel` to track if more pages are available and incremented `currentPage` only when necessary.

### 4. **Dynamic UI Updates**
   - **Challenge:** Ensuring the UI updates correctly when filters or data change.
   - **Solution:** Bound the filtered character list to the table view using Combine and implemented a filtering function in the `CharacterListViewModel` to dynamically update the data source.

### 5. **Custom Styling and Interaction**
   - **Challenge:** Designing reusable UI components like the filter buttons and ensuring consistent styling.
   - **Solution:** Created `FilterButton` and other reusable components with customizable properties for styling and interaction.

### 6. **Missing Clear Requirments**
   - **Challenge:** While the filter clearly shows three categories, there is no additional one for viewing all categories at once.
   - **Solution:** The filter considered to be a multi choice filter, so every filter can now be selected and unselected to allow the user to deselect all the filters allowing the list to return back to all characters without any filter.

By addressing these challenges, the project achieves a clean, maintainable, and responsive user experience.
