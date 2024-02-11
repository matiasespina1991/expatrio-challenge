import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:expatrio_challenge/screens/dashboard_screen.dart';
import 'package:expatrio_challenge/providers/conectivity_provider.dart';
import 'package:expatrio_challenge/providers/current_user_data_provider.dart';
import 'package:expatrio_challenge/providers/current_user_tax_data_provider.dart';

class MockConnectivityProvider extends Mock implements ConnectivityProvider {}

class MockCurrentUserDataProvider extends Mock
    implements CurrentUserDataProvider {}

class MockCurrentUserTaxDataProvider extends Mock
    implements CurrentUserTaxDataProvider {}

void main() {
  Widget makeTestableWidget({required Widget child}) {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<ConnectivityProvider>(
            create: (_) => MockConnectivityProvider(),
          ),
          ChangeNotifierProvider<CurrentUserDataProvider>(
            create: (_) => MockCurrentUserDataProvider(),
          ),
          ChangeNotifierProvider<CurrentUserTaxDataProvider>(
            create: (_) => MockCurrentUserTaxDataProvider(),
          ),
        ],
        child: child,
      ),
    );
  }

  testWidgets('Data reloads when connectivity is available',
      (WidgetTester tester) async {
    // Arrange
    MockConnectivityProvider mockConnectivityProvider =
        MockConnectivityProvider();
    MockCurrentUserDataProvider mockUserDataProvider =
        MockCurrentUserDataProvider();
    MockCurrentUserTaxDataProvider mockUserTaxDataProvider =
        MockCurrentUserTaxDataProvider();

    when(mockConnectivityProvider.isConnected).thenReturn(true);

    // Act
    await tester.pumpWidget(makeTestableWidget(child: DashboardScreen()));

    // Assert
    verify(mockUserDataProvider.loadUserData()).called(1);
    verify(mockUserTaxDataProvider.loadUserTaxData()).called(1);
  });
}
