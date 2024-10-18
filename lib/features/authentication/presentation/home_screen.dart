import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_tutorial/features/authentication/presentation/cubit/authentication_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void getUsers() {
    context.read<AuthenticationCubit>().getUsers();
  }

  @override
  initState() {
    super.initState();

    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        } else if (state is UserCreated) {
          getUsers();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: state is GettingUsers
              ? const Center(child: CircularProgressIndicator())
              : (state is UsersLoaded)
                  ? ListView.builder(
                      itemCount: state.users.length,
                      itemBuilder: (context, index) {
                        final user = state.users[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user.avatar),
                          ),
                          title: Text(user.name),
                          subtitle: Text(user.createdAt),
                        );
                      },
                    )
                  : const Center(child: Text('No users')),
          floatingActionButton: FloatingActionButton.extended(
            label: const Text('Add User'),
            icon: const Icon(Icons.add),
            onPressed: () {
              context.read<AuthenticationCubit>().createUser(
                    name: 'John Doe',
                    avatar: 'https://randomuser.me/api/port',
                    createdAt: DateTime.now().toIso8601String(),
                  );
            },
          ),
        );
      },
    );
  }
}
