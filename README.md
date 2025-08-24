# نظام إدارة المصنع - Factory Management System

A comprehensive Flutter application for factory management with Arabic RTL support, built using Clean Architecture and BLoC pattern.

## Features

### 🏭 Inventory Management
- Add, edit, and delete inventory items
- Track stock levels with low stock alerts
- Record inventory transactions (purchase, sale, return, production, waste)
- Search and filter inventory items
- Generate inventory reports

### 🏭 Production Tracking
- Create production orders for machines
- Track production status (pending, in progress, completed)
- Link production to inventory (automatic material deduction)
- Log machine breakdowns and maintenance

### 💰 Sales & Customer Management
- Track sales and customer information
- Manage invoices and payments
- Monitor pending payments
- Generate sales reports

### 📊 Accounting & Financial Reports
- Record journal entries for daily transactions
- Calculate profit and loss (monthly/yearly)
- Track expenses (salaries, electricity, maintenance, purchases)
- Generate financial reports (balance sheet, cash flow, P&L)

### 👥 Workers & Attendance Management
- Manage worker information and roles
- Track working hours and attendance
- Calculate salaries based on hours and overtime
- Generate worker reports

## Architecture

The application follows Clean Architecture principles with the following structure:

```
lib/
├── core/                    # Core utilities and constants
├── db/                      # Database helper and configuration
├── features/                # Feature modules
│   ├── inventory/          # Inventory management
│   │   ├── domain/         # Entities, repositories, use cases
│   │   ├── data/           # Data sources and repository implementations
│   │   └── presentation/   # UI, BLoC, widgets
│   ├── production/         # Production tracking
│   ├── sales/             # Sales management
│   ├── accounting/        # Financial management
│   └── workers/           # Worker management
└── widgets/               # Shared widgets
```

## Technology Stack

- **Framework**: Flutter 3.8+
- **State Management**: BLoC (flutter_bloc)
- **Database**: SQLite (sqflite)
- **Architecture**: Clean Architecture
- **UI**: Material 3 Design
- **Language**: Arabic (RTL support)
- **Localization**: flutter_localizations

## Getting Started

### Prerequisites

- Flutter SDK 3.8.0 or higher
- Dart SDK 3.8.0 or higher
- Android Studio / VS Code
- Git

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd masn3k
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
flutter run
```

### Database Setup

The application automatically creates the SQLite database with all necessary tables on first run. The database includes:

- **Inventory Tables**: items, inventory_transactions
- **Production Tables**: machines, production_orders, production_materials, machine_maintenance
- **Sales Tables**: customers, sales, sale_items, payments
- **Accounting Tables**: journal_entries, expenses
- **Workers Tables**: workers, attendance, salaries

## Usage

### Dashboard
- View quick statistics and summaries
- Access all major features through navigation
- Monitor low stock alerts and recent activities

### Inventory Management
1. **Add Items**: Click the + button to add new inventory items
2. **View Items**: Browse all items in the inventory tab
3. **Low Stock**: Check items with low stock levels
4. **Transactions**: Add and view inventory movements
5. **Reports**: Generate stock movement and low stock reports

### Navigation
- Use the bottom navigation bar to switch between features
- Each feature has its own dedicated page with full CRUD operations
- Search functionality available in most sections

## Development

### Adding New Features

1. Create the domain layer (entities, repositories)
2. Implement the data layer (data sources, repository implementations)
3. Create the presentation layer (BLoC, UI widgets)
4. Add navigation and integrate with the main app

### Code Style

- Follow Flutter/Dart conventions
- Use meaningful variable and function names
- Add comments for complex logic
- Maintain clean architecture separation

### Testing

```bash
# Run unit tests
flutter test

# Run widget tests
flutter test test/widget_test.dart
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please contact the development team or create an issue in the repository.

## Roadmap

- [ ] Complete production management module
- [ ] Complete sales management module
- [ ] Complete accounting module
- [ ] Complete workers management module
- [ ] Add data export functionality
- [ ] Implement backup and restore
- [ ] Add user authentication
- [ ] Add multi-language support
- [ ] Add offline mode
- [ ] Add push notifications for alerts
