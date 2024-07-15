import 'package:events_app_exam/logic/bloc/auth/auth_bloc.dart';
import 'package:events_app_exam/ui/widgets/arrow_back_button.dart';
import 'package:events_app_exam/ui/widgets/custom_main_orange_button.dart';
import 'package:events_app_exam/ui/widgets/custom_text_form_field.dart';
import 'package:events_app_exam/utils/app_functions.dart';
import 'package:events_app_exam/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:flutter/scheduler.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _confirmPasswordTextController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = context.read<AuthBloc>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                'assets/images/tadbiro_logo.svg',
                height: 170,
                width: 170,
                fit: BoxFit.cover,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      'Ro\'yxatdan o\'tish',
                      style: AppTextStyles.comicSans.copyWith(fontSize: 25),
                    ),
                    const Gap(15),

                    //! email text field
                    CustomTextFormField(
                      hintText: 'Email',
                      isObscure: false,
                      validator: (p0) =>
                          AppFunctions.textValidator(p0, 'Email'),
                      textEditingController: _emailTextController,
                    ),
                    const Gap(15),

                    //! password text field
                    CustomTextFormField(
                      hintText: 'Parol',
                      isObscure: true,
                      validator: (p0) =>
                          AppFunctions.textValidator(p0, 'Parol'),
                      textEditingController: _passwordTextController,
                    ),
                    const Gap(15),

                    //! confirm password text field
                    CustomTextFormField(
                      hintText: 'Parolni tasdiqlang',
                      isObscure: true,
                      validator: (p0) {
                        if (_confirmPasswordTextController.text !=
                            _passwordTextController.text) {
                          return 'Parol, bir hil bo\'lishi kerak';
                        }
                        return null;
                      },
                      textEditingController: _confirmPasswordTextController,
                    ),
                    const Gap(15),

                    BlocConsumer<AuthBloc, AuthStates>(
                      listener: (context, state) {
                        if (state is LoadedAuthState) {
                          Navigator.of(context).pop();
                        }
                      },
                      builder: (context, state) {
                        if (state is LoadingAuthState) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return CustomMainOrangeButton(
                          buttonText: 'Ro\'yxatdan o\'tish',
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              try {
                                authBloc.add(
                                  RegisterUserEvent(
                                    email: _emailTextController.text,
                                    password: _passwordTextController.text,
                                  ),
                                );
                              } catch (e) {
                                AppFunctions.showErrorSnackBar(
                                  context,
                                  e.toString(),
                                );
                              }
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              BlocBuilder<AuthBloc, AuthStates>(
                builder: (context, state) {
                  if (state is LoadingAuthState) {
                    return const SizedBox();
                  } else {
                    return GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        'Tizimga kirish',
                        style: AppTextStyles.comicSans.copyWith(fontSize: 22),
                      ),
                    );
                  }
                },
              ),
              BlocListener<AuthBloc, AuthStates>(
                listener: (context, state) {
                  if (state is ErrorAuthState) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errorMessage)),
                      );
                    });
                  }
                },
                child: const SizedBox(),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}