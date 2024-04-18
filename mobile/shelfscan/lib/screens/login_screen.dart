import 'package:ShelfScan/services/remote_services.dart';
import 'package:ShelfScan/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ShelfScan/navigation.dart';

class Login extends StatefulWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final RemoteServices _remoteServices = RemoteServices();

  final Box _boxLogin = Hive.box("login");

  final GlobalKey<FormState> _formKey = GlobalKey();
  final FocusNode _focusNodePassword  = FocusNode();

  final TextEditingController _controllerPhone    = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  bool _obscurePassword = true;
  
  @override
  Widget build(BuildContext context) {

    if (_boxLogin.get("loginStatus") ?? false) {
      return const Navigation();
    }

    return Scaffold(
      backgroundColor: AppColor.white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(height: 150),
              Text(
                "Добро пожаловать",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 10),
              Text(
                "Вход",
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 60),

              // PHONE NUMBER textfield
              TextFormField(
                controller: _controllerPhone,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Номер телефона",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onEditingComplete: () => _focusNodePassword.requestFocus(),
                validator: (String? value) {
                  if (value == null || value.isEmpty ) {
                    return "Введите номер телефона (8 xxx xxx xx xx).";
                  } 

                  return null;
                },
              ),

              const SizedBox(height: 10),
              
              // PASSWORD textfield
              TextFormField(
                controller: _controllerPassword,
                focusNode: _focusNodePassword,
                obscureText: _obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: "Пароль",
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: _obscurePassword
                          ? const Icon(Icons.visibility_outlined)
                          : const Icon(Icons.visibility_off_outlined)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Введите пароль.";
                  } 

                  return null;
                },
              ),

              const SizedBox(height: 60),
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColor.greenMAIN,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        // String phone = _controllerPhone.text.replaceAll(RegExp(r'[^\d]'), '');
                        // if (!phone.startsWith('7')) {
                        //   phone = '+7$phone';
                        // }

                        var password = _controllerPassword.text;
                        var loginSuccess = await _remoteServices.login(_controllerPhone.text, password);
                        if (loginSuccess != null) {
                          _boxLogin.put("loginStatus", true);

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const Navigation()),
                          );
                        } else {
                          showMessage(context);
                        }
                      }
                    },

                    child: const Text("Войти"),
                  ),
                  
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNodePassword.dispose();
    _controllerPhone.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  showMessage(BuildContext context) {
    FToast fToast = FToast();
    fToast.init(context);
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.redMAIN),
        color: Colors.white,
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.max, 
        children: [
          Expanded(
            child: Text(
              'Неверный номер телефона или пароль',
              style: TextStyle( 
                color: AppColor.redMAIN,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
    fToast.showToast(
      child: toast,
      toastDuration: const Duration(seconds: 3),
      gravity: ToastGravity.TOP,
    );
  }

}