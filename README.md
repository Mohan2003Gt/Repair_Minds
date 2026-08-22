# Repair Minds

A Flutter-based social platform for sharing and discovering repair and maintenance solutions. Users can post repair problems, solutions, and expertise while connecting with others in the community.

##  Overview

Repair Minds is a cross-platform mobile application built with Flutter that enables users to:
- Share repair and maintenance problems with detailed descriptions and images
- Discover solutions and experiences from other users
- Build professional profiles showcasing expertise and location
- Save posts for future reference
- Search for specific repair topics and solutions
- Authenticate securely with email/password authentication

##  Key Features

### Authentication & Account Management
- **User Registration**: Create new accounts with email verification
- **Login/Logout**: Secure authentication using Supabase
- **Password Reset**: Forgot password functionality with email verification
- **Account Confirmation**: Email confirmation for new accounts
- **Session Management**: Persistent user sessions across app restarts

### Posts & Content
- **Create Posts**: Share repair problems with:
  - Title and subtitle
  - Detailed problem description
  - Problem category/domain
  - Image upload support
  - Automatic timestamp
- **View Posts**: Browse a feed of posts from the community
- **Post Details**: View complete post information with images
- **Post Management**: Create and manage your own posts

### Saved Posts
- **Save Posts**: Bookmark posts for later reference
- **Saved Collection**: View all your saved posts in one place
- **Quick Access**: Easy retrieval of valuable repair solutions

### User Profiles
- **Profile Information**:
  - Username
  - First and last name
  - Avatar/Profile picture
  - Location/Place
  - Expertise domain
  - Bio/About section
- **Profile Viewing**: View other users' profiles
- **Profile Management**: Edit and update personal profile information

### Discovery
- **Search Functionality**: Find posts by keywords, topics, or users
- **Home Feed**: Scrollable feed of recent posts from the community
- **Navigation**: Easy access to all sections via bottom navigation

## Tech Stack

### Frontend
- **Framework**: Flutter 3.12.2+
- **Language**: Dart
- **State Management**: Provider 6.1.5+
- **UI Components**: Material Design 3

### Backend & Services
- **Database**: Supabase (PostgreSQL)
- **Authentication**: Supabase Auth
- **Storage**: Supabase Storage (for image uploads)
- **Real-time**: Supabase Real-time (for live updates)

### Key Dependencies
- **provider**: State management
- **supabase_flutter**: Backend services and authentication
- **image_picker**: Camera and gallery image selection
- **dio**: Advanced HTTP client with interceptors
- **shared_preferences**: Local data persistence
- **path_provider**: File system paths
- **cupertino_icons**: iOS-style icons

### Development Tools
- **flutter_launcher_icons**: App icon generation
- **flutter_native_splash**: Native splash screens
- **flutter_lints**: Code quality and best practices
- **flutter_test**: Widget testing framework

## Project Structure

```
lib/
├── main.dart                 # App entry point and initialization
├── reset_password_screen.dart
├── Models/
│   ├── post_model.dart      # Post data model
│   └── user_model.dart      # User profile model
├── Providers/
│   ├── auth_provider.dart   # Authentication state management
│   ├── post_provider.dart   # Posts state management
│   ├── profile_provider.dart # Profile state management
│   └── saved_posts_provider.dart # Saved posts state management
├── Screen/
│   ├── logs/
│   │   ├── login_screen.dart
│   │   ├── new_user_screen.dart
│   │   ├── forget_password.dart
│   │   └── ac_success_screen.dart
│   └── main_screens/
│       ├── bottom_nav_screen.dart # Main navigation container
│       ├── home_screen.dart       # Posts feed
│       ├── search_screen.dart     # Search functionality
│       ├── profile/               # Profile screens
│       ├── saved_posts_screen.dart
│       └── common_screen/         # Shared components
└── Services/
    ├── auth_service.dart    # Authentication API calls
    ├── post_service.dart    # Posts API calls
    └── profile_service.dart # Profile API calls
```

## Getting Started

### Prerequisites
- Flutter SDK 3.12.2 or higher
- Dart SDK
- Supabase project with authentication enabled
- Image picker plugin (already included)

### Installation

1. **Clone the repository**
   ```bash
   git clone [repository-url]
   cd repair_minds
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Supabase**
   - Update Supabase URL and Anon Key in `lib/main.dart`
   - Create required tables in Supabase:
     - `users` table for user profiles
     - `posts` table for posts

4. **Run the app**
   ```bash
   flutter run
   ```

### Platform-Specific Setup

**Android:**
```bash
flutter run -d android
```

**iOS:**
```bash
flutter run -d ios
```

**Web:**
```bash
flutter run -d web
```

## API Structure

### Authentication Service
- User registration and login
- Password reset functionality
- Session management
- Email verification

### Posts Service
- Create new posts with images
- Fetch all posts
- Fetch user's posts
- Fetch post details
- Delete posts

### Profile Service
- Fetch user profile
- Update profile information
- Upload profile picture
- Get user by ID

### Saved Posts Service
- Add post to saved collection
- Remove from saved posts
- Fetch all saved posts
- Check if post is saved

## UI/UX Features

- **Material Design 3**: Modern and consistent UI across all screens
- **Responsive Layout**: Adapts to different screen sizes
- **Bottom Navigation**: Quick access to Home, Search, Profile, and Saved Posts
- **Image Display**: Full image support in posts with lazy loading
- **Form Validation**: Input validation for user inputs
- **Loading States**: Visual feedback during API calls
- **Error Handling**: User-friendly error messages

## Configuration

### Environment Variables
```dart
SUPABASE_URL     # Your Supabase project URL
SUPABASE_ANON_KEY # Your Supabase anonymous key
```

### Local Storage
- User preferences stored using `shared_preferences`
- Offline support for cached data

## App Workflow

### User Registration Flow
1. User navigates to "New User" screen
2. Enters email, password, and personal details
3. Account confirmation email sent
4. Email verification required
5. Profile completion
6. Account ready to use

### Post Creation Flow
1. User selects "Create Post" option
2. Enters post title, subtitle, and problem description
3. Selects category/domain
4. Picks image from gallery/camera
5. Submits post to backend
6. Post appears in community feed

### Discovery Flow
1. User views home feed with recent posts
2. Can search for specific topics
3. Can save posts they find useful
4. Can view post author's profile
5. Can navigate to profile section to manage saved posts

## Contributing

Contributions are welcome! Please follow these guidelines:
1. Create a feature branch
2. Make your changes
3. Test thoroughly
4. Submit a pull request

## License

This project is private and intended for internal use only.

## Security

- Secure authentication via Supabase
- No sensitive data stored locally
- HTTPS for all API communications
- Email verification for account protection
- Password reset functionality for account recovery

## Future Enhancements

- Real-time notifications for comments and likes
- Direct messaging between users
- Post categories and filtering
- User reputation system
- Advanced search with filters
- Post comments and discussions
- Mobile app push notifications
- Offline mode for saved posts
