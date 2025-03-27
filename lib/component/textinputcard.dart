
import 'package:flutter/material.dart';
import '../shared/colors.dart';
import '../shared/custom_text.dart';

class LoginInput extends StatelessWidget {
  const LoginInput({
    super.key,
    required this.editController,
    required this.type,
    required this.bgcolor,
    required this.curscolor,
    required this.hint,
  });
  final TextEditingController editController;
  final TextInputType type;
  final Color bgcolor;
  final Color curscolor;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: bgcolor,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: TextFormField(
                cursorColor: curscolor,
                onChanged: (value) {},
                controller: editController,
                keyboardType: type,
                validator: (value) {
                  return null;
                },
                maxLines: 1,
                onSaved: (onSavedval) {
                  editController.text = onSavedval!;
                },
                style: TextStyle(color: curscolor),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle:
                      TextStyle(color: blanc().withValues (alpha: 0.25), fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




class LoginInputReadOnly extends StatelessWidget {
  const LoginInputReadOnly({
    super.key,
    required this.editController,
    required this.type,
    required this.bgcolor,
    required this.curscolor,
    required this.hint,
  });
  final TextEditingController editController;
  final TextInputType type;
  final Color bgcolor;
  final Color curscolor;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: bgcolor,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: TextFormField(
                cursorColor: curscolor,
                onChanged: (value) {},
                readOnly: true,
                controller: editController,
                keyboardType: type,
                validator: (value) {
                  return null;
                },
                maxLines: 1,
                onSaved: (onSavedval) {
                  editController.text = onSavedval!;
                },
                style: TextStyle(color: curscolor),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle:
                  TextStyle(color: blanc().withValues (alpha: 0.25), fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}





class PasswordInput extends StatefulWidget {
  const PasswordInput({
    super.key,
    required this.passwordController,
    required this.taille,
  });
  final TextEditingController passwordController;
  final double taille;

  @override
  State<PasswordInput> createState() => _PasswordState();
}

class _PasswordState extends State<PasswordInput> {
  bool isHidden = true;
  bool load = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              color: blanc().withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: TextFormField(
                maxLines: 1,
                cursorColor: orange(),
                controller: widget.passwordController,
                keyboardType: TextInputType.text,
                onSaved: (onSavedval) {
                  widget.passwordController.text = onSavedval!;
                },
                obscureText: isHidden,
                validator: (val) {
                  return null;
                },
                style: TextStyle(
                  color: orange(),
                ),
                decoration: InputDecoration(
                  hintText: "Mot de passe",
                  hintStyle: TextStyle(color: orange()),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.lock,
                    color: orange(),
                  ),
                  suffixIcon: IconButton(
                    color: (isHidden) ? blanc() : orange(),
                    icon: Icon(
                        isHidden ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        isHidden = !isHidden;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class ContainerInputState extends StatelessWidget {
  const ContainerInputState(
      {super.key,
      required this.controllerEdit,
      required this.pathIcon,
      required this.hintText,
      required this.input});

  final TextEditingController controllerEdit;
  final String pathIcon;
  final String hintText;
  final TextInputType input;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.93,
      height: 48,
      padding: const EdgeInsets.only(left: 2.0, top: 1.0, bottom: 1.0),
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: orange())),
      child: Center(
        child: TextFormField(
          cursorColor: blanc(),
          onChanged: (value) {},
          controller: controllerEdit,
          keyboardType: input,
          validator: (value) {
            return null;
          },
          maxLines: 1,
          onSaved: (onSavedval) {
            controllerEdit.text = onSavedval!;
          },
          style: TextStyle(color: blanc()),
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Container(
              width: 50,
              decoration: BoxDecoration(
                  //borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                //scale: 0.25,
                image: AssetImage(pathIcon),
                fit: BoxFit.contain,
              )),
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              color: blanc().withValues(alpha: 0.5),
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class RowTitle extends StatelessWidget {
  const RowTitle({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 2.0),
          child: CustomText(
            title,
            tex: TailleText(context).soustitre * 1.0,
            textAlign: TextAlign.left,
            color: orange(),
          ),
        ),
      ],
    );
  }
}
