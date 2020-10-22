// class HomeScreen extends StatelessWidget {
//   const HomeScreen({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     AuthenticationBloc authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
//     return Scaffold(
//         body: Container(
//             child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//             Text("Home"),
//             RaisedButton(
//               onPressed: () {
//                 authenticationBloc.add(AuthenticationSignOut());
//                 authenticationBloc.add(CheckAuthentication());

//                 authenticationBloc.close();
//               },
//               child: Text("Sign Out")
//             )
//           ],
//       ),
//         ),
//     );
//   }
// }
