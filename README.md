
# Moneybox iOS Technical Challenge by Mantas Jakstas

### Development Environment:
 - Development Environment: Xcode 15
 - Minimum Target: iOS 13.

### Architecture 

- Adopted MVVM-C pattern to improve readability, maintainability, scalability and testability of iOS application. The Coordinator is responsible for navigation and flow control. I created a simplified version of the coordinator, I am not an expert on the coordinator pattern and there are better ways to implement it. For this little app, I wanted to keep it simple. When the token is expired the user goes to the login view to log in again. There is a better way to this feature, in the server and application
 
### Testing
- Unit tests were added to test the behavior of the application.

### Accessibility 
- Added a bit of accessibility features around the app.

### The UI
- The design is intentionally kept simple, utilising default fonts, and sizes and using moneybox colours.
- I used auto-layouts programmatically and checked constraints with the Reveal application to double-check.
- The application doesn't have localisation implemented but I made a currency formatter to show the right format to the user. This is important because, in certain regions, the order of the currency symbol is different, and also spells us the currency correctly when we use accessibility voice.

